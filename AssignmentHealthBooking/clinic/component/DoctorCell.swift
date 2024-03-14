//
//  DoctorCell.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import UIKit

class DoctorCell: UITableViewCell {
    
    private lazy var imgAvatar: UIImageView = {
        let img = UIImageView(image: UIImage(named: "doctor"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.text = "Name"
        return label
    }()
    
    private lazy var labelSpecialization: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.3)
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.text = "(specialization))"
        return label
    }()
    
    lazy var btnBook: DelButton = {
        let btn = DelButton()
        btn.setTitle("Book")
        return btn
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup() {
        contentView.addSubview(imgAvatar)
        imgAvatar.snp.makeConstraints { make in
            make.size.equalTo(75)
            make.bottom.top.equalToSuperview().inset(7)
            make.leading.equalToSuperview()
        }
        
        let guideline = UIView()
        contentView.addSubview(guideline)
        guideline.snp.makeConstraints { make in
            make.leading.equalTo(imgAvatar.snp.trailing).offset(24)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(btnBook)
        btnBook.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
        
        contentView.addSubview(labelName)
        labelName.snp.makeConstraints { make in
            make.leading.equalTo(imgAvatar.snp.trailing).offset(16)
            make.trailing.equalTo(btnBook.snp.leading).inset(7)
            make.bottom.equalTo(guideline.snp.top).offset(-3)
        }
        
        contentView.addSubview(labelSpecialization)
        labelSpecialization.snp.makeConstraints { make in
            make.leading.equalTo(imgAvatar.snp.trailing).offset(16)
            make.trailing.equalTo(btnBook.snp.leading).inset(7)
            make.top.equalTo(guideline.snp.bottom).offset(3)
        }
    }
    
    func setData(_ doctor: DoctorModel) {
        self.labelName.text = doctor.fullname
        self.labelSpecialization.text = doctor.specialization
    }
}
