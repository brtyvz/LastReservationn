//
//  ReservationView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 3.03.2023.
//

import SwiftUI

struct ReservationView: View {
    @StateObject var taskModel: NewMainMenuViewModel = NewMainMenuViewModel()
      @Binding var dateValue: String
      @Binding var hourValue: String
      @Binding var capacityValue: String
      
      var body: some View {
         
          ScrollView {
              ForEach(taskModel.firestoreDays.filter { day in
                  let calendar = Calendar.current
                  let today = Date()
                  let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
                  let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
                  return day.date >= startOfWeek && day.date <= endOfWeek
              }, id: \.self) { day in
                  VStack {
                      Text("\(day.capacity)")
                      Text(taskModel.extractDate(date: day.date, format: "dd/MM"))
                      Text("\(day.session)")
                  }
                  .frame(width: 150, height: 150)
                  .padding(10)
                  .background(Color.gray.opacity(0.2))
                  .cornerRadius(10)
              }
          }
          .onAppear {
              taskModel.fetchData()
          }




      }





        
        //            HStack(alignment: .top, spacing: 25){
        //                VStack(spacing:10){
        //                    Circle()
        //                        .fill(.black)
        //                        .frame(width:15,height:15)
        //                        .background(
        //                        Circle()
        //                            .stroke(.black,lineWidth: 1)
        //                            .padding(-3)
        //                        )
        //
        //                    Rectangle()
        //                        .fill(.black)
        //                        .frame(width:3)
        //                }
        //                ForEach(taskModel.reservation) { day in
        //
        //                    Button(action: {
        //                    }, label: {
        //                        VStack{
        //                            HStack (alignment: .top, spacing: 10){
        //                                VStack(alignment: .leading, spacing: 12){
        //                                    Text("Saat:\(day.hour)")
        //                                        .fontWeight(.bold)
        //                                    Text("Kapasite:\(day.capacity)")
        //                                        .fontWeight(.bold)
        //
        //                                    Text("Tarih:\(day.date)")
        //                                        .fontWeight(.bold)
        //                                }
        //                            }
        //                        }
        //                        .padding()
        //
        //                        .background(Color("Purple"))
        //                        .cornerRadius(25)
        //                        .foregroundColor(.white)
        //                    }
        //                          )
        //                }
        //
        //            }
        
        
    }
    


//struct ReservationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReservationView(
//            dateValue: .constant("23 ekim"), hourValue:.constant("22.00"), capacityValue: .constant("34")
//        )
//    }
//}
