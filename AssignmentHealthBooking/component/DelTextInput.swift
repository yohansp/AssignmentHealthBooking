//
//  DelTextInput.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 13/03/24.
//

import Foundation
import UIKit
import SnapKit

class DelTextInput: UIView, UITextFieldDelegate {
    
    class TextInputDataView {
        var title: String = ""
        var placeHolder: String = ""
        var value: String = ""
        var error: String = ""
        var isSecure: Bool = false
        
        init(_ title: String, placeHolder: String, value: String = "", error: String = "", isSecure: Bool = false) {
            self.title = title
            self.placeHolder = placeHolder
            self.value = value
            self.error = error
            self.isSecure = isSecure
        }
    }
    
    private var data: TextInputDataView? = nil
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.text = "Title"
        return label
    }()
    
    private lazy var labelError: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 13)
        label.isHidden = true
        label.text = "Error"
        return label
    }()
    
    private lazy var input: UITextField = {
        let input = UITextField()
        input.placeholder = "Input field"
        input.font = .systemFont(ofSize: 15)
        input.delegate = self
        return input
    }()
    
    init(_ title: String, placeHolder: String) {
        super.init(frame: .zero)
        self.setup()
        self.labelTitle.text = title
        self.input.placeholder = placeHolder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 9
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.width.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(labelTitle)
        stackView.addArrangedSubview(input)
        
        let line = UIView()
        line.backgroundColor = .black.withAlphaComponent(0.1)
        stackView.addArrangedSubview(line)
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        stackView.addArrangedSubview(labelError)
        let gap = UIView()
        stackView.addArrangedSubview(gap)
        gap.snp.makeConstraints { make in
            make.height.equalTo(7)
        }
        
        // listener
        input.addTarget(self, action: #selector(onChange(_:)), for: .editingChanged)
        
    }
    
    @objc func onChange(_ textField: UITextField) {
        if let text = textField.text {
            if let data = self.data {
                data.value = text
                self.labelError.isHidden = !text.isEmpty
            }
        }
    }
    
    func setEmailMode() {
        input.keyboardType = .emailAddress
        input.isSecureTextEntry = false
    }
    
    func setSecureMode() {
        input.isSecureTextEntry = true
    }
    
    func setActionDone() {
        input.returnKeyType = .done
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setDataView(_ data: TextInputDataView) {
        self.data = data
        labelTitle.text = data.title
        input.placeholder = data.placeHolder
        if !data.value.isEmpty {
            input.text = data.value
        }
        labelError.text = data.error
        labelError.isHidden = data.error.isEmpty
        input.isSecureTextEntry = data.isSecure
    }
    
    func getText() -> String {
        return self.input.text ?? ""
    }
    
    func setReadOnly() {
        input.isEnabled = false
    }
    
    func setText(_ text: String) {
        input.text = text
    }
}
