//
//  DelLoginController.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 13/03/24.
//

import Foundation
import UIKit

class DelLoginController: DelViewController {
    
    private lazy var imgLogo: UIImageView = {
        let img = UIImageView(image: UIImage(named: "logo"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var inputEmail: DelTextInput = {
        let input = DelTextInput("Email", placeHolder: "Type your email.")
        input.setEmailMode()
        return input
    }()
    
    private lazy var inputPassword: DelTextInput = {
        let input = DelTextInput("Password", placeHolder: "Type your password..")
        input.setSecureMode()
        input.setActionDone()
        return input
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var btnLogin: DelButton = {
        let btn = DelButton()
        btn.setTitle("Login")
        return btn
    }()
    
    private lazy var btnRegister: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        return btn
    }()
    
    var isExpand: Bool = false
    
    private lazy var viewModel: DelAuthVIewModel = {
        let vm = DelAuthVIewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(imgLogo)
        imgLogo.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        
        stackView.addArrangedSubview(inputEmail)
        stackView.addArrangedSubview(inputPassword)
        stackView.setCustomSpacing(9, after: inputPassword)
        stackView.addArrangedSubview(btnLogin)
        btnLogin.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        stackView.setCustomSpacing(9, after: btnLogin)
        stackView.addArrangedSubview(btnRegister)
        btnRegister.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        // init observer
        viewModel.liveLoginSuccess.subscribe(onNext: { user in
            DispatchQueue.main.sync {
                self.hideWait()
                UserDefaults.standard.set(user.uid, forKey: "uid")
                let home = DelHomeController()
                let nav = UINavigationController(rootViewController: home)
                if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    window.keyWindow?.rootViewController = nav
                    window.keyWindow?.makeKeyAndVisible()
                }
            }
        }).disposed(by: self.disposeBag)
        
        viewModel.liveError.subscribe(onNext: { error in
            DispatchQueue.main.sync {
                self.hideWait()
                self.showAlert(message: error)
            }
        }).disposed(by: self.disposeBag)
        
        // set listener
        btnLogin.addTapGestureListener(action: {
            self.showWait()
            self.viewModel.login(self.inputEmail.getText(), password: self.inputPassword.getText())
        })
        
        btnRegister.addTapGestureListener(action: {
            let register = DelRegisterController()
            self.navigationController?.pushViewController(register, animated: true)
        })
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func onKeyboardShow(notification: NSNotification) {
        if !isExpand{
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height + keyboardHeight)
            }
            else{
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height + 200)
            }
            isExpand = true
        }
    }
    
    @objc func onKeyboardHide(notification: NSNotification) {
        if isExpand{
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height - keyboardHeight)
            }
            else{
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height - 200)
            }
            isExpand = false
        }
    }
}
