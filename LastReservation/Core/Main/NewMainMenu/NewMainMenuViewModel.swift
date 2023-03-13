//
//  NewMainMenuViewModel.swift
//  LastReservation
//
//  Created by Berat Yavuz on 22.02.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class NewMainMenuViewModel:ObservableObject{
    @Published var currentWeeks: [Date] = []
    
    @Published var reservation : [ReservationModel] = []
    
    @Published var currentDay: Date = Date()
    
    @Published var days: [DayModel] = []
    
    @Published var firestoreDays: [FirestoreDays] = []
    
    @Published var filteredDays:[DayModel]?
    
    @Published var hours:[String] = ["9.00","10.00","11.00","13.00","14.00","15.00"]
    
    @Published var capacity = ["50"]
    
    @Published var storedDays:[DayModel] = [
    
//        DayModel(hour: "9.00", capacity: "55", taskDate: .init(timeIntervalSince1970: 1677537666)),
//        DayModel(hour: "10.00", capacity: "40", taskDate: .init(timeIntervalSince1970: 1677537666)),
//        DayModel(hour: "11.00", capacity: "40", taskDate: .init(timeIntervalSince1970: 1677537666)),
//        DayModel(hour: "12.00", capacity: "54", taskDate: .init(timeIntervalSince1970: 1677537666)),
//        DayModel(hour: "13.00", capacity: "43", taskDate: .init(timeIntervalSince1970: 1677537666)),
//        DayModel(hour: "14.00", capacity: "5", taskDate: .init(timeIntervalSince1970: 1677537666)),
//        DayModel(hour: "15.00", capacity: "23", taskDate: .init(timeIntervalSince1970: 1677537666))
        
    
    ]
    
    init(){
        fetchCurrentWeek()
        filterTodayTasks()
        fetchData()
    }
    
    func filterTodayTasks(){
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            
            let filtered = self.storedDays.filter{
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
            DispatchQueue.main.async {
                withAnimation{
                    self.filteredDays = filtered
                }
            }
        }
    }
   
    func fetchData() {
        let db = Firestore.firestore()
        db.collection("ReservationsLast").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var firestoreDays: [FirestoreDays] = []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    let capacity = data["capacity"] as? Int ?? 0
                    let session = data["session"] as? String ?? ""
                    
                    let firestoreDay = FirestoreDays(session: session, capacity: capacity, date: date)
                    firestoreDays.append(firestoreDay)
                }
                self.firestoreDays = firestoreDays
            }
        }
    }






//    func fetchData() {
//        let db = Firestore.firestore()
//        db.collection("ReservationsLast").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                var firestoreDays: [FirestoreDays] = []
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                for document in querySnapshot!.documents {
//                    let data = document.data()
//                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
//                    let session = (data["session"] as? Timestamp)?.dateValue() ?? Date()
//                    let capacity = data["capacity"] as? Int ?? 0
//                    let firestoreDay = FirestoreDays(session: session, capacity: capacity, date: date)
//                    firestoreDays.append(firestoreDay)
//                }
//                self.firestoreDays = firestoreDays
//            }
//        }
//    }

    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()



    
    //func add reservation
    
    func addReservation(capacity:String,hour:String,date:String){
      
        let db = Firestore.firestore()
        let collectionRef = db.collection("ReservationsLast")

        // 365 gün boyunca her gün için belge oluşturun
        for day in 1...365 {
            let dateComponents = DateComponents(year: 2023, month: 1, day: day)
            let calendar = Calendar.current
            let date = calendar.date(from: dateComponents)!

            // 6 farklı seans için belge oluşturun
            let sessions = ["09:00", "10:00", "11:00", "13:00", "14:00", "15:00"]
            for session in sessions {
                let docID = "\(date.timeIntervalSince1970)-\(session)"
                let docRef = collectionRef.document(docID)

                // belge verilerini oluşturun
                let data: [String: Any] = [
                    "date": Timestamp(date: date),
                    "session": session,
                    "capacity": 50
                ]

                // belgeyi Firestore'a ekleyin
                docRef.setData(data) { error in
                    if let error = error {
                        print("Belge eklenirken hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Belge başarıyla eklendi.")
                    }
                }
            }
        }
    }
    
    
    //                let db = Firestore.firestore()
    //                let ref = db.collection("Index").document()
    //                ref.setData(["Capacity":capacity,"hour":hour,"date":date]){ error in
    //
    //                    if let error = error {
    //                        print(error.localizedDescription)
    //                    }
    //
    //                }
    
    
    func getRandevular() {
         let db = Firestore.firestore()
         let collectionRef = db.collection("Reservations")
         
         collectionRef.getDocuments { (querySnapshot, error) in
             if let error = error {
                 print("Hata: \(error.localizedDescription)")
                 return
             }
             
             var randevular = [ReservationModel]()
             
             for document in querySnapshot!.documents {
                 let data = document.data()
                 
                 guard let date = data["date"] as? String,
                       let session = data["session"] as? String,
                       let capacity = data["capacity"] as? Int else {
                     continue
                 }
                 
//                 self.getDate(from: date)
                 
                 let randevu = ReservationModel(hour: session, capacity: capacity, date: date)
                 randevular.append(randevu)
             }
             
             DispatchQueue.main.async {
                 self.reservation = randevular
             }
         }
        
        
    
     }
    
    
    
    func fetchCurrentWeek(){
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)

        guard let firstWeekDay = week?.start else{
            return
        }
        (1...7) .forEach{ day in
            
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeeks.append(weekday)
            }
            
        }
    }
    
    func getDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }

    
    func extractDate(date:Date,format:String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func extractTime(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current // set the time zone to the current time zone
        return dateFormatter.string(from: date)
    }

    
    func isToday(date: Date) -> Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
//    func updateReservation(date:String,hour:String,capacity:String){
//        let date = date
//        let hour = hour
//        let capacity = capacity
//
//        let day = ReservationModel(hour: <#T##String#>, capacity: <#T##Int#>, date: <#T##String#>)
//        DispatchQueue.main.async {
//            self.reservation.append(day)
//        }
//
//    }
}


