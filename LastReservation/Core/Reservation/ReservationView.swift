////
////  ReservationView.swift
////  LastReservation
////
////  Created by Berat Yavuz on 3.03.2023.
////
//
//import SwiftUI
//
//struct ReservationView: View {
//    @StateObject var taskModel: NewMainMenuViewModel = NewMainMenuViewModel()
//    @Binding var dateValue: String
//    @Binding var hourValue: String
//    @Binding var capacityValue: String
//    @State private var isConfirmed = false
//
//    let today = Calendar.current.startOfDay(for: Date())
//   
//
//
//    var body: some View {
//        
//        let weekStartingDate = Calendar.current.date(byAdding: .day, value: -Calendar.current.component(.weekday, from: today) + 2, to: today)!
//        let weekdays = Calendar.current.shortWeekdaySymbols
//        let weekEndingDate = Calendar.current.date(byAdding: .day, value: 6, to: weekStartingDate)!
//        let daysInWeek = Calendar.current.dateComponents([.day], from: weekStartingDate, to: weekEndingDate).day! + 1
//        let days = (0..<daysInWeek).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: weekStartingDate) }
//        VStack {
//            Text("Weekly Schedule")
//                .font(.title)
//                .padding(.bottom, 10)
//            
//            ScrollView(.horizontal) {
//                HStack(spacing: 10) {
//                    ForEach(taskModel.firestoreDays, id: \.self) { day in
//                        let filteredDays = taskModel.firestoreDays.filter { $0.date == day }
//                        let firestoreDay = filteredDays.first ?? FirestoreDays(session: "", capacity: 0, date: day)
//                        
//                        VStack {
//                            Text(taskModel.extractDate(date: firestoreDay.date, format: "dd/MM"))
//                        }
//                        .frame(width: 150, height: 150)
//                        .padding(10)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(10)
//                        
//                        Button(action: {
//                            dateValue = taskModel.extractDate(date: firestoreDay.date, format: "dd/MM")
//                        }) {
//                            Text("Select Date")
//                        }
//                    }
//                }
//            }
//
//
//            
//            ScrollView {
//                ForEach(days, id: \.self) { day in
//                    let filteredDays = taskModel.firestoreDays.filter { $0.date == day }
//                    let firestoreDay = filteredDays.first ?? FirestoreDays(session: "", capacity: 0, date: day)
//                    
//                    VStack {
//                        
//                        Text(DateFormatter.localizedString(from: firestoreDay.date, dateStyle: .short, timeStyle: .none))
//
//                        Text("\(firestoreDay.capacity)")
//                        Text(firestoreDay.session)
//                    }
//                    .frame(width: 150, height: 150)
//                    .padding(10)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                }
//            }
//            .onAppear {
//                taskModel.fetchData(for: weekStartingDate)
//            }
//        }
//        .padding()
//        
//        VStack {
//                // FireStoreDays verilerini görüntülemek için bir liste oluşturun
//            List(taskModel.firestoreDays, id: \.id) { firestoreDay in
//                    Text(firestoreDay.session)
//                    Text("\(firestoreDay.capacity)")
//                    Text("\(firestoreDay.date)")
//                }
//            }
//            .onAppear {
//                taskModel.fetchData(for: Date()) // Bu görünüm açıldığında verileri yükleyin
//            }
//    }
//    
//    
//}
//
//    
//
//
////struct ReservationView_Previews: PreviewProvider {
////    static var previews: some View {
////        ReservationView(
////            dateValue: .constant("23 ekim"), hourValue:.constant("22.00"), capacityValue: .constant("34")
////        )
////    }
////}
//
//
//
//
//
////            HStack(alignment: .top, spacing: 25){
////                VStack(spacing:10){
////                    Circle()
////                        .fill(.black)
////                        .frame(width:15,height:15)
////                        .background(
////                        Circle()
////                            .stroke(.black,lineWidth: 1)
////                            .padding(-3)
////                        )
////
////                    Rectangle()
////                        .fill(.black)
////                        .frame(width:3)
////                }
////                ForEach(taskModel.reservation) { day in
////
////                    Button(action: {
////                    }, label: {
////                        VStack{
////                            HStack (alignment: .top, spacing: 10){
////                                VStack(alignment: .leading, spacing: 12){
////                                    Text("Saat:\(day.hour)")
////                                        .fontWeight(.bold)
////                                    Text("Kapasite:\(day.capacity)")
////                                        .fontWeight(.bold)
////
////                                    Text("Tarih:\(day.date)")
////                                        .fontWeight(.bold)
////                                }
////                            }
////                        }
////                        .padding()
////
////                        .background(Color("Purple"))
////                        .cornerRadius(25)
////                        .foregroundColor(.white)
////                    }
////                          )
////                }
////
////            }
