//
//  ConfirmationView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 13.04.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct ConfirmationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var selectedDay: Days?
    @Binding var showConfirmation: Bool
    var selectedSession: String?
    @State var capacity: Int?
    var db = Firestore.firestore() // Firestore veritabanı referansı
    @State private var showingAlert = false
    @State private var showingAlertCapacity = false
    @State private var reservationBool = false
    var currentAction: Action?
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.4)
                .ignoresSafeArea()
            VStack {
                Text("Session Bilgileri")
                    .font(.headline)
                    .padding()
                if let day = selectedDay, let session = selectedSession, let capacity = capacity {
                    Text("Gün: \(formatDate(date: day.date.dateValue()))")
                        .font(.subheadline)
                        .padding()
                    Text("Saat: \(session)")
                        .font(.subheadline)
                        .padding()
                    Text("Kapasite: \(capacity)")
                        .font(.subheadline)
                        .padding()
                }
                Spacer()
                HStack {
                    Button(action: {
                        // Onaylama işlemi
                        if let user = authViewModel.currentUser {
                            updateCapacity(selectedDay: selectedDay!, selectedSession: selectedSession!, email: user.email)
                        }
                        
                       
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showConfirmation = false
                        }
                    }) {
                        Text("Onayla")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        // İptal işlemi
                        showConfirmation = false
                    }) {
                        Text("İptal")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }   .alert(isPresented: $showingAlert) {
                        if showingAlertCapacity {
                            return Alert(title: Text("Kapasite yok"))
                        }  else if reservationBool {
                            return Alert(title: Text("Rezervasyonunuz var"))
                        }
                         else {
                             return Alert(title: Text("Kayıt başarıyla gerçekleşti"))
                        }
                    }
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding()
        }
    }
    
        
    func updateCapacity(selectedDay: Days?, selectedSession: String,email: String) {
        checkIfUserAlreadyRegistered(email: email) { isRegistered in
            if isRegistered {
                self.showingAlert = true
                self.reservationBool = true
            } else {
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

                            if currentCapacity > 0 {
                                // Kapasiteyi güncelle
                                currentCapacity -= 1

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
                                        // State içindeki capacity değerini güncelle
                                        self.capacity = currentCapacity
                                    }
                                }
                                if let user = authViewModel.currentUser {
                                    saveReservationToFirestore(email: user.email, phoneNumber:user.number , session: selectedSession, date: selectedDay)
                                }
                            } else {
                                print("Kapasite tükendi!")
                                self.showingAlert = true
                                self.showingAlertCapacity = true
                            }
                        } else {
                            print("Firestore belgesi bulunamadı!")
                        }
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


    func saveReservationToFirestore(email: String, phoneNumber: String, session: String, date: Days) {
        checkIfUserAlreadyRegistered(email: email) { isRegistered in
            if isRegistered {
                self.showingAlert = true
                self.reservationBool = true
            } else {
                // Kullanıcı daha önce kayıt yaptırmamış, kayıt işlemini gerçekleştir
                let timestamp = selectedDay?.date
                
                // Firestore belgesine kaydedilecek veriyi hazırla
                let data: [String: Any] = [
                    "email": email,
                    "number": phoneNumber,
                    "session": session,
                    "date": timestamp
                ]

                // Firestore koleksiyonunu referansını oluştur
                let collectionRef = db.collection("Reservations")

                // Firestore koleksiyonuna veriyi kaydet
                collectionRef.addDocument(data: data) { error in
                    if let error = error {
                        // Hata durumunu işle
                        print("Firestore kaydetme hatası: \(error.localizedDescription)")
                    } else {
                        // Başarılı kaydetme durumunu işle
                        print("Firestore kaydetme başarılı!")
                    }
                }
            }
        }
    }




    // Tarih formatını ayarlayan yardımcı fonksiyon
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }

    enum Action {
        case deleteAccount
        case makePayment
    }

}
