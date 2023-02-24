//
//  DayModel.swift
//  LastReservation
//
//  Created by Berat Yavuz on 23.02.2023.
//

import Foundation

struct DayModel:Identifiable{
    var id = UUID().uuidString
    var hour:String
    var capacity:String
    var taskDate:Date
}
