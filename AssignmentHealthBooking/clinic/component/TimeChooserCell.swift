//
//  TimeChooserCell.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import UIKit

class TimeChooserCell: UICollectionViewCell {
    
    private lazy var view: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 9
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "00:00"
        label.font = .systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    var startTime: Int = 0
    var endTime: Int = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 3, bottom: 13, right: 3))
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
    }
    
    func setTime(_ start: Int, end: Int) {
        self.startTime = start
        self.endTime = end
    }
    
    func setSelected() {
        view.layer.backgroundColor = UIColor.colorButton.cgColor
        label.textColor = UIColor.white
    }
    
    func setUnselected() {
        view.layer.backgroundColor = UIColor.white.cgColor
        label.textColor = UIColor.black
    }
}
