//  CheckInView.swift
//  MediRound
//
//  Created by Joshua Balbi on 11/18/25.
//
//
import SwiftUI
import FirebaseAuth

struct CheckInView: View {
    @ObservedObject var vm: PatientViewModel
    @ObservedObject var authVM: AuthViewModel
    
    @State private var checkedInName: String = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.patients) { patient in
                    Button {
                        performCheckIn(patient)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            
                            // NAME
                            Text(patient.name)
                                .font(.headline)
                            
                            // LOCATION
                            Text("Location: \(patient.location)")
                                .font(.caption)
                            
                            
//                            // LAST REAL CHECK-IN
//                            if let last = patient.checkIns.last {
//                                let formatted = last.time.formatted(date: .omitted, time: .shortened)
//                                Text("Last checked in: \(formatted)")
//                                    .foregroundColor(.gray)
//
//                            }
                            
                            Text("Last checked in: \(lastCheckInDisplay(for: patient))")
                                .foregroundColor(.gray)
                            
                            
                            // STATUS UI (SLOT-BASED)
                            if isMissed(patient) {
                                Text("⚠️ MISSED")
                                    .foregroundColor(.red)
                                    .bold()
                            }
                            else if isCheckInAllowed(patient) {
                                Text("Check-in allowed")
                                    .foregroundColor(.blue)
                            }
                            else {
                                Text("Checked in this slot")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .disabled(!isCheckInAllowed(patient))  // Only allow 1 per slot
                }
            }
            .navigationTitle("Check In")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Checked In"),
                    message: Text("Successfully checked in \(checkedInName)."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    
    // MARK: - Perform REAL Check-In
    private func performCheckIn(_ patient: Patient) {
        checkedInName = patient.name
        let staff = authVM.user?.email ?? "Unknown Staff"
        
        PatientService.shared.recordCheckIn(patient: patient, staffName: staff)
        showAlert = true
    }
    
    private func lastCheckInDisplay(for patient: Patient) -> String {
        // Find last REAL check-in (staff not empty)
        if let lastReal = patient.checkIns.last(where: { !($0.staff).trimmingCharacters(in: .whitespaces).isEmpty }) {

            let elapsed = Date().timeIntervalSince(lastReal.time)
            let oneDay: TimeInterval = 24 * 60 * 60

            if elapsed > oneDay {
                return "1+ day ago"
            } else {
                return lastReal.time.formatted(date: .omitted, time: .shortened)
            }
        }

        return "No check-ins yet"
    }
    
    
    // ============================================================
    // MARK: - SLOT-BASED LOGIC (Correct Rounding System)
    // ============================================================

    /// Slot start time (e.g., 2:00, 2:15, 2:30, 2:45)
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

    /// Has the patient checked in THIS time slot?
    private func hasCheckedInThisSlot(_ patient: Patient) -> Bool {
        guard let last = patient.checkIns.last?.time else { return false }

        let slotStart = currentSlotStart(interval: patient.checkInInterval)
        
        return last >= slotStart
    }

    /// Check-in allowed = NOT already checked in this slot
    private func isCheckInAllowed(_ patient: Patient) -> Bool {
        return !hasCheckedInThisSlot(patient)
    }

    /// Missed = slot ended AND not checked in this slot
    private func isMissed(_ patient: Patient) -> Bool {
        let intervalSec = Double(patient.checkInInterval) * 60
        let slotStart = currentSlotStart(interval: patient.checkInInterval)
        let slotEnd = slotStart.addingTimeInterval(intervalSec)

        return Date() >= slotEnd && !hasCheckedInThisSlot(patient)
    }
}
