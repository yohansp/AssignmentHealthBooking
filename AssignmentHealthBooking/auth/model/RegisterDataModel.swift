//
//  RegisterDataModel.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 13/03/24.
//

import Foundation

struct RegisterDataModel : Codable {
    let email: String
    let password: String
    let fullname: String
    let mobile: String
    let address: String
}
