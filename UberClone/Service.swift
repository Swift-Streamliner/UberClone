//
//  Service.swift
//  UberClone
//
//  Created by Tiger Mei on 19.05.2021.
//

import Firebase

let DB_REF = Database.database().reference()
let USERS_REF = DB_REF.child("users")

struct Service {
    
    static let shared = Service()
    let currentId = Auth.auth().currentUser?.uid
    
    func fetchUserData(completion: @escaping(User) -> Void) {
        print("DEBUG: Current uid is \(currentId!)")
        USERS_REF.child(currentId!).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            completion(User(dictionary: dictionary))
        }
    }
}
