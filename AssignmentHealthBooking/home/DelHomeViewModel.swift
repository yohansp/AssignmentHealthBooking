//
//  DelHomeViewModel.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import Foundation
import RxSwift
import MapKit
import GeoFire

class DelHomeViewModel {
    
    private lazy var clinicRepo: ClinicRepository = {
        let repo = ClinicRepository()
        return repo
    }()
    
    private lazy var _liveClinicList = PublishSubject<[ClinicModel]>()
    var liveClinicList: Observable<[ClinicModel]> {
        _liveClinicList.asObservable()
    }
    
    func requestAllClinic(_ currentLoc: CLLocationCoordinate2D) {
        Task {
            
            if let snapshot = await clinicRepo.requestClinicList() {
                var result: [ClinicModel] = []
                for doc in snapshot.documents {
                    let data = doc.data()
                    let model = ClinicModel(code: doc.documentID,
                                            name: data["name"] as! String,
                                            lat: doc["lat"] as! Double,
                                            lng: doc["lng"] as! Double,
                                            address: data["address"] as! String)
                    let distance = GFUtils.distance(from: CLLocation(latitude: currentLoc.latitude, longitude: currentLoc.longitude), to: CLLocation(latitude: model.lat, longitude: model.lng))
                    print(distance)
                    if distance <= 8000 {
                        result.append(model)
                    }
                }
                self._liveClinicList.onNext(result)
            }
        }
    }
}
