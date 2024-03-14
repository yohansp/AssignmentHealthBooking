//
//  UserRepository.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 13/03/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserRepository {
    
    private var db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    func saveUser(_ email: String, password: String,
                  fullname: String, mobile: String, address: String) async throws -> String {
        do {
            let authResponse = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let users = db.collection("users")
            try await users.document(authResponse.user.uid).setData([
                "email": email,
                "fullname": fullname,
                "mobile": mobile,
                "address": address
            ])
        } catch {
            return error.localizedDescription
        }
        return "OK"
    }
    
    func signIn(_ email: String, password: String) async -> User? {
        do {
            let response = try await Auth.auth().signIn(withEmail: email, password: password)
            return response.user
        } catch {
            return nil
        }
    }
}
