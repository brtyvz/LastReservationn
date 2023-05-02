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


