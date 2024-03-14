//
//  DelRegisterCell.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 13/03/24.
//

import Foundation
import UIKit

class DelRegisterCell: UITableViewCell {
    
    lazy var inputField: DelTextInput = {
        let input = DelTextInput("Title", placeHolder: "Please input..")
        return input
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        contentView.addSubview(inputField)
        inputField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
