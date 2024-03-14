//
//  ClinicRepository.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ClinicRepository {
    
    struct Property {
        static let documentName = "clinic"
        static let documentDoctor = "doctor"
        static let documentClinicDoctor = "clinic_doctor"
        static let documentBooking = "booking"
    }
    
    private var db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    func requestClinicList() async -> QuerySnapshot? {
        do {
            let clinic = db.collection(Property.documentName)
            let response = try await clinic.getDocuments()
            return response
        } catch {
            return nil
        }
    }
    
    func requestDocterByClinic(_ code: String) async -> QuerySnapshot? {
        do {
            var listCodeDoctor:[String] = []
            let doctor = db.collection(Property.documentDoctor)
            let clinicDoctor = db.collection(Property.documentClinicDoctor)
            let response = try await clinicDoctor.whereField("code_clinic", isEqualTo: code).getDocuments()
            
            for cd in response.documents {
                let codeDoctor = cd.data()["code_doctor"]
                listCodeDoctor.append(codeDoctor as! String)
            }
            
            let responseDoctor = try await doctor.whereField(FieldPath.documentID(), in: listCodeDoctor).getDocuments()
            return responseDoctor
        } catch {
            return nil
        }
    }
    
    func requestBooking(_ codeClinic: String, codeDoctor: String) async -> QuerySnapshot? {
        do {
            let book = db.collection(Property.documentBooking)
            let response = try await book.whereField("code_clinic", isEqualTo: codeClinic).whereField("code_doctor", isEqualTo: codeDoctor).getDocuments()
            return response
        } catch {
            return nil
        }
    }
    
    func saveBook(_ data: BookedModel) async {
        do {
            let book = db.collection(Property.documentBooking)
            try await book.addDocument(data: [
                "code_user": data.codeUser,
                "code_clinic": data.codeClinic,
                "code_doctor": data.codeDoctor,
                "start_time": data.startTime,
                "end_time": data.endTime
            ])
        } catch {
        }
    }

}
