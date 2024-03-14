//
//  DelHomeController.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import Foundation
import UIKit
import MapKit

class DelHomeController: DelViewController, CompZoomDelegate {
    
    private lazy var map: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        return map
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let loc = CLLocationManager()
        loc.delegate = self
        return loc
    }()
    
    private lazy var viewModel: DelHomeViewModel = {
        let vm = DelHomeViewModel()
        return vm
    }()
    
    private lazy var compZoomButton: CompZoomOutIn = {
        let comp = CompZoomOutIn()
        comp.delegate = self
        return comp
    }()
    
    private var currentCoordinate: CLLocationCoordinate2D? = nil
    private var zoom: Double = 8000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar("Healthy Home")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(onLogout))
        //TODO: remove
        //let rep = AdminRepository()
        //rep.constructData()
        
        let labelInfo = UILabel()
        labelInfo.text = "Here are the available clinics near your location. You can choose a clinic from the map."
        labelInfo.numberOfLines = 0
        labelInfo.font = .systemFont(ofSize: 17, weight: .semibold)
        labelInfo.textAlignment = .center
        view.addSubview(labelInfo)
        labelInfo.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(map)
        map.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(labelInfo.snp.top).offset(-9)
        }
        
        view.addSubview(compZoomButton)
        compZoomButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        // location
        locationManager.requestWhenInUseAuthorization()
        
        // init observer
        viewModel.liveClinicList.subscribe(onNext: { data in
            DispatchQueue.main.async {
                for d in data {
                    let coordinate = CLLocationCoordinate2D(latitude: d.lat, longitude: d.lng)
                    self.map.addAnnotation(ClinicMarker(title: d.name, coordinate: coordinate, clinicModel: d))
                }
                self.hideWait()
            }
        }).disposed(by: self.disposeBag)
    }
    
    func onMin() {
        if let coordinate = self.currentCoordinate {
            self.zoom += 100000
            let coordinateRegion = MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: self.zoom,
                longitudinalMeters: self.zoom)
            self.map.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func onPlus() {
        let newZoom = self.zoom - 100000
        if let coordinate = self.currentCoordinate, newZoom >= 8000 {
            self.zoom = newZoom
            let coordinateRegion = MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: self.zoom,
                longitudinalMeters: self.zoom)
            self.map.setRegion(coordinateRegion, animated: true)
        }
    }
}

extension DelHomeController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentCoordinate = location.coordinate
            let coordinateRegion = MKCoordinateRegion(
                  center: location.coordinate,
                  latitudinalMeters: self.zoom,
                  longitudinalMeters: self.zoom)
            self.map.setRegion(coordinateRegion, animated: true)
            
            // load data
            self.showWait()
            self.viewModel.requestAllClinic(location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let marker = view.annotation as? ClinicMarker, let clinicModel = marker.clinicModel {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                let vc = DelClinicDetailController()
                vc.clinicModel = clinicModel
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    @objc func onLogout() {
        let login = DelLoginController()
        let nav = UINavigationController(rootViewController: login)
        if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            window.keyWindow?.rootViewController = nav
            window.keyWindow?.makeKeyAndVisible()
        }
    }
}
