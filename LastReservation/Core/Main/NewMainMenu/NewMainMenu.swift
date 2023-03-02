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
    @State var hour:String = "10.00"
    @State var capacity:String = "50"
    
    var body: some View {
        ScrollView(.vertical,showsIndicators:false){
            
//            NavigationLink("CustomAlertView", destination:CustomAlertView(show: $alert), isActive: $alert)
            
            ZStack {
                LazyVStack(spacing:15,pinnedViews: [.sectionHeaders]) {
                    HeaderView()
                    Section {
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack(spacing:10) {
                                ForEach(taskModel.currentWeeks,id:\.self){ day in
                                    VStack(spacing:10){
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width:8,height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1:0)
                                }
                                    .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                    .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                    
                                // Capsule shape
                                .frame(width:45,height:90)
                                .background(
                                
                                    ZStack{
                                        if taskModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .onTapGesture {
                                    withAnimation{
                                        let dayString = day
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "E, d MMM"
                                       let dayLast = formatter.string(from: dayString)
                                        

                                        self.date = dayLast
                                        taskModel.currentDay = day
                                    }
                                }
                               
                            }
                        }
                        .padding(.horizontal)
                    }
                       
                        TasksView()
                    }
                }
                if alert {
                    CustomAlertView(show: $alert,hour: $hour,date: $date, capacity: $capacity)
                }
            }
        }
    }
    
    func TasksView() -> some View{
        
        LazyVStack(spacing:18) {
            if let tasks = taskModel.filteredDays {
                if tasks.isEmpty{
                    ForEach(0..<6){i in
                        TaskCardView(hour: "\(taskModel.hours[i])", capacity: "\(taskModel.capacity[0])")
                    }
                }
                else {
                    ForEach(0..<6){i in
                        TaskCardView(hour: "\(taskModel.hours[i])", capacity: "\(taskModel.capacity[0])")
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
    

    func TaskCardView(hour:String,capacity:String) -> some View {
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
                self.hour = hour
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
        NewMainMenu(date: "1 ekim", hour: "11.00", capacity: "50")
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
