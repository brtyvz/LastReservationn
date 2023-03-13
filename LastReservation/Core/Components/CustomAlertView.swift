//
//  CustomAlertView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 28.02.2023.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var show :Bool
    @Binding var hour:String
    @Binding var date:String
    @Binding var capacity:String
    @StateObject var taskModel:NewMainMenuViewModel = NewMainMenuViewModel()
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical:.top)){
            VStack(spacing:25){
                Text("Rezervasyonu Onaylıyor Musunuz?")
                    .font(.title)
                    .bold()
                    .foregroundColor(.purple)
                Text("\(date) Saat:\(hour)")
                Text("Kapasite:\(capacity)")
                    .bold()
                
                
                HStack {
                    
//                    NavigationLink {
//
//                        ReservationView(dateValue: $date, hourValue: $hour, capacityValue: $capacity)
//                    } label: {
//                        Text("Onaylıyorum")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                            .padding(.vertical,10)
//                            .padding(.horizontal,25)
//                            .background(Color.purple)
//                            .clipShape(Capsule())
//                    }
                    
                    Button {
                        if let cap = Int(capacity) {
                            capacity = String(max(cap - 1, 0))
                           }
//                        print("kapasite:\(capacity)")
//
//                       taskModel.addReservation(capacity: capacity, hour: hour, date: date)
                        
                        taskModel.addReservation(capacity: "", hour: "", date: "")
                     
//                        taskModel.updateReservation(date: date, hour: hour, capacity: capacity)
//                        print("Tarih:\(date) Saat:\(hour) / Kapasite:\(capacity)")

                    } label: {
                        Text("Onaylıyorum")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical,10)
                            .padding(.horizontal,25)
                            .background(Color.purple)
                            .clipShape(Capsule())
                    }
                    
                    Button {
                        show.toggle()
                    } label: {
                        Text("Vazgeç")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical,10)
                            .padding(.horizontal,25)
                            .background(Color.purple)
                            .clipShape(Capsule())
                    }
                    
                }
              

            }
            .padding(.vertical,25)
            .padding(.horizontal,30)
            .background(BlurView())
            .cornerRadius(25)
            
            Button {
                    show.toggle()
                
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 28,weight: .bold))
                    .foregroundColor(.black)
                    .padding(.trailing,5)
                    .padding(.top,5)
            }
            
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.01)
        )
    }
}

struct BlurView:UIViewRepresentable {
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
      
        return view
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(
            show: .constant(true),
            hour: .constant("10.00"),
            date:.constant("2 ekim"),
            capacity: .constant("50")
        )
    }
}
