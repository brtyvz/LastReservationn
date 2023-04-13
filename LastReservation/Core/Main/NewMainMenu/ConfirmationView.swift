//
//  ConfirmationView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 13.04.2023.
//

import SwiftUI
import Firebase

struct ConfirmationView: View {
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


}
