//
//  NewMainMenuViewModel.swift
//  LastReservation
//
//  Created by Berat Yavuz on 22.02.2023.
//

import Foundation

class NewMainMenuViewModel:ObservableObject{
    @Published var currentWeeks: [Date] = []
    
    @Published var currentDay: Date = Date()
    
    init(){
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek(){
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)

        guard let firstWeekDay = week?.start else{
            return
        }
        (1...7) .forEach{ day in
            
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeeks.append(weekday)
            }
            
        }
    }
    
    func extractDate(date:Date,format:String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
}

