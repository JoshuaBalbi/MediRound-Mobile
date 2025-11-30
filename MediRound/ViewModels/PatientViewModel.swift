//
//  PatientViewModel.swift
//  MediRound
//
//  Created by Diego Balbi on 11/19/25.
//

import Foundation


class PatientViewModel: ObservableObject {
    @Published var patients: [Patient] = []

    // Form fields for AddPatientView
    @Published var name: String = ""
    @Published var location: String = ""
    @Published var checkInInterval: Int = 15
    @Published var comments: String = ""
    @Published var wristbandID: String = ""

    init() {
        PatientService.shared.listenToPatients { [weak self] list in
            DispatchQueue.main.async {
                self?.patients = list
            }
        }
    }

    // MARK: - Add Patient via Service
    func addPatient() {
        let roundedCreatedAt = roundDate(Date(), toInterval: checkInInterval)

        let newPatient = Patient(
            id: nil,
            name: name,
            location: location,
            checkInInterval: checkInInterval,
            comments: comments.isEmpty ? nil : comments,
            wristbandID: wristbandID,
            checkIns: [],
            createdAt: roundedCreatedAt   // NEW
        )

        PatientService.shared.addPatient(newPatient)

        name = ""
        location = ""
        checkInInterval = 15
        comments = ""
        wristbandID = ""
    }

    // MARK: - Delete Patient via Service
    func deletePatient(at offsets: IndexSet) {
        for index in offsets {
            let patient = patients[index]
            PatientService.shared.deletePatient(patient)
        }
    }
}

func roundDate(_ date: Date, toInterval minutes: Int) -> Date {
    let intervalSeconds = Double(minutes * 60)
    let time = date.timeIntervalSinceReferenceDate
    let rounded = (time / intervalSeconds).rounded() * intervalSeconds
    return Date(timeIntervalSinceReferenceDate: rounded)
}

