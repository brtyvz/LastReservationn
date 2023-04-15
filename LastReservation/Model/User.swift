//
//  User.swift
//  LastReservation
//
//  Created by Berat Yavuz on 24.01.2023.
//

import FirebaseFirestoreSwift

struct  User:Identifiable,Decodable {
    @DocumentID var id : String?
    let email:String
    let number:String
    
}
