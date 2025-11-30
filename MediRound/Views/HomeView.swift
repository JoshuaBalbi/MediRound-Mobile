import SwiftUI

struct HomeView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject var patientVM = PatientViewModel()

    @State private var showCheckIn = false
    @State private var showAddPatient = false
    @State private var showDeletePatient = false
    @State private var isScanning = false
    @State private var showSignOutAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {

                // MAIN CONTENT
                if isScanning {
                    Spacer()

                    VStack(spacing: 8) {
                        ProgressView()
                        Text("Scanning for patients…")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }

                    Spacer()

                    // No buttons when scanning
                } else {
                    Spacer()

                    // BIG Check In button
                    Button {
                        startScan()
                    } label: {
                        Text("Check In")
                            .font(.system(size: 26, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(radius: 4)
                            .padding(.horizontal, 24)
                    }

                    Spacer()

                    // Bottom Add/Delete buttons
                    HStack(spacing: 16) {
                        Button {
                            showAddPatient = true
                        } label: {
                            Text("Add Patient")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }

                        Button {
                            showDeletePatient = true
                        } label: {
                            Text("Delete Patient")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32) // tuck them to the bottom
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(authVM.user?.displayName ?? "")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSignOutAlert = true
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .imageScale(.large)
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authVM.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .sheet(isPresented: $showCheckIn) {
                CheckInView(vm: patientVM, authVM: authVM)
            }
            .sheet(isPresented: $showAddPatient) {
                AddPatientView(vm: patientVM)
            }
            .sheet(isPresented: $showDeletePatient) {
                DeletePatientView(vm: patientVM)
            }
        }
    }

    private func startScan() {
        isScanning = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isScanning = false
            showCheckIn = true
        }
    }
}
