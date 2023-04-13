//
//  File.swift
//  LastReservation
//
//  Created by Berat Yavuz on 13.03.2023.
//




//func fetchDays() {
//    days.removeAll()
//    let db = Firestore.firestore()
//    let ref = db.collection("ReservationsLast")
//    
//    // Get the start and end dates of the current week
//    let calendar = Calendar.current
//    let currentDate = Date()
//    let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: currentDate)!.start
//    let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
//    
//    // Add filter to query for days within the week
//    let query = ref.whereField("Date", isGreaterThanOrEqualTo: startOfWeek)
//                   .whereField("Date", isLessThanOrEqualTo: endOfWeek)
//    
//    query.getDocuments { snapshot, error in
//        guard error == nil else {
//            print(error!.localizedDescription)
//            return
//        }
//        
//        if let snapshot = snapshot {
//            for document in snapshot.documents {
//                let data = document.data()
//                
//                let hour = data["Hour"] as? String ?? ""
//                let capacity = data["Capacity"] as? String ?? ""
//                let date = data["Date"] as? Date ?? .init(timeIntervalSince1970: 1677241700)
//                let day = DayModel(hour: hour, capacity: capacity, taskDate: date)
//                
//                self.days.append(day)
//            }
//        }
//    }
//}






////fetch Days
//func fetchDays() {
//    days.removeAll()
//    let db = Firestore.firestore()
//    let ref = db.collection("Reservations")
//
//    // Get the start and end dates of the current week
//    let calendar = Calendar.current
//    let currentDate = Date()
//    let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: currentDate)!.start
//    let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
//
//    // Add filter to query for days within the week
//    let query = ref.whereField("date", isGreaterThanOrEqualTo: startOfWeek)
//                   .whereField("date", isLessThanOrEqualTo: endOfWeek)
//
//    query.getDocuments { snapshot, error in
//        guard error == nil else {
//            print(error!.localizedDescription)
//            return
//        }
//
//        if let snapshot = snapshot {
//            for document in snapshot.documents {
//                let data = document.data()
//
//                let session = data["session"] as? String ?? ""
//                let capacity = data["capacity"] as? Int ?? 0
//                let dateTimestamp = data["date"] as? Timestamp ?? Timestamp(date: Date())
//                let date = dateTimestamp.dateValue()
//                let day = DayModel(hour: session, capacity: "\(capacity)", taskDate: date)
//
//                self.days.append(day)
//            }
//        }
//    }
//}





//
//
//view model
//
//

