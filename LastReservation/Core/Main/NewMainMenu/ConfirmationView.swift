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
    var capacity: Int?
    var db = Firestore.firestore() // Firestore veritabanı referansı
    
   
    
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
                       updateCapacity(selectedDay: selectedDay!, selectedSession: selectedSession!)
                        if let user = authViewModel.currentUser {
                            saveReservationToFirestore(email: user.email, phoneNumber:user.number, session: selectedSession!, date: selectedDay!)
                        }
                      
                        showConfirmation = false
                        
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
                    }
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding()
        }
    }
        
    func updateCapacity(selectedDay: Days?, selectedSession: String) {
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
                            // Güncelleme başarılı olduğunda showConfirmation değerini true yapabilirsiniz.
                            // Örneğin:
                            self.showConfirmation = true
                        }
                    }
                } else {
                    print("Firestore belgesi bulunamadı!")
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
    
    func saveReservationToFirestore(email: String, phoneNumber: String, session: String, date: Days) {
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
                // Kaydetme başarılı olduğunda showConfirmation değerini true yapabilirsiniz.
                // Örneğin:
                self.showConfirmation = true
            }
        }
    }


    
}




    
 












//import Foundation
//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//class AuthViewModel:ObservableObject {
//
//    @Published var userSession:FirebaseAuth.User?
//    @Published var didAuthenticateUser = false
//    @Published var currentUser:User?
//    private var tempUserSession:FirebaseAuth.User?
//
//    let auth = Auth.auth()
//    private let service = UserService()
//
//    init(){
//        self.userSession = Auth.auth().currentUser
//        self.fetchUser()
//    }
//
//    //MARK: - Login
//        func login(email email: String, password: String) {
//            Auth.auth().signIn(withEmail: email, password: password) { result, error in
//                if let error = error {
//                    print("DEBUG: Failed to register with error \(error.localizedDescription)")
//                    return
//                }
//
//                guard let user = result?.user else { return }
//                self.userSession = user
//                self.fetchUser()
//                print("DEBUG: Did Log user in.. \(String(describing: self.userSession?.email))")
//            }
//        }
//
//    func register(email:String,password:String,number:String) {
//        auth.createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                print("\(error.localizedDescription)")
//                return
//            }
//            guard let user  = result?.user else {return}
//            self.tempUserSession = user
//
//            print("Registered user succesfuly")
//            let data = ["email":email,"number":number,"uid":user.uid]
//
//            Firestore.firestore().collection("users")
//                .document(user.uid)
//                .setData(data) { _ in
//                    print("did upload user data")
//                    self.didAuthenticateUser = true
//                }
//        }
//    }
//
//    func signOut() {
//        userSession = nil
//        try? auth.signOut()
//    }
//
//    func fetchUser() {
//           guard let uid = self.userSession?.uid else { return }
//
//           service.fetchUser(withUid: uid) { user in
//               self.currentUser = user
//           }
//       }
//}
