////
////  File.swift
////  LastReservation
////
////  Created by Berat Yavuz on 10.03.2023.
////
//
//import Foundation
//struct File {
//let startDate = DateComponents(year: 2022, month: 1, day: 1)
//let endDate = DateComponents(year: 2022, month: 12, day: 31)
//let calendar = Calendar.current
//
//// Tüm tarihleri oluşturun
//var dates: [Date] = []
//calendar.enumerateDates(startingAfter: calendar.date(from: startDate)!, matching: endDate, matchingPolicy: .nextTime) { date, _, stop in
//    if let date = date {
//        dates.append(date)
//    } else {
//        stop = true
//    }
//}
//
//// Tüm saatleri oluşturun
//var times: [String] = []
//let formatter = DateFormatter()
//formatter.dateFormat = "HH:mm"
//let interval = 30 * 60 // 30 dakika aralıklarla saatler oluşturun
//var date = calendar.date(from: startDate)!
//while date <= calendar.date(from: endDate)! {
//    times.append(formatter.string(from: date))
//    date = date.addingTimeInterval(TimeInterval(interval))
//}
//
//// Firestore belgelerini oluşturun
//for date in dates {
//    for time in times {
//        let docRef = Firestore.firestore().collection("randevu").document()
//        let data: [String: Any] = [
//            "date": date,
//            "time": time,
//            "capacity": 50
//        ]
//        docRef.setData(data)
//    }
//}
//}
