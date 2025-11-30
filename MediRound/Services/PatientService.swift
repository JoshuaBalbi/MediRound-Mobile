//
//  BluetoothService.swift
//  MediRound
//
//  Created by Diego Balbi on 11/18/25.
//

import Foundation
import FirebaseFirestore

class PatientService {
    static let shared = PatientService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Listen to Patients
    func listenToPatients(completion: @escaping ([Patient]) -> Void) {
        
        db.collection("patients")
            .order(by: "name")
            .addSnapshotListener { snapshot, error in
                
                var results: [Patient] = []
                let docs = snapshot?.documents ?? []
                
                for doc in docs {
                    let data = doc.data()
                    
                    let name = data["name"] as? String ?? ""
                    let location = data["location"] as? String ?? ""
                    let checkInInterval = data["checkInInterval"] as? Int ?? 0
                    let comments = data["comments"] as? String
                    let wristbandID = data["wristbandID"] as? String ?? ""
                    let createdAtTS = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())
                    let createdAt = createdAtTS.dateValue()
                    
                    let rawCheckIns = data["checkIns"] as? [[String: Any]] ?? []
                    
                    let checkIns = rawCheckIns.compactMap { entry -> CheckInRecord? in
                        guard let ts = entry["time"] as? Timestamp else { return nil }
                        let staff = entry["staff"] as? String ?? ""
                        return CheckInRecord(time: ts.dateValue(), staff: staff)
                    }
                        .sorted { $0.time < $1.time }
                    
                    let patient = Patient(
                        id: doc.documentID,
                        name: name,
                        location: location,
                        checkInInterval: checkInInterval,
                        comments: comments,
                        wristbandID: wristbandID,
                        checkIns: checkIns,
                        createdAt: createdAt
                    )
                    
                    // 🔥 SAFE missed-record logic (no auto-check-ins)
                    self.writeMissedIfNeeded(for: patient)
                    
                    results.append(patient)
                }
                
                completion(results)
            }
    }
    
    
    // MARK: - Add Patient
    func addPatient(_ patient: Patient) {
        let data: [String: Any] = [
            "name": patient.name,
            "location": patient.location,
            "checkInInterval": patient.checkInInterval,
            "comments": patient.comments as Any,
            "wristbandID": patient.wristbandID,
            "createdAt": Timestamp(date: patient.createdAt),
            "checkIns": [] as [[String: Any]]
        ]
        
        db.collection("patients").addDocument(data: data)
    }
    
    
    // MARK: - Delete Patient
    func deletePatient(_ patient: Patient) {
        guard let id = patient.id else { return }
        db.collection("patients").document(id).delete()
    }
    
    
    // MARK: - Record REAL Check-In by Staff
    func recordCheckIn(patient: Patient, staffName: String) {
        guard let id = patient.id else { return }
        
        let newRecord: [String: Any] = [
            "time": Timestamp(date: Date()),
            "staff": staffName
        ]
        
        db.collection("patients").document(id)
            .updateData([
                "checkIns": FieldValue.arrayUnion([newRecord])
            ])
    }
    
    
    // ====================================================================
    // MARK: - SLOT-BASED MISSED LOGIC (UI + Firestore Safe)
    // ====================================================================
    
    /// Determine current slot start based on interval
    private func currentSlotStart(interval: Int) -> Date {
        let now = Date()
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: now)
        
        let slotMinute = (minute / interval) * interval
        
        return calendar.date(
            bySettingHour: calendar.component(.hour, from: now),
            minute: slotMinute,
            second: 0,
            of: now
        )!
    }
    
    /// Slot start for ANY date (used to calculate all past slots)
    private func slotStart(at date: Date, interval: Int) -> Date {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        
        let slotMinute = (minute / interval) * interval
        
        return calendar.date(
            bySettingHour: calendar.component(.hour, from: date),
            minute: slotMinute,
            second: 0,
            of: date
        )!
    }
    
    /// Determine if the patient has already checked in this slot
    private func hasCheckedInThisSlot(_ patient: Patient, slotStart: Date) -> Bool {
        guard let last = patient.checkIns.last?.time else { return false }
        return last >= slotStart
    }
    
    /// WRITE missed entry ONLY IF:
    /// - Slot ended
    /// - Patient not checked in this slot
    /// - Missed entry not already recorded
    ///
    
    func writeMissedIfNeeded(for patient: Patient) {
        guard let id = patient.id else { return }
        
        let interval = patient.checkInInterval
        let intervalSeconds = Double(interval) * 60
        let now = Date()
        
        // ---- SLOT REFERENCES ----
        let currentSlot = currentSlotStart(interval: interval)
        let previousSlot = currentSlot.addingTimeInterval(-intervalSeconds)
        
        // Only process AFTER previous slot fully ends
        let previousSlotEnd = previousSlot.addingTimeInterval(intervalSeconds)
        guard now >= previousSlotEnd else { return }
        
        // Last real check-in OR createdAt
        let lastReal = patient.checkIns.last?.time ?? patient.createdAt
        
        // Generate slot-aligned start for lastReal
        var expected = slotStart(at: lastReal, interval: interval)
        
        // Will accumulate missed entries
        var missedEntries: [[String: Any]] = []
        let existingTimes = Set(patient.checkIns.map { $0.time.timeIntervalSince1970 })
        
        while expected <= previousSlot {
            let slotEnd = expected.addingTimeInterval(intervalSeconds)
            
            // Only mark missed if slot ended
            if now >= slotEnd &&
                !existingTimes.contains(expected.timeIntervalSince1970) {
                
                missedEntries.append([
                    "time": Timestamp(date: expected),
                    "staff": ""
                ])
            }
            
            expected = expected.addingTimeInterval(intervalSeconds)
        }
        
        // Write ALL missed entries at once (if any)
        if !missedEntries.isEmpty {
            db.collection("patients").document(id)
                .updateData([
                    "checkIns": FieldValue.arrayUnion(missedEntries)
                ])
        }
    }
}
