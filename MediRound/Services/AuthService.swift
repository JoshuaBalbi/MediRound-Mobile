//
//  AuthService.swift
//  MediRound
//
//  Created by Diego Balbi on 11/19/25.
//
import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private init() {}

    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                completion(.success(result))
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
    }
}


