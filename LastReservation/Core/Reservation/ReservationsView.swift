//
//  ReservationsView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 15.04.2023.
//

import SwiftUI

struct ReservationsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = denemeViewModel()
    
    var body: some View {
        VStack{
            ForEach(viewModel.reservations,id:\.self) { reservation in
                Text(reservation.email)
                Text(reservation.session)
                Text(formatDate(date:reservation.date.dateValue()))
                Text(reservation.number)
            }
            
        }.onAppear{ if let user = authViewModel.currentUser {
            viewModel.fetchReservationFromFirestore(email: user.email)
        }}
       
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
