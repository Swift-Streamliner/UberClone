//
//  HomeController.swift
//  UberClone
//
//  Created by Tiger Mei on 05.05.2021.
//

import UIKit
import FirebaseAuth
import MapKit


class HomeController : UIViewController {
    
    // MARK: - Properties
    private let mapView: MKMapView = MKMapView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        checkIfUserIsLoggedIn()
        //signOut()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            let login = LoginController()
            //nav.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(login, animated: true)
            print("DEBUG: User is not logged in.")
        } else {
            print("DEBUG: User id \(Auth.auth().currentUser?.uid)")
            configureUI()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Error sign out.")
        }
    }
    
    // MARK: - Helper functions
    func configureUI() {
        view.addSubview(mapView)
        mapView.frame = view.frame
    }
}
