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
        
    // Tarih formatını ayarlayan yardımcı fonksiyon
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}


