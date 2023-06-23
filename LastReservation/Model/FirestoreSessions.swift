//
//  FirestoreSessions.swift
//  LastReservation
//
//  Created by Berat Yavuz on 9.04.2023.
//

import Foundation
import FirebaseFirestore
import Firebase

struct Days: Identifiable, Equatable, Hashable {
    var id = UUID().uuidString
    var date: Timestamp
    var sessions: [String: Sessions]

    var db = Firestore.firestore() // Firestore veritabanı referansı
    
    
    static func == (lhs: Days, rhs: Days) -> Bool {
        return lhs.id == rhs.id &&
            lhs.date == rhs.date &&
            lhs.sessions == rhs.sessions
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(sessions)
    }

    struct Sessions: Equatable, Hashable {
        var capacity: Int

        static func == (lhs: Sessions, rhs: Sessions) -> Bool {
            return lhs.capacity == rhs.capacity
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(capacity)
        }
    }
}


class denemeViewModel: ObservableObject {
    @Published var reservations:[ReservationModel] = []
    @Published var mail:String = ""
    
    
    func fillMissingDays(_ days: [Days]) -> [Days] {
        var filledDays = [Days]()
        var currentDate = days.first?.date.dateValue() ?? Date()
        let endDate = days.last?.date.dateValue() ?? Date()

        while currentDate <= endDate {
            if let day = days.first(where: { $0.date.dateValue() == currentDate }) {
                filledDays.append(day)
            } else {
                let emptyDay = Days(date: Timestamp(date: currentDate), sessions: [:])
                filledDays.append(emptyDay)
            }

            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        }

        return filledDays
    }

    func fetchDays(startOfWeek: Date, endOfWeek: Date, completion: @escaping (Result<[Days], Error>) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("Days")
            .whereField("date", isGreaterThanOrEqualTo: startOfWeek)
            .whereField("date", isLessThanOrEqualTo: endOfWeek)
            .order(by: "date", descending: false)

        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            var days = [Days]()
            let group = DispatchGroup()

            for document in querySnapshot!.documents {
                let date = document.get("date") as! Timestamp
                let sessionsCollectionRef = document.reference.collection("sessions").order(by: "capacity", descending: false)

                group.enter()

                sessionsCollectionRef.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    var sessions = [String: Days.Sessions]()
                    for document in querySnapshot!.documents {
                        let capacity = document.get("capacity") as! Int
                        sessions[document.documentID] = Days.Sessions(capacity: capacity)
                    }

                    let day = Days(date: date, sessions: sessions)
                    days.append(day)

                    group.leave()
                }
            }

            group.notify(queue: .main) {
                let sortedDays = days.sorted(by: { $0.date.dateValue() < $1.date.dateValue() })
                let filledDays = self.fillMissingDays(sortedDays)
                completion(.success(filledDays))
            }
        }
      
    }
    
    

    func fetchReservationFromFirestore(email: String) {
        let db = Firestore.firestore()
        // Firestore koleksiyonunu referansını oluştur
        let collectionRef = db.collection("Reservations")

        // Firestore koleksiyonunda email bilgisine göre sorgu yap
        collectionRef.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                // Hata durumunu işle
                print("Firestore sorgu hatası: \(error.localizedDescription)")
            } else {
                // Başarılı sorgu durumunu işle
                print("Firestore sorgu başarılı!")
                // Sorgu sonucundan dökümanları işle
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let reservationData = document.data()
                        // reservationData, çekilen belgenin verilerini içerir
                        let email = reservationData["email"] as? String ?? ""
                        let number = reservationData["number"] as? String ?? ""
                        let session = reservationData["session"] as? String ?? ""
                        let date = reservationData["date"] as? Timestamp
                   let items = reservationData["selectedItems"] as? [String] ?? [""]
                        let imageUrl = reservationData["imageUrl"] as? String ?? ""
                        // Doğru email bilgisine sahip belgeleri işle
                        if email == email {
                           
                            if let date = date {
                                let timestamp = date.dateValue()
                                let reservation = ReservationModel(firestorID: document.documentID, session: session, date: date, number:number , email: email, selectedItems: items,imageUrl: imageUrl)
                                self.reservations.append(reservation)
                                print(reservation.selectedItems)
                                
                                DispatchQueue.main.async {
                                    self.mail = email
                                }
                                
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
    
    
    func deleteReservationsForEmail(resDelete: ReservationModel) {
        let db = Firestore.firestore()
        
        
        db.collection("Reservations").document(resDelete.firestorID).delete{ error in
            
            if error == nil {
                DispatchQueue.main.async {
                    self.reservations.removeAll{ res in
                        return res.firestorID == resDelete.firestorID
                    }
                }
            }
            
        }

       
    }
    
  
    
    
}
