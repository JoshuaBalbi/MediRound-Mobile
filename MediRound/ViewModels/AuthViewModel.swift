import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var authError: String?

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, u in
            if let u = u {
                self?.user = User(
                    id: u.uid,
                    email: u.email ?? "",
                    displayName: u.displayName ?? ""
                )
            } else {
                self?.user = nil
            }
        }
    }

    func signIn(email: String, password: String) {
        isLoading = true
        authError = nil

        AuthService.shared.signIn(email: email, password: password) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.authError = error.localizedDescription
                }
            }
        }
    }

//    func signUp(email: String, password: String, displayName: String) {
//        isLoading = true
//        authError = nil
//        
//        
//        AuthService.shared.signUp(email: email, password: password) { [weak self] result in
//            DispatchQueue.main.async {
//                guard let self = self else { return }
//                self.isLoading = false
//
//                switch result {
//                case .failure(let error):
//                    self.authError = error.localizedDescription
//
//                case .success(let authResult):
//                    let fbUser = authResult.user
//
//                    let change = fbUser.createProfileChangeRequest()
//                    change.displayName = displayName
//
//                    change.commitChanges { error in
//                        if let error = error {
//                            DispatchQueue.main.async {
//                                self.authError = error.localizedDescription
//                            }
//                            return
//                        }
//
//                        // Reload to make sure we have the updated profile
//                        fbUser.reload { reloadError in
//                            DispatchQueue.main.async {
//                                if let reloadError = reloadError {
//                                    self.authError = reloadError.localizedDescription
//                                    return
//                                }
//
//                                let updated = Auth.auth().currentUser ?? fbUser
//
//                                // 🔑 Update the published user so UI sees the display name immediately
//                                self.user = User(
//                                    id: updated.uid,
//                                    email: updated.email ?? email,
//                                    displayName: updated.displayName ?? displayName
//                                )
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
    func signUp(email: String, password: String, displayName: String) {
        isLoading = true
        authError = nil

        AuthService.shared.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .failure(let error):
                    self.authError = error.localizedDescription

                case .success(let authResult):
                    let fbUser = authResult.user

                    let change = fbUser.createProfileChangeRequest()
                    change.displayName = displayName

                    change.commitChanges { error in
                        if let error = error {
                            DispatchQueue.main.async {
                                self.authError = error.localizedDescription
                            }
                            return
                        }

                        // Reload to make sure we have the updated profile
                        fbUser.reload { reloadError in
                            if let reloadError = reloadError {
                                DispatchQueue.main.async {
                                    self.authError = reloadError.localizedDescription
                                }
                                return
                            }

                            let updated = Auth.auth().currentUser ?? fbUser
                            let uid = updated.uid
                            let emailToUse = updated.email ?? email
                            let nameToUse = updated.displayName ?? displayName

                            // 🔥 Save user info to Firestore users/{uid}
                            let db = Firestore.firestore()
                            db.collection("user").document(uid).setData([
                                "name": nameToUse,
                                "email": emailToUse,
                                "role": "staff"
                            ], merge: true) { dbError in
                                DispatchQueue.main.async {
                                    if let dbError = dbError {
                                        // Optional: surface this or just log it
                                        print("Error saving user document: \(dbError.localizedDescription)")
                                    }

                                    // ✅ Update your app's user model so UI sees the name immediately
                                    self.user = User(
                                        id: uid,
                                        email: emailToUse,
                                        displayName: nameToUse
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    func signOut() {
        AuthService.shared.signOut()
        user = nil
    }
}


