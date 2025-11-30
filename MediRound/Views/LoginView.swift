//
//  LoginView.swift
//  MediRound
//
//  Created by Diego Balbi on 11/18/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Text("MediRound Login")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 20)

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
                    ProgressView().padding(.top, 5)
                }

                Button {
                    authVM.signIn(email: email, password: password)
                } label: {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty || password.isEmpty)

                NavigationLink("Create Account") {
                    SignupView(authVM: authVM)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
        }
    }
}

//import SwiftUI
//
//struct LoginView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @ObservedObject var authVM: AuthViewModel
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//
//                Text("MediRound Login")
//                    .font(.largeTitle.bold())
//                    .padding(.bottom, 20)
//
//                TextField("Email", text: $email)
//                    .textFieldStyle(.roundedBorder)
//                    .autocapitalization(.none)
//                    .disableAutocorrection(true)
//
//                SecureField("Password", text: $password)
//                    .textFieldStyle(.roundedBorder)
//
//                // Firebase error message
//                if let error = authVM.authError {
//                    Text(error)
//                        .foregroundColor(.red)
//                        .font(.callout)
//                        .padding(.top, 5)
//                }
//
//                if authVM.isLoading {
//                    ProgressView().padding(.top, 5)
//                }
//
//                Button {
//                    authVM.signIn(email: email, password: password)
//                } label: {
//                    Text("Sign In")
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.borderedProminent)
//                .disabled(email.isEmpty || password.isEmpty)
//
//                NavigationLink("Create Account") {
//                    SignupView(authVM: authVM)
//                }
//                .padding(.top, 10)
//
//                Spacer()
//            }
//            .padding()
//        }
//    }
//}

//import SwiftUI
//
//struct LoginView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @ObservedObject var authVM: AuthViewModel
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//
//                Text("MediRound Login")
//                    .font(.largeTitle.bold())
//                    .padding(.bottom, 20)
//
//                TextField("Email", text: $email)
//                    .textFieldStyle(.roundedBorder)
//                    .autocapitalization(.none)
//                    .disableAutocorrection(true)
//
//                SecureField("Password", text: $password)
//                    .textFieldStyle(.roundedBorder)
//
//                if authVM.isLoading {
//                    ProgressView().padding(.top, 5)
//                }
//
//                Button {
//                    authVM.signIn(email: email, password: password)
//                } label: {
//                    Text("Sign In")
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.borderedProminent)
//                .disabled(email.isEmpty || password.isEmpty)
//
//                NavigationLink("Create Account") {
//                    SignupView(authVM: authVM)
//                }
//                .padding(.top, 10)
//
//                Spacer()
//            }
//            .padding()
//        }
//    }
//}
