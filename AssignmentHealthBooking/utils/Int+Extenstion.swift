//
//  String+Extenstion.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import Foundation

extension Int {
    
    func toTime() -> String {
        var hour = self / 100
        var minute = self % 100
        return String(format: "%02d:%02d", hour, minute)
    }
}
