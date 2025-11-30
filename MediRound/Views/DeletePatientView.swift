//
//  DeletePatientView.swift
//  MediRound
//
//  Created by Diego Balbi on 11/19/25.
//


//import SwiftUI
//
//struct DeletePatientView: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var vm: PatientViewModel
//
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(vm.patients) { patient in
//                    VStack(alignment: .leading) {
//                        Text(patient.name).font(.headline)
//                        Text("Location: \(patient.location)").foregroundColor(.gray)
//                        Text("Wristband: \(patient.wristbandID)").foregroundColor(.gray)
//                    }
//                }
//                .onDelete(perform: vm.delete)
//            }
//            .navigationTitle("Delete Patient")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Close") { dismiss() }
//                }
//            }
//        }
//    }
//}

import SwiftUI

struct DeletePatientView: View {
    @ObservedObject var vm: PatientViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.patients) { patient in
                    VStack(alignment: .leading) {
                        Text(patient.name)
                            .font(.headline)
                        Text("Location: \(patient.location)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: vm.deletePatient)
            }
            .navigationTitle("Delete Patient")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Delete Patient").font(.headline)
                }
            }
        }
    }
}

