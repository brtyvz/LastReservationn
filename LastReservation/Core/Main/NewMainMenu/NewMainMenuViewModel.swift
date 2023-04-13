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
import FirebaseFirestore

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
    ]
    
    init(){
        fetchCurrentWeek()
        filterTodayTasks()
        
       
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
    
    
   
    func fetchData(for weekStartingDate: Date) {
        let db = Firestore.firestore()
        let weekEndingDate = Calendar.current.date(byAdding: .day, value: 6, to: weekStartingDate)!
        let collectionRef = db.collection("Days")
        let startTimestamp = Timestamp(date: Date())
        let endTimestamp = Timestamp(date: weekEndingDate)
        let query = collectionRef.whereField("date", isGreaterThanOrEqualTo: startTimestamp).whereField("date", isLessThanOrEqualTo: endTimestamp)
        query.getDocuments { (querySnapshot, error) in
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
                    let firestoreDay = FirestoreDays(documentID: document.documentID, session: session, capacity: capacity, date: date)
                    firestoreDays.append(firestoreDay)
                }
                self.firestoreDays = firestoreDays
            }
        }
    }


    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()



    
    //func add reservation
    
    func addReservation() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("Days")
        
        // 1 Ocak'tan 31 Aralık'a kadar her gün için belge oluşturun
        var dateComponents = DateComponents(year: 2023, month: 1, day: 1)
        let calendar = Calendar.current
        for day in 1...365 {
            let date = calendar.date(from: dateComponents)!
            let timestamp = Int(date.timeIntervalSince1970 * 1000) // Unix zaman damgası değeri
            
            // Ana koleksiyona tarih bilgisini içeren belgeyi ekle
            let dayData: [String: Any] = [
                "date": Timestamp(date: date)
            ]
            let dayDocRef = collectionRef.document("\(timestamp)")
            dayDocRef.setData(dayData) { error in
                if let error = error {
                    print("Gün belgesi eklenirken hata oluştu: \(error.localizedDescription)")
                } else {
                    print("Gün belgesi başarıyla eklendi.")
                }
            }
            
            // 6 farklı seans için alt koleksiyonları oluşturun
            let sessions = ["09:00", "10:00", "11:00", "13:00", "14:00", "15:00"]
            for session in sessions {
                let sessionData: [String: Any] = [
                    "capacity": 50
                ]
                let sessionDocRef = dayDocRef.collection("sessions").document(session)
                sessionDocRef.setData(sessionData) { error in
                    if let error = error {
                        print("Seans belgesi eklenirken hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Seans belgesi başarıyla eklendi.")
                    }
                }
            }
            
            // Bir sonraki günün tarih bileşenlerini ayarlayın
            dateComponents.day! += 1
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

}


