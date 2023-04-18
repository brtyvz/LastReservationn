//
//  DayModel.swift
//  LastReservation
//
//  Created by Berat Yavuz on 23.02.2023.
//

import Foundation
import FirebaseFirestore
struct DayModel:Identifiable,Decodable{
    var id = UUID().uuidString
    var hour:String
    var capacity:String
    var taskDate:Timestamp
    var firestorID : String
}
