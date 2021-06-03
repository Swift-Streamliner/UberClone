//
//  HomeController.swift
//  UberClone
//
//  Created by Tiger Mei on 05.05.2021.
//

import UIKit
import FirebaseAuth
import MapKit

private let reuseIdentifier = "LocationCell"

class HomeController : UIViewController {
    
    // MARK: - Properties
    private let mapView: MKMapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    private let locationInputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private var user: User? {
        didSet {
            locationInputView.user = user
        }
    }
    
    private final let locationInputViewHeight: CGFloat = 200
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        checkIfUserIsLoggedIn()
        enableLocationServices()
        fetchUserData()
        //signOut()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - API
    
    func fetchUserData() {
        Service.shared.fetchUserData(){ user in
            print("DEBUG: fullname in controller is \(user.fullname)")
            self.user = user
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            let login = LoginController()
            //nav.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(login, animated: true)
            print("DEBUG: User is not logged in.")
        } else {
            print("DEBUG: User id \(Auth.auth().currentUser?.uid ?? "nil")")
            configureUI()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let login = LoginController()
            navigationController?.pushViewController(login, animated: true)
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
        configureTableView()
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
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: locationInputViewHeight)
        locationInputView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            })
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height , width: view.frame.width, height: height)
        view.addSubview(tableView)
    }
}

// MARK: - Location Services

extension HomeController {
    func enableLocationServices() {
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            print("DEBUG: notDetermind.")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted:
            print("DEBUG: restricted.")
        case .denied:
            print("DEBUG: denied.")
        case .authorizedAlways:
            print("DEBUG: authorizedAlways.")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: authorizedWhenInUse.")
            locationManager?.requestAlwaysAuthorization()
        default:
            print("DEBUG: default.")
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
            self.tableView.frame.origin.y = self.view.frame.height
        }) { _ in
            self.locationInputView.removeFromSuperview()
            UIView.animate(withDuration: 0.3, animations: { self.locationInputActivationView.alpha = 1 })
        }
    }
}

// MARK: - UITableViewDelegate / UITableViewDataSource

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        return cell
    }
    
    
}
