//
//  SignUpController.swift
//  UberClone
//
//  Created by Tiger Mei on 29.04.2021.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        return UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
    
    private lazy var fullnameContainerView: UIView = {
        return UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullnameTextField)
    }()
    
    private lazy var passwordContainerView: UIView = {
        return UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
    }()
    
    private lazy var accountTypeContainerView: UIView = {
        return UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"), segmentedControl:accountTypeSegmentedControl)
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    private let fullnameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Fullname", isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = UIColor.backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ",
                                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                             NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                  NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARKL - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [
                                emailContainerView,
                                fullnameContainerView,
                                passwordContainerView,
                                accountTypeContainerView,
                                signUpButton
        ])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
        alreadyHaveAccountButton.centerX(inView: view)
        
        
    }
    
    // MARK: - Selectors
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to create user with error \(error)")
                return
            }
            guard let uid = result?.user.uid else { return }
            let values = [
                "email": email,
                "fullname": fullname,
            "accountType": accountTypeIndex] as [String: Any]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
                if let error = error {
                    print("DEBUG: Cannot create user in database with error \(error.localizedDescription)")
                    return
                }
                print("Successfully created user in database.")
                guard let homeController = self.navigationController?.viewControllers.first as? HomeController else { return }
                homeController.configureUI()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
