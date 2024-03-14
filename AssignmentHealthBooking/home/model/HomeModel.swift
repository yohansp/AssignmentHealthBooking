//
//  HomeModel.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import Foundation

struct ClinicModel {
    let code: String
    let name: String
    let lat: Double
    let lng: Double
    let address: String
}

struct DoctorModel {
    let code: String
    let fullname: String
    let specialization: String
}

struct BookedModel {
    let codeUser: String
    let codeDoctor: String
    let codeClinic: String
    let startTime: Int
    let endTime: Int
}
