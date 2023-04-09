//
//  NewMainMenu.swift
//  LastReservation
//
//  Created by Berat Yavuz on 21.02.2023.
//

import SwiftUI

struct NewMainMenu: View {
    @StateObject var taskModel:NewMainMenuViewModel = NewMainMenuViewModel()
    @Namespace var animation
    @State var alert = false
    @State var date:String = "1 ekim"
    @State var session:String = "10.00"
    @State var capacity:Int = 50
    let weekStartingDate = Calendar.current.date(bySetting: .weekday, value: 2, of: Date())!
    var body: some View {
//        let weekdays = Calendar.current.shortWeekdaySymbols
//        let weekEndingDate = Calendar.current.date(byAdding: .day, value: 6, to: weekStartingDate)!
//        let daysInWeek = Calendar.current.dateComponents([.day], from: weekStartingDate, to: weekEndingDate).day! + 1
//        let days = (0..<daysInWeek).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: weekStartingDate) }
        ScrollView(.vertical,showsIndicators:false){
            
//            NavigationLink("CustomAlertView", destination:CustomAlertView(show: $alert), isActive: $alert)
            
            ZStack {
                LazyVStack(spacing:15,pinnedViews: [.sectionHeaders]) {
                    HeaderView()
                    Section {
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack(spacing:10) {
                                ForEach(taskModel.firestoreDays, id: \.id) { firestoreDay in
                                    VStack(spacing: 10) {
                                        Text(taskModel.extractDate(date: firestoreDay.date, format: "dd"))
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                        
                                        Text(taskModel.extractDate(date: firestoreDay.date, format: "EEE"))
                                            .font(.system(size: 14))
                                        
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 8, height: 8)
                                            .opacity(taskModel.isToday(date: firestoreDay.date) ? 1 : 0)
                                    }
                                    .foregroundStyle(taskModel.isToday(date: firestoreDay.date) ? .primary : .secondary)
                                    .foregroundColor(taskModel.isToday(date: firestoreDay.date) ? .white : .black)
                                    // Capsule shape
                                    .frame(width: 45, height: 90)
                                    .background(
                                        ZStack{
                                            if taskModel.isToday(date: firestoreDay.date) {
                                                Capsule()
                                                    .fill(.black)
                                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                            }
                                        }
                                    )
                                    .onTapGesture {
                                        withAnimation{
                                            let dayString = firestoreDay.date
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "E, d MMM"
                                            let dayLast = formatter.string(from: dayString)

                                            self.date = dayLast
                                            taskModel.currentDay = firestoreDay.date
                                        }
                                    }
                                }



                        }
                        .padding(.horizontal)
                    }
                       
                        TasksView()
                    }
                }
                .onAppear{
                    taskModel.fetchData(for: weekStartingDate)
                }
                if alert {
                    CustomAlertView(show: $alert,session: $session,date: $date, capacity: $capacity)
                }
            }
        }
    }
    
    func TasksView() -> some View{
        
        LazyVStack(spacing:18) {
            let weekdays = Calendar.current.shortWeekdaySymbols
            let weekEndingDate = Calendar.current.date(byAdding: .day, value: 6, to: weekStartingDate)!
            let daysInWeek = Calendar.current.dateComponents([.day], from: weekStartingDate, to: weekEndingDate).day! + 1
            let days = (0..<daysInWeek).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: weekStartingDate) }
            if let tasks = taskModel.filteredDays {
                if tasks.isEmpty{
                    ForEach(days, id: \.self) { day in
                        let filteredDays = taskModel.firestoreDays.filter { $0.date == day }
                        let firestoreDay = filteredDays.first ?? FirestoreDays(session: "", capacity: 0, date: day)
                        TaskCardView(hour: "\(firestoreDay.session)", capacity:firestoreDay.capacity )
                    }
                }
                else {
                    ForEach(days, id: \.self) { day in
                        let filteredDays = taskModel.firestoreDays.filter { $0.date == day }
                        let firestoreDay = filteredDays.first ?? FirestoreDays(session: "", capacity: 0, date: day)
                        TaskCardView(hour: "\(firestoreDay.session)", capacity:firestoreDay.capacity )
                    }
                }
            }
            else {
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        .onChange(of: taskModel.currentDay) { newValue in
            taskModel.filterTodayTasks()
        }
        
    }
    

    func TaskCardView(hour:String,capacity:Int) -> some View {
        HStack(alignment: .top, spacing: 25){
            VStack(spacing:10){
                Circle()
                    .fill(.black)
                    .frame(width:15,height:15)
                    .background(
                    Circle()
                        .stroke(.black,lineWidth: 1)
                        .padding(-3)
                    )
                
                Rectangle()
                    .fill(.black)
                    .frame(width:3)
            }
            Button(action: {
                self.alert.toggle()
                self.session = hour
                self.capacity = capacity
            }, label: {
                VStack{
                    
                    HStack (alignment: .top, spacing: 10){
                        VStack(alignment: .leading, spacing: 12){
                            Text("Saat:\(hour)")
                                .fontWeight(.bold)
                            Text("Kapasite:\(capacity)")
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding()
                .hLeading()
                .background(Color("Purple"))
                .cornerRadius(25)
                .foregroundColor(.white)
            }
                  )
        }
                   
        .hLeading()
      
    }
    
    func HeaderView()-> some View {
        HStack(spacing:10){
            VStack(alignment:.leading,spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today")
                    .font(.largeTitle.bold())
                
            }
          
        }
    }
}

struct NewMainMenu_Previews: PreviewProvider {
    static var previews: some View {
        NewMainMenu(date: "1 ekim", session: "11.00", capacity: 50)
    }
}


extension View{
    func hLeading()->some View{
        self.frame(maxWidth:.infinity,alignment: .leading)
    }
}


extension Formatter {
    static let weekDay: DateFormatter = {
        let formatter = DateFormatter()

        // you can use a fixed language locale
        formatter.locale = Locale(identifier: "zh")
        // or use the current locale
        // formatter.locale = .current
        
        // and for standalone local day of week use ccc instead of E
        formatter.dateFormat = "ccc"
        return formatter
    }()
}
