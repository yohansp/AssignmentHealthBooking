//
//  CompZoomOutIn.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import UIKit

protocol CompZoomDelegate {
    func onPlus()
    func onMin()
}

class CompZoomOutIn: UIView {
    
    lazy var btnPlus: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "+"
        label.font = .systemFont(ofSize: 27, weight: .semibold)
        label.textColor = UIColor.colorButton
        return label
    }()
    
    lazy var btnMin: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "-"
        label.font = .systemFont(ofSize: 27, weight: .semibold)
        label.textColor = UIColor.colorButton
        return label
    }()
    
    var delegate: CompZoomDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.cornerRadius = 13
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 3
        
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 15
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stack.addArrangedSubview(btnPlus)
        stack.addArrangedSubview(btnMin)
        btnPlus.addTapGestureListener(action: {
            self.delegate?.onPlus()
        })
        btnMin.addTapGestureListener(action: {
            self.delegate?.onMin()
        })
    }
}
