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
        let collectionRef = db.collection("ReservationsLast")
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
                    let firestoreDay = FirestoreDays(session: session, capacity: capacity, date: date)
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
    
    
    
    private func updateFirestoreCapacity(day: FirestoreDays) {
        let db = Firestore.firestore()
        let docRef = db.collection("ReservationsLast").document("\(day.date.timeIntervalSince1970)-\(day.session)")
        
        let newCapacity = day.capacity - 1
        let data = ["capacity": newCapacity]
        
        docRef.updateData(data) { error in
            if let error = error {
                print("Firestore'da kapasite güncellenirken bir hata oluştu: \(error.localizedDescription)")
            } else {
                print("Firestore'da kapasite başarıyla güncellendi. Yeni kapasite: \(newCapacity)")
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

}


