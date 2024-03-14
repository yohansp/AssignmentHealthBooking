//
//  AdminRepository.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import MapKit
import GeoFire

class AdminRepository {
    
    func constructData() {
        let clinic = Firestore.firestore().collection("clinic")
        clinic.document("C01").setData(["name": "Clinic Ananda", "lat": -6.16077846985526, "lng": 106.8205434263466, 
                                        "geohash": locHash(-6.16077846985526, lng: 106.8205434263466), "address": "Jakarta Pusat, Indonesia"])
        clinic.document("C02").setData(["name": "Clinik Diana", "lat": -6.160995605591124, "lng": 106.7972962670745,
                                        "geohash": locHash(6.160995605591124, lng: 106.7972962670745), "address": "Jakarta Pusat, Indonesia"])
        clinic.document("C03").setData(["name": "Clinic Prodia", "lat": -6.154398511759832, "lng": 106.8373772491251,
                                        "geohash": locHash(6.154398511759832, lng: 106.8373772491251), "address": "Jakarta Pusat, Indonesia"])
        clinic.document("C04").setData(["name": "Clinic Hermina", "lat": -6.175882310361209, "lng": 106.8502019687248,
                                        "geohash": locHash(6.175882310361209, lng: 106.8502019687248), "address": "Jakarta Utara, Indonesia"])
        clinic.document("C05").setData(["name": "Clinic Medika", "lat": -6.173325582517054, "lng": 106.8356982915985,
                                        "geohash": locHash(6.173325582517054, lng: 106.8356982915985), "address": "Jakarta Pusat, Indonesia"])
        clinic.document("C06").setData(["name": "Clinic Dewa", "lat": -6.176930278264142, "lng": 106.8092682746599, "geohash": locHash(6.176930278264142, lng: 106.8092682746599),
                                        "address": "Jakarta Pusat, Indonesia"])
        clinic.document("C07").setData(["name": "Clinic Mitra", "lat": -6.188457788204377, "lng": 106.8315797731417, "geohash": locHash(6.188457788204377, lng: 106.8315797731417), 
                                        "address": "Jakarta Selatan, Indonesia"])
        
        clinic.document("C08").setData(["name": "Icon Haematology Centre Mount Elizabeth", "lat": 1.3055915, "lng": 103.83582702342584,
                                        "geohash": locHash(1.3055915, lng: 103.83582702342584), "address": "5 Hospital, Singapore"])
        clinic.document("C09").setData(["name": "Singapore General Hospital", "lat": 1.2807069403633717, "lng": 103.83556953135593,
                                        "geohash": locHash(1.2807069403633717, lng: 103.83556953135593), "address": "Outram Rd, Singapore"])
        clinic.document("C10").setData(["name": "Alexandra Hospital", "lat": 1.2882581428318953, "lng": 103.80106559398541,
                                        "geohash": locHash(1.2882581428318953, lng: 103.80106559398541), "address": "Alexandra Rd, Singapore"])
        clinic.document("C11").setData(["name": "Gleneagles Hospital", "lat": 1.309281258676664, "lng": 103.82037749923012,
                                        "geohash":  locHash(1.309281258676664, lng: 103.82037749923012), "address": "Napier Rd, Singapore"])
        
        let doctor = Firestore.firestore().collection("doctor")
        doctor.document("D01").setData(["fullname": "Jhon Saputra", "gender": "Male", "specialization": "Medical Oncologist"])
        doctor.document("D02").setData(["fullname": "Daniel", "gender": "Male", "specialization": "Radiation Oncologist"])
        doctor.document("D03").setData(["fullname": "Robert", "gender": "Male", "specialization": "Clinical Haemotologist"])
        doctor.document("D04").setData(["fullname": "Carmen", "gender": "Female", "specialization": "Clinical Haemotologist"])
        
        let clinicDoctor = Firestore.firestore().collection("clinic_doctor")
        clinicDoctor.document("CD01").setData([ "code_doctor": "D01", "code_clinic": "C01" ])
        clinicDoctor.document("CD02").setData([ "code_doctor": "D01", "code_clinic": "C02" ])
        clinicDoctor.document("CD03").setData([ "code_doctor": "D01", "code_clinic": "C03" ])
        clinicDoctor.document("CD04").setData([ "code_doctor": "D02", "code_clinic": "C04" ])
        clinicDoctor.document("CD05").setData([ "code_doctor": "D02", "code_clinic": "C05" ])
        clinicDoctor.document("CD06").setData([ "code_doctor": "D02", "code_clinic": "C06" ])
        clinicDoctor.document("CD07").setData([ "code_doctor": "D03", "code_clinic": "C07" ])
        clinicDoctor.document("CD08").setData([ "code_doctor": "D03", "code_clinic": "C08" ])
        clinicDoctor.document("CD09").setData([ "code_doctor": "D04", "code_clinic": "C09" ])
        clinicDoctor.document("CD10").setData([ "code_doctor": "D04", "code_clinic": "C10" ])
        clinicDoctor.document("CD11").setData([ "code_doctor": "D04", "code_clinic": "C11" ])
    }
    
    private func locHash(_ lat: Double, lng: Double) -> String {
        return GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: lat, longitude: lng))
    }
}
