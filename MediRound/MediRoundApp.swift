//
//  MediRoundApp.swift
//  MediRound
//
//  Created by Diego Balbi on 11/18/25.
//

import SwiftUI
import FirebaseCore

@main
struct MediRoundApp: App {
    @StateObject var authVM = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authVM.user != nil {
                HomeView(authVM: authVM)
            } else {
                LoginView(authVM: authVM)
            }
        }
    }
}


//import SwiftUI
//import Firebase
//
//@main
//struct MediRoundApp: App {
//    @StateObject var authVM = AuthViewModel()
//
//    // Initialize Firebase
//    init() {
//        FirebaseApp.configure()
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            NavigationStack {
//                if let _ = authVM.user {
//                    HomeView(authVM: authVM)
//                } else {
//                    LoginView(authVM: authVM)
//                }
//            }
//        }
//    }
//}



    
