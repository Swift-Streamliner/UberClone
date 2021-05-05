//
//  HomeController.swift
//  UberClone
//
//  Created by Tiger Mei on 05.05.2021.
//

import UIKit
import FirebaseAuth


class HomeController : UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        checkIfUserIsLoggedIn()
        view.backgroundColor = .red
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            print("DEBUG: User is not logged in.")
        } else {
            print("DEBUG: User id \(Auth.auth().currentUser?.uid)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Error sign out.")
        }
    }
}
