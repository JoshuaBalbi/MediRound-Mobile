//
//  SignupView.swift
//  MediRound
//
//  Created by Diego Balbi on 11/18/25.
//

//import SwiftUI
//
//struct SignupView: View {
//    @ObservedObject var authVM: AuthViewModel
//
//    @State private var displayName = ""
//    @State private var email = ""
//    @State private var password = ""
//
//    var body: some View {
//        VStack(spacing: 20) {
//
//            Text("Create Account")
//                .font(.title2.bold())
//                .padding(.bottom, 20)
//
//            TextField("Full Name", text: $displayName)
//                .textFieldStyle(.roundedBorder)
//
//            TextField("Email", text: $email)
//                .textFieldStyle(.roundedBorder)
//                .autocapitalization(.none)
//                .disableAutocorrection(true)
//
//            SecureField("Password", text: $password)
//                .textFieldStyle(.roundedBorder)
//
//            // Firebase error message
//            if let error = authVM.authError {
//                Text(error)
//                    .foregroundColor(.red)
//                    .font(.callout)
//            }
//
//            if authVM.isLoading {
//                ProgressView()
//            }
//
//            Button {
//                authVM.signUp(email: email,
//                              password: password,
//                              displayName: displayName)
//            } label: {
//                Text("Sign Up")
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
//            .disabled(displayName.isEmpty || email.isEmpty || password.isEmpty)
//
//            Spacer()
//        }
//        .padding()
//    }
//}
import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @ObservedObject var authVM: AuthViewModel

    @State private var displayName = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {

            Text("Create Account")
                .font(.title2.bold())
                .padding(.bottom, 20)

            TextField("Full Name", text: $displayName)
                .textFieldStyle(.roundedBorder)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if let error = authVM.authError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.callout)
            }

            if authVM.isLoading {
                ProgressView()
            }

            Button {
                authVM.signUp(email: email, password: password, displayName: displayName)
            } label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(displayName.isEmpty || email.isEmpty || password.isEmpty)

            Spacer()
        }
        .padding()
    }
}

//import FirebaseAuth
//import SwiftUI
//
//struct SignupView: View {
//    @ObservedObject var authVM: AuthViewModel
//
//    @State private var displayName = ""
//    @State private var email = ""
//    @State private var password = ""
//
//    var body: some View {
//        VStack(spacing: 20) {
//
//            Text("Create Account")
//                .font(.title2.bold())
//                .padding(.bottom, 20)
//
//            TextField("Full Name", text: $displayName)
//                .textFieldStyle(.roundedBorder)
//
//            TextField("Email", text: $email)
//                .textFieldStyle(.roundedBorder)
//                .autocapitalization(.none)
//                .disableAutocorrection(true)
//
//            SecureField("Password", text: $password)
//                .textFieldStyle(.roundedBorder)
//
//            if authVM.isLoading {
//                ProgressView()
//            }
//
//            Button {
//                authVM.signUp(email: email, password: password)
//                
//                // Update Firebase displayName after sign-up completes
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    if let user = Auth.auth().currentUser {
//                        let change = user.createProfileChangeRequest()
//                        change.displayName = displayName
//                        change.commitChanges { _ in }
//                    }
//                }
//
//            } label: {
//                Text("Sign Up")
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
//            .disabled(displayName.isEmpty || email.isEmpty || password.isEmpty)
//
//            Spacer()
//        }
//        .padding()
//    }
//}
