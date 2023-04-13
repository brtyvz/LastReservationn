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


}


// çalışıyor üstteki vm ile

//@StateObject var viewModel = denemeViewModel()
//  @State private var days = [Days]()
//
//  var body: some View {
//      ScrollView(.horizontal) {
//          HStack {
//              ForEach(days) { day in
//                  VStack {
//                      Text(day.date, style: .date)
//                      Divider()
//                      ForEach(day.sessions.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
//                          HStack {
//                              Text(key)
//                              Spacer()
//                              Text("\(value.capacity)")
//                          }
//                          .padding(.horizontal)
//                      }
//                  }
//                  .padding()
//                  .background(Color.gray.opacity(0.1))
//                  .cornerRadius(8)
//                  .padding(.vertical)
//              }
//          }
//      }
//      .onAppear {
//          viewModel.fetchDays { result in
//              switch result {
//              case .success(let days):
//                  self.days = days
//              case .failure(let error):
//                  print(error)
//              }
//          }
//      }
//  }









//import SwiftUI
//import Firebase
//
//struct NewMainMenu: View {
//    @StateObject var viewModel = denemeViewModel()
//    @State private var days = [Days]()
//    @State private var currentDate = Date()
//
//    var body: some View {
//        ScrollView(.horizontal) {
//            HStack {
//                ForEach(days) { day in
//                    VStack {
//                        Text(day.date.dateValue(), style: .date)
//                        Divider()
//                        ForEach(day.sessions.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
//                            HStack {
//                                Text(key)
//                                Spacer()
//                                Text("\(value.capacity)")
//                            }
//                            .padding(.horizontal)
//                        }
//                    }
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                    .padding(.vertical)
//                }
//            }
//        }
//        .onAppear {
//            fetchCurrentWeekDays()
//        }
//    }
//
//    // Firestore'dan şu an bulunduğumuz haftanın günlerini çeken fonksiyon
//    func fetchCurrentWeekDays() {
//        let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
//        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
//        
//        viewModel.fetchDays(startOfWeek: startOfWeek, endOfWeek: endOfWeek) { result in
//            switch result {
//            case .success(let days):
//                self.days = days
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//}