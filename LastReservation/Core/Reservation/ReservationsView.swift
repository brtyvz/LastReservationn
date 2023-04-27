//
//  ReservationsView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 15.04.2023.
//

import SwiftUI
import Firebase

struct ReservationsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = denemeViewModel()
    
    var body: some View {
        
        if let user = authViewModel.currentUser {
            
            
            VStack(spacing:40) {
                    ForEach(viewModel.reservations) { reservation in
                            HStack(alignment: .center,spacing: 10) {
                            

                                Text(formatDate(date:reservation.date.dateValue()))
                                    .bold()
                                    .font(.title2)
                                    .foregroundColor(.purple.opacity(0.5))
                                Text("Session: \(reservation.session)")
                               
                                    .bold()
                                    .font(.title2)
                                Button(action: {
                                    // Rezervasyonu silme butonu
                                    if let user = authViewModel.currentUser {
                                        viewModel.deleteReservationsForEmail(resDelete: reservation)
                                    }
                                    
                                }) {
                                    Image(systemName: "multiply.circle.fill").font(.title)
                                        
                                        .foregroundColor(.red)
                                }
                            }.background(
                            Capsule()
                                .fill(.blue.opacity(0.2))
                                .frame(width: 400, height: 80, alignment: .center)
                            )
                        VStack{
                            Text("İtems").font(.title3)
                            ForEach(reservation.selectedItems, id: \.self) { item in
                                Text("\(item)")
                            }
                        }.background(
                            Capsule()
                                .fill(.blue.opacity(0.2))
                                .frame(width: 400, height: 80, alignment: .center)
                        )
                        .padding()
                      
                        
                    }
                    .navigationBarTitle("Reservations")
                    Spacer()
                
                   }.onAppear{ if let user = authViewModel.currentUser {
                viewModel.fetchReservationFromFirestore(email: user.email)
            }}
            
                   .padding(.top,40)
            
        }
        
        else {
            VStack {
                Text("Rzervasyonunuz Yok")
            }
        }
      
    }
}

struct ReservationsView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationsView()
    }
}

func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: date)
}

func updateCapacity(selectedDay: Days?, selectedSession: String,email: String) {
    var db = Firestore.firestore() // Firestore veritabanı referansı
    checkIfUserAlreadyRegistered(email: email) { isRegistered in
        if isRegistered {
           
        }
        else {
    if let selectedDay = selectedDay {
        // Seçili günün timestamp değerini al
        let timestamp = selectedDay.date

        // Timestamp'i Date veri tipine dönüştür
        let date = timestamp.dateValue()

        // Seçili günün timestamp değerini milisaniye cinsinden temsil et
        let timestampInMillis = Int64(date.timeIntervalSince1970 * 1000)

        // Firestore belge yolunu oluştur
        let documentPath = "Days/\(timestampInMillis)/sessions/\(selectedSession)"

        // Firestore belgesini referansını oluştur
        let documentRef = db.document(documentPath)

        // Firestore belgesini oku ve güncelleme işlemini gerçekleştir
        documentRef.getDocument { (snapshot, error) in
            if let error = error {
                // Hata durumunu işle
                print("Firestore okuma hatası: \(error.localizedDescription)")
            } else if let snapshot = snapshot, snapshot.exists {
                // Firestore belgesi varsa, mevcut veriyi al
                var currentCapacity = snapshot.data()?["capacity"] as? Int ?? 0

                if currentCapacity < 50 {
                    // Kapasiteyi güncelle
                    currentCapacity += 1

                    // Güncellenecek veriyi hazırla
                    let data: [String: Any] = ["capacity": currentCapacity]

                    // Firestore belgesini güncelle
                    documentRef.updateData(data) { error in
                        if let error = error {
                            // Hata durumunu işle
                            print("Firestore güncelleme hatası: \(error.localizedDescription)")
                        } else {
                            // Başarılı güncelleme durumunu işle
                            print("Firestore güncelleme başarılı!")
                            // Güncelleme başarılı olduğunda showConfirmation değerini true yapabilirsiniz.
                            // Örneğin:
                        }
                    }
                   
                } 
            } else {
                print("Firestore belgesi bulunamadı!")
            }
        }
    }
        }
    }

    func checkIfUserAlreadyRegistered(email: String, completion: @escaping (Bool) -> Void) {
        let collectionRef = db.collection("Reservations")
        
        collectionRef.whereField("email", isEqualTo: email)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    // Hata durumunu işle
                    print("Firestore okuma hatası: \(error.localizedDescription)")
                    completion(false)
                } else {
                    // Verileri işle
                    for document in querySnapshot!.documents {
                        // Kullanıcının daha önce kayıt yaptırıp yaptırmadığını kontrol et
                        if document.exists {
                            // Kullanıcı daha önce kayıt yaptırmış
                            completion(true)
                            return
                        }
                    }
                    // Kullanıcı daha önce kayıt yaptırmamış
                    completion(false)
                }
        }
    }
}
