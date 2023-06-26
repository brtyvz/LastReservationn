//
//  ReservationsView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 15.04.2023.
//

//
//  ReservationsView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 15.04.2023.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import FirebaseStorage

struct ReservationsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = denemeViewModel()
    @State var url = "AB6CA8C7-995B-44D9-B846-0472F7A9F695.jpeg"
    
    var body: some View {
        
        if let user = authViewModel.currentUser {
            ScrollView(showsIndicators:false) {
                if viewModel.reservations.isEmpty{
                    VStack {
                        Text("Rezervasyonunuz Yok !").bold().font(.title)
                    }
                }
                else {
                   
                    GeometryReader { geometry in
                            VStack(spacing:5) {
                                    ForEach(viewModel.reservations) { reservation in
                                            HStack(alignment: .center,spacing: 10) {
                                            
                                                Text(formatDate(date:reservation.date.dateValue()))
                                                    .bold()
                                                    .font(.title2)
                                                    .foregroundColor(.purple.opacity(0.8))
                                                Text("Seans: \(reservation.session)")
                                               
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
                                            Text("Eşyalar").font(.title3).foregroundColor(.purple.opacity(0.7)).bold()
                                            ForEach(reservation.selectedItems, id: \.self) { item in
                                                Text("\(item)").foregroundColor(Color.black.opacity(0.7)).bold()
                                            }
                                        }.background(
                                            Capsule()
                                                .fill(.pink.opacity(0.2))
                                                .frame(width: 400, height: 110, alignment: .center)
                                        )
                                       
                                        .padding()
                                        
                                        VStack {
                                          
                                            AnimatedImage(url: URL(string: url)!).resizable().frame(width: 350, height: 500).cornerRadius(20)
                                                    
                                            
                                        } .onAppear{
                                            let storage = Storage.storage().reference()
                                            storage.child("\(reservation.imageUrl)").downloadURL { (url,err) in
                                                if let err = err {
                                                    print(err.localizedDescription)
                                                } else if let url = url {
                                                    DispatchQueue.main.async {
                                                        self.url = url.absoluteString
                                                    }
                                                }
                                            }
                                        }
                                    
                                 
                                    .navigationBarTitle("Rezervasyonlar")
                                    Spacer()
                                
                                   }
                       
                        .padding(.top,40)
                        }
                            .frame(width: geometry.size.width)
                    }
                    .padding(.top, 40)
                     
                }
            
            }
            .onAppear{
                viewModel.fetchReservationFromFirestore(email: user.email)}
         
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









