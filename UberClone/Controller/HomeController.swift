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
    private let locationManager = CLLocationManager()
    private let locationInputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        checkIfUserIsLoggedIn()
        enableLocationServices()
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
        configureMapView()
        view.addSubview(locationInputActivationView)
        locationInputActivationView.centerX(inView: view)
        locationInputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        locationInputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        locationInputActivationView.alpha = 0
        locationInputActivationView.delegate = self
        
        UIView.animate(withDuration: 2) {
            self.locationInputActivationView.alpha = 1
        }
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func configureLocationInputView() {
        locationInputView.delegate = self
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
        locationInputView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.locationInputView.alpha = 1
        }) { _ in
            print("DEBUG: present table view.")
        }
    }
}

// MARK: - Location Services

extension HomeController : CLLocationManagerDelegate {
    func enableLocationServices() {
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("DEBUG: notDetermind.")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("DEBUG: restricted.")
        case .denied:
            print("DEBUG: denied.")
        case .authorizedAlways:
            print("DEBUG: authorizedAlways.")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: authorizedWhenInUse.")
            locationManager.requestAlwaysAuthorization()
        default:
            print("DEBUG: default.")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
}

extension HomeController: LocationInputActivationViewDelegate {
    
    func presentLocationInputView() {
        locationInputActivationView.alpha = 0
        configureLocationInputView()
    }
}

extension HomeController: LocationInputViewDelegate {
    
    func dismissLocationInputView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: { self.locationInputActivationView.alpha = 1 })
        }
    }
}
