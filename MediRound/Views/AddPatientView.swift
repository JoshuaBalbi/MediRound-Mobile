//
//  AddPatientView.swift
//  MediRound
//
//  Created by Diego Balbi on 11/19/25.
//

//
//import SwiftUI
//
//struct AddPatientView: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var vm: PatientViewModel
//
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section("Patient Information") {
//                    TextField("Patient Name", text: $vm.name)
//                    TextField("Location (A-wing, B-wing)", text: $vm.location)
//
//                    Stepper("Check-in Interval: \(vm.checkInInterval) minutes",
//                            value: $vm.checkInInterval,
//                            in: 5...120,
//                            step: 5)
//                }
//
//                Section("Wristband") {
//                    TextField("Wristband Number", text: $vm.wristbandID)
//                }
//
//                Section("Comments") {
//                    TextField("Comments (optional)", text: $vm.comments)
//                }
//            }
//            .navigationTitle("Add Patient")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Save") {
//                        vm.addPatient()
//                        dismiss()
//                    }
//                    .disabled(vm.name.isEmpty || vm.location.isEmpty || vm.wristbandID.isEmpty)
//                }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") { dismiss() }
//                }
//            }
//        }
//    }
//}

import SwiftUI

struct AddPatientView: View {
    @ObservedObject var vm: PatientViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Patient Info")) {
                    TextField("Name", text: $vm.name)
                    TextField("Location (A-wing, B-wing…)", text: $vm.location)
                    TextField("Wristband ID", text: $vm.wristbandID)
                }

                Section(header: Text("Check-In Settings")) {
                    Stepper("Interval: \(vm.checkInInterval) min",
                            value: $vm.checkInInterval,
                            in: 15...60,
                            step: 15)
                }

                Section(header: Text("Comments")) {
                    TextField("e.g. Post surgery, hip fracture", text: $vm.comments)
                }
            }
            .navigationTitle("Add Patient")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        vm.addPatient()
                        dismiss()
                    }
                    .disabled(vm.name.isEmpty || vm.location.isEmpty || vm.wristbandID.isEmpty)
                }
            }
        }
    }
}
