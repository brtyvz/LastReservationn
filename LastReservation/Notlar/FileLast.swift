//
//  File.swift
//  LastReservation
//
//  Created by Berat Yavuz on 13.03.2023.
//

import Foundation


//func fetchDays() {
//    days.removeAll()
//    let db = Firestore.firestore()
//    let ref = db.collection("ReservationsLast")
//    
//    // Get the start and end dates of the current week
//    let calendar = Calendar.current
//    let currentDate = Date()
//    let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: currentDate)!.start
//    let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
//    
//    // Add filter to query for days within the week
//    let query = ref.whereField("Date", isGreaterThanOrEqualTo: startOfWeek)
//                   .whereField("Date", isLessThanOrEqualTo: endOfWeek)
//    
//    query.getDocuments { snapshot, error in
//        guard error == nil else {
//            print(error!.localizedDescription)
//            return
//        }
//        
//        if let snapshot = snapshot {
//            for document in snapshot.documents {
//                let data = document.data()
//                
//                let hour = data["Hour"] as? String ?? ""
//                let capacity = data["Capacity"] as? String ?? ""
//                let date = data["Date"] as? Date ?? .init(timeIntervalSince1970: 1677241700)
//                let day = DayModel(hour: hour, capacity: capacity, taskDate: date)
//                
//                self.days.append(day)
//            }
//        }
//    }
//}






////fetch Days
//func fetchDays() {
//    days.removeAll()
//    let db = Firestore.firestore()
//    let ref = db.collection("Reservations")
//
//    // Get the start and end dates of the current week
//    let calendar = Calendar.current
//    let currentDate = Date()
//    let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: currentDate)!.start
//    let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
//
//    // Add filter to query for days within the week
//    let query = ref.whereField("date", isGreaterThanOrEqualTo: startOfWeek)
//                   .whereField("date", isLessThanOrEqualTo: endOfWeek)
//
//    query.getDocuments { snapshot, error in
//        guard error == nil else {
//            print(error!.localizedDescription)
//            return
//        }
//
//        if let snapshot = snapshot {
//            for document in snapshot.documents {
//                let data = document.data()
//
//                let session = data["session"] as? String ?? ""
//                let capacity = data["capacity"] as? Int ?? 0
//                let dateTimestamp = data["date"] as? Timestamp ?? Timestamp(date: Date())
//                let date = dateTimestamp.dateValue()
//                let day = DayModel(hour: session, capacity: "\(capacity)", taskDate: date)
//
//                self.days.append(day)
//            }
//        }
//    }
//}
