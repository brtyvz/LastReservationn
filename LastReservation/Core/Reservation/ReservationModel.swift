//
//  ReservationModel.swift
//  LastReservation
//
//  Created by Berat Yavuz on 4.03.2023.
//

import Foundation
import Firebase

struct ReservationModel:Identifiable,Decodable,Hashable{
    var id = UUID().uuidString
    var firestorID : String
    var session:String
    var date:Timestamp
    var number:String
    var email:String
    var selectedItems:[String]
    var imageUrl:String
    
}
