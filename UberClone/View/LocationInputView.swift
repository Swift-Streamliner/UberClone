//
//  LocationInputView.swift
//  UberClone
//
//  Created by Tiger Mei on 13.05.2021.
//

import UIKit

protocol LocationInputViewDelegate : class {
    func dismissLocationInputView()
}

class LocationInputView: UIView {
    // MARK: - properties
    
    weak var delegate: LocationInputViewDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let startIndicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let linkingView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let destinationIndicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var startLocationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Current Location"
        textField.backgroundColor = .systemGroupedBackground
        textField.isEnabled = false
        textField.font = UIFont.systemFont(ofSize: 14)
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var destinationLocationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a destination"
        textField.backgroundColor = .lightGray
        textField.returnKeyType = .search
        textField.font = UIFont.systemFont(ofSize: 14)
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()

    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backButton)
        addShadow()
        backgroundColor = .white
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12, width: 24, height: 24)
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)
        
        addSubview(startLocationTextField)
        startLocationTextField.anchor(top: backButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 40, paddingRight: 40, height: 30)
        addSubview(destinationLocationTextField)
        destinationLocationTextField.anchor(top: startLocationTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 40, paddingRight: 40, height: 30)
        
        addSubview(startIndicatorView)
        startIndicatorView.centerY(inView: startLocationTextField, leftAnchor: leftAnchor, paddingLeft: 20)
        startIndicatorView.setDimensions(height: 6, width: 6)
        startIndicatorView.layer.cornerRadius = 6 / 2
        
        addSubview(destinationIndicatorView)
        destinationIndicatorView.centerY(inView: destinationLocationTextField, leftAnchor: leftAnchor, paddingLeft: 20)
        destinationIndicatorView.setDimensions(height: 6, width: 6)
        
        addSubview(linkingView)
        linkingView.centerX(inView: startIndicatorView)
        linkingView.anchor(top: startIndicatorView.bottomAnchor, bottom: destinationIndicatorView.topAnchor, paddingTop: 4, paddingBottom: 4, width: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented.")
    }
    
    // MARK: - Selectors
    @objc func handleBackTapped() {
        delegate?.dismissLocationInputView()
    }
}
