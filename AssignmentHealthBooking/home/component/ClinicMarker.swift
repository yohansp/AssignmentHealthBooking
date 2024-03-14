//
//  UserMarker.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import Foundation
import UIKit
import MapKit

class ClinicMarker: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let clinicModel: ClinicModel?
    
    init(
        title: String?,
        coordinate: CLLocationCoordinate2D,
        clinicModel: ClinicModel?
    ) {
        self.title = title
        self.coordinate = coordinate
        self.clinicModel = clinicModel
        super.init()
    }

    var subtitle: String? {
        return clinicModel?.address
    }
}
