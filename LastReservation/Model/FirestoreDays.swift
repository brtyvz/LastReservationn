//
//  FirestoreDays.swift
//  LastReservation
//
//  Created by Berat Yavuz on 13.03.2023.
//

import Foundation

struct FirestoreDays:Identifiable,Decodable,Hashable {
    var id = UUID().uuidString
    var documentID: String
    var session: String
    var capacity: Int
    var date: Date
}


