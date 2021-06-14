//
//  Service.swift
//  UberClone
//
//  Created by Tiger Mei on 19.05.2021.
//

import Firebase
import GeoFire

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")

struct Service {
    
    static let shared = Service()
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        print("DEBUG: fetchUserData for uid = \(uid)")
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let userUid = snapshot.key
            completion(User(uid: userUid, dictionary: dictionary))
        }
    }
    
    func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void) {
        let geoFire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        REF_DRIVER_LOCATIONS.observe(.value) { snapshot in
            geoFire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                print("DEBUG: uid = \(uid)")
                print("DEBUG: Location = \(location.coordinate)")
                self.fetchUserData(uid: uid){ user in
                    var driver = user
                    driver.location = location
                    completion(driver)
                }
            })
        }
    }
    
}
