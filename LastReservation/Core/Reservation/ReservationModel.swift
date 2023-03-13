//
//  ReservationModel.swift
//  LastReservation
//
//  Created by Berat Yavuz on 4.03.2023.
//

import Foundation

struct ReservationModel:Identifiable,Decodable,Hashable{
    var id = UUID().uuidString
    var hour:String
    var capacity:Int
    var date:String
}
