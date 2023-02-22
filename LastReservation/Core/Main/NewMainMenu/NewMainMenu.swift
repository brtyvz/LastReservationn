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
    var body: some View {
        ScrollView(.vertical,showsIndicators:false){
            
            LazyVStack(spacing:15,pinnedViews: [.sectionHeaders]) {
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
                                    taskModel.currentDay = day
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                }  header: {
                    HeaderView()
                }
            }
        }
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
        NewMainMenu()
    }
}
