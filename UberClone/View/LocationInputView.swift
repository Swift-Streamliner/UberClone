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
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backButton)
        addShadow()
        backgroundColor = .white
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12, width: 24, height: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented.")
    }
    
    // MARK: - Selectors
    @objc func handleBackTapped() {
        delegate?.dismissLocationInputView()
    }
}