//    func fetchData() {
//        let db = Firestore.firestore()
//        db.collection("ReservationsLast").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                var firestoreDays: [FirestoreDays] = []
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                for document in querySnapshot!.documents {
//                    let data = document.data()
//                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
//                    let capacity = data["capacity"] as? Int ?? 0
//                    let session = data["session"] as? String ?? ""
//
//                    let firestoreDay = FirestoreDays(session: session, capacity: capacity, date: date)
//                    firestoreDays.append(firestoreDay)
//                }
//                self.firestoreDays = firestoreDays
//            }
//        }
//    }






//    func fetchData() {
//        let db = Firestore.firestore()
//        db.collection("ReservationsLast").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                var firestoreDays: [FirestoreDays] = []
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                for document in querySnapshot!.documents {
//                    let data = document.data()
//                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
//                    let session = (data["session"] as? Timestamp)?.dateValue() ?? Date()
//                    let capacity = data["capacity"] as? Int ?? 0
//                    let firestoreDay = FirestoreDays(session: session, capacity: capacity, date: date)
//                    firestoreDays.append(firestoreDay)
//                }
//                self.firestoreDays = firestoreDays
//            }
//        }
//    }


//                let db = Firestore.firestore()
//                let ref = db.collection("Index").document()
//                ref.setData(["Capacity":capacity,"hour":hour,"date":date]){ error in
//
//                    if let error = error {
//                        print(error.localizedDescription)
//                    }
//
//                }


//    func getRandevular() {
//         let db = Firestore.firestore()
//         let collectionRef = db.collection("Reservations")
//
//         collectionRef.getDocuments { (querySnapshot, error) in
//             if let error = error {
//                 print("Hata: \(error.localizedDescription)")
//                 return
//             }
//
//             var randevular = [ReservationModel]()
//
//             for document in querySnapshot!.documents {
//                 let data = document.data()
//
//                 guard let date = data["date"] as? String,
//                       let session = data["session"] as? String,
//                       let capacity = data["capacity"] as? Int else {
//                     continue
//                 }
//
////                 self.getDate(from: date)
//
//                 let randevu = ReservationModel(hour: session, capacity: capacity, date: date)
//                 randevular.append(randevu)
//             }
//
//             DispatchQueue.main.async {
//                 self.reservation = randevular
//             }
//         }
//
//
//
//     }
















//
//struct NewMainMenu: View {
//    @ObservedObject var firebaseViewModel = NewMainMenuViewModel()
//    @StateObject var taskModel:NewMainMenuViewModel = NewMainMenuViewModel()
//    @Namespace var animation
//    @State var alert = false
//    @State var date:String = "1 ekim"
//    @State var session:String = "10.00"
//    @State var documentID:String = "10.00"
//    @State var capacity:Int = 50
//    let weekStartingDate = Calendar.current.date(bySetting: .weekday, value: 2, of: Date())!
//    var body: some View {
//
//        ScrollView(.vertical,showsIndicators:false){
//            
//
//            
//            ZStack {
//                LazyVStack(spacing:15,pinnedViews: [.sectionHeaders]) {
//                    HeaderView()
//                    Section {
//                        ScrollView(.horizontal,showsIndicators: false){
//                            HStack(spacing:10) {
//                                ForEach(taskModel.firestoreDays, id: \.id) { firestoreDay in
//                                    VStack(spacing: 10) {
//                                        Text(taskModel.extractDate(date: firestoreDay.date, format: "dd"))
//                                            .font(.system(size: 15))
//                                            .fontWeight(.semibold)
//                                        
//                                        Text(taskModel.extractDate(date: firestoreDay.date, format: "EEE"))
//                                            .font(.system(size: 14))
//                                        
//                                        Circle()
//                                            .fill(.white)
//                                            .frame(width: 8, height: 8)
//                                            .opacity(taskModel.isToday(date: firestoreDay.date) ? 1 : 0)
//                                    }
//                                    .foregroundStyle(taskModel.isToday(date: firestoreDay.date) ? .primary : .secondary)
//                                    .foregroundColor(taskModel.isToday(date: firestoreDay.date) ? .white : .black)
//                                    // Capsule shape
//                                    .frame(width: 45, height: 90)
//                                    .background(
//                                        ZStack{
//                                            if taskModel.isToday(date: firestoreDay.date) {
//                                                Capsule()
//                                                    .fill(.black)
//                                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
//                                            }
//                                        }
//                                    )
//                                    .onTapGesture {
//                                        withAnimation{
//                                            let dayString = firestoreDay.date
//                                            let formatter = DateFormatter()
//                                            formatter.dateFormat = "E, d MMM"
//                                            let dayLast = formatter.string(from: dayString)
//
//                                            self.date = dayLast
//                                            taskModel.currentDay = firestoreDay.date
//                                        }
//                                    }
//                                }
//
//
//
//                        }
//                        .padding(.horizontal)
//                    }
//                       
//                        TasksView()
//                    }
//                }
//                .onAppear{
//                    taskModel.fetchData(for: weekStartingDate)
//                }
//                if alert {
//                    CustomAlertView(show: $alert,session: $session,date: $date, capacity: $capacity)
//                }
//            }
//        }
//    }
//    
//    func TasksView() -> some View{
//        
//        LazyVStack(spacing:18) {
//            let weekdays = Calendar.current.shortWeekdaySymbols
//            let weekEndingDate = Calendar.current.date(byAdding: .day, value: 6, to: weekStartingDate)!
//            let daysInWeek = Calendar.current.dateComponents([.day], from: weekStartingDate, to: weekEndingDate).day! + 1
//            let days = (0..<daysInWeek).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: weekStartingDate) }
//            if let tasks = taskModel.filteredDays {
//                if tasks.isEmpty{
//                    ForEach(days, id: \.self) { day in
//                        let filteredDays = taskModel.firestoreDays.filter { $0.date == day }
//                        let firestoreDay = filteredDays.first ?? FirestoreDays(documentID: "", session: "", capacity: 3, date: day)
//                        TaskCardView(hour: "\(firestoreDay.session)", capacity:firestoreDay.capacity )
//                    }
//                }
//                else {
//                    ForEach(days, id: \.self) { day in
//                        let filteredDays = taskModel.firestoreDays.filter { $0.date == day }
//                        let firestoreDay = filteredDays.first ?? FirestoreDays(documentID: "", session: "", capacity: 3, date: day)
//                        TaskCardView(hour: "\(firestoreDay.session)", capacity:firestoreDay.capacity )
//                    }
//                }
//            }
//            else {
//                ProgressView()
//                    .offset(y: 100)
//            }
//        }
//        .padding()
//        .padding(.top)
//        .onChange(of: taskModel.currentDay) { newValue in
//            taskModel.filterTodayTasks()
//        }
//        
//    }
//    
//
//    func TaskCardView(hour:String,capacity:Int) -> some View {
//        HStack(alignment: .top, spacing: 25){
//            VStack(spacing:10){
//                Circle()
//                    .fill(.black)
//                    .frame(width:15,height:15)
//                    .background(
//                    Circle()
//                        .stroke(.black,lineWidth: 1)
//                        .padding(-3)
//                    )
//                
//                Rectangle()
//                    .fill(.black)
//                    .frame(width:3)
//            }
//            Button(action: {
//                self.alert.toggle()
//                self.session = hour
//                self.capacity = capacity
//            }, label: {
//                VStack{
//                    
//                    HStack (alignment: .top, spacing: 10){
//                        VStack(alignment: .leading, spacing: 12){
//                            Text("Saat:\(hour)")
//                                .fontWeight(.bold)
//                            Text("Kapasite:\(capacity)")
//                                .fontWeight(.bold)
//                        }
//                    }
//                }
//                .padding()
//                .hLeading()
//                .background(Color("Purple"))
//                .cornerRadius(25)
//                .foregroundColor(.white)
//            }
//                  )
//        }
//                   
//        .hLeading()
//      
//    }
//    
//    func HeaderView()-> some View {
//        HStack(spacing:10){
//            VStack(alignment:.leading,spacing: 10) {
//                Text(Date().formatted(date: .abbreviated, time: .omitted))
//                    .foregroundColor(.gray)
//                
//                Text("Today")
//                    .font(.largeTitle.bold())
//                
//            }
//          
//        }
//    }
//}
//
//struct NewMainMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        NewMainMenu(date: "1 ekim", session: "11.00", capacity: 50)
//    }
//}
//
//
//extension View{
//    func hLeading()->some View{
//        self.frame(maxWidth:.infinity,alignment: .leading)
//    }
//}
//
//
//extension Formatter {
//    static let weekDay: DateFormatter = {
//        let formatter = DateFormatter()
//
//        // you can use a fixed language locale
//        formatter.locale = Locale(identifier: "zh")
//        // or use the current locale
//        // formatter.locale = .current
//        
//        // and for standalone local day of week use ccc instead of E
//        formatter.dateFormat = "ccc"
//        return formatter
//    }()
//}
