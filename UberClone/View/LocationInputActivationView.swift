//
//  LocationInputActivationView.swift
//  UberClone
//
//  Created by Tiger Mei on 12.05.2021.
//

import UIKit

protocol LocationInputActivationViewDelegate: class {
    func presentLocationInputView()
}

class LocationInputActivationView : UIView {
    
    // MARK: - properties
    
    weak var delegate: LocationInputActivationViewDelegate?
    
    private let indication : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        addSubview(indication)
        indication.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        indication.setDimensions(height: 6, width: 6)
        addSubview(placeHolderLabel)
        placeHolderLabel.centerY(inView: self, leftAnchor: indication.rightAnchor, paddingLeft: 20)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentLocationInputView))
        addGestureRecognizer(tap)
    }
    
    @objc func presentLocationInputView() {
        delegate?.presentLocationInputView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}
