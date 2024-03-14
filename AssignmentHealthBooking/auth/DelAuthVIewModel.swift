//
//  DelAuthVIewModel.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 13/03/24.
//

import Foundation
import RxSwift
import FirebaseAuth

class DelAuthVIewModel {
    
    private lazy var userRepo: UserRepository = {
        let repo = UserRepository()
        return repo
    }()
    
    private lazy var _liveRegisterSuccess = PublishSubject<String>()
    var liveRegisterSuccess: Observable<String>{
        _liveRegisterSuccess.asObservable()
    }
    
    private lazy var _liveError = PublishSubject<String>()
    var liveError: Observable<String>{
        _liveError.asObservable()
    }
    
    private lazy var _liveLoginSuccess = PublishSubject<User>()
    var liveLoginSuccess: Observable<User>{
        _liveLoginSuccess.asObservable()
    }
    
    func register(_ data: RegisterDataModel) {
        Task {
            do {
                let status = try await userRepo.saveUser(data.email, password: data.password, fullname: data.fullname, mobile: data.mobile, address: data.address)
                if status == "OK"  {
                    self._liveRegisterSuccess.onNext("OK")
                } else {
                    self._liveError.onNext(status)
                }
            } catch {
                self._liveError.onNext(error.localizedDescription)
            }
        }
    }
    
    func login(_ email: String, password: String) {
        Task {
            let user = await userRepo.signIn(email, password: password)
            if let data = user {
                self._liveLoginSuccess.onNext(data)
            } else {
                self._liveError.onNext("Email or password is not correct.")
            }
        }
    }
}
