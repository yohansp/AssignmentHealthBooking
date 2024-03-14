//
//  RegisterController.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 13/03/24.
//

import Foundation
import UIKit

class DelRegisterController: DelViewController {
    
    let dataView: [DelTextInput.TextInputDataView] = [
        DelTextInput.TextInputDataView("Email", placeHolder: "Please input your email", value: ""),
        DelTextInput.TextInputDataView("Password", placeHolder: "Please input your password", value: "", isSecure: true),
        DelTextInput.TextInputDataView("Fullname", placeHolder: "Please input your fullname", value: ""),
        DelTextInput.TextInputDataView("Mobile Number", placeHolder: "Please input your mobile phonenumber", value: ""),
        DelTextInput.TextInputDataView("Address", placeHolder: "Please input your address", value: ""),
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(DelRegisterCell.self, forCellReuseIdentifier: "del_register_cell")
        return tableView
    }()
    
    private lazy var btnSubmit: DelButton = {
        let btn = DelButton()
        btn.setTitle("Register")
        return btn
    }()
    
    private lazy var viewModel: DelAuthVIewModel = DelAuthVIewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar("Register")
        
        view.addSubview(btnSubmit)
        btnSubmit.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(45)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(btnSubmit.snp.top).offset(-9)
            make.leading.trailing.equalToSuperview()
        }
        
        // observer
        self.viewModel.liveRegisterSuccess.subscribe(onNext: { data in
            DispatchQueue.main.async {
                print("success: \(data)")
                self.hideWait()
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.liveError.subscribe(onNext: { error in
            DispatchQueue.main.sync {
                self.hideWait()
                self.showAlert(message: error)
            }
        }).disposed(by: self.disposeBag)
        
        // listener
        btnSubmit.addTapGestureListener(action: {
            var error = false
            self.dataView.forEach{ data in
                if data.value.isEmpty {
                    data.error = "Can not empty."
                    error = true
                }
            }
            
            if !error  {
                self.showWait()
                let registerModel = RegisterDataModel(email: self.dataView[0].value, password: self.dataView[1].value,
                                                      fullname: self.dataView[2].value, mobile: self.dataView[3].value,
                                                      address: self.dataView[4].value)
                
                self.viewModel.register(registerModel)
                
            } else {
                self.tableView.reloadData()
            }
        })
    }
}

extension DelRegisterController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "del_register_cell", for: indexPath) as? DelRegisterCell else {
//            return UITableViewCell()
//        }
        
        let cell = DelRegisterCell()
        let data = self.dataView[indexPath.row]
        cell.inputField.setDataView(data)
        
        return cell
    }
}
