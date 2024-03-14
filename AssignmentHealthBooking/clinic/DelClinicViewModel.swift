//
//  DelClinicViewModel.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import Foundation
import RxSwift

class DelClinicViewModel {
    
    private lazy var clinicRepo: ClinicRepository = {
        let repo = ClinicRepository()
        return repo
    }()
    
    private lazy var _liveDoctorList = PublishSubject<[DoctorModel]>()
    var liveDoctorList: Observable<[DoctorModel]> {
        _liveDoctorList.asObservable()
    }
    
    private lazy var _liveBook = PublishSubject<[BookedModel]>()
    var liveBook: Observable<[BookedModel]> {
        _liveBook.asObservable()
    }
    
    private lazy var _liveBookSaved = PublishSubject<String>()
    var liveBookSaved: Observable<String> {
        _liveBookSaved.asObservable()
    }
    
    func requestDoctorByClinic(_ codeClinic: String) {
        Task {
            if let snapshot = await clinicRepo.requestDocterByClinic(codeClinic) {
                var result: [DoctorModel] = []
                for d in snapshot.documents {
                    let data = d.data()
                    let doctor = DoctorModel(code: d.documentID, fullname: data["fullname"] as! String, specialization: data["specialization"] as! String)
                    result.append(doctor)
                }
                self._liveDoctorList.onNext(result)
            }
        }
    }
    
    func requestBookList(_ codeClinic: String, codeDoctor: String) {
        Task {
            if let snapshot = await clinicRepo.requestBooking(codeClinic, codeDoctor: codeDoctor) {
                var result: [BookedModel] = []
                for d in snapshot.documents {
                    let data = d.data()
                    let booked = BookedModel(codeUser: data["code_user"] as! String,
                                             codeDoctor: data["code_doctor"] as! String,
                                             codeClinic: data["code_clinic"] as! String,
                                             startTime: data["start_time"] as! Int,
                                             endTime: data["end_time"] as! Int)
                    result.append(booked)
                }
                self._liveBook.onNext(result)
            }
        }
    }
    
    func saveBook(_ data: BookedModel) {
        Task {
            await clinicRepo.saveBook(data)
            self._liveBookSaved.onNext("OK")
        }
    }
}
