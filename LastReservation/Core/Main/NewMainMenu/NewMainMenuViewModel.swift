//
//  NewMainMenuViewModel.swift
//  LastReservation
//
//  Created by Berat Yavuz on 22.02.2023.
//

import Foundation
import SwiftUI

class NewMainMenuViewModel:ObservableObject{
    @Published var currentWeeks: [Date] = []
    
    @Published var currentDay: Date = Date()
    
    @Published var filteredDays:[DayModel]?
    
    @Published var storedDays:[DayModel] = [
    
        DayModel(hour: "9.00", capacity: "55", taskDate: .init(timeIntervalSince1970: 1677241700)),
        DayModel(hour: "10.00", capacity: "40", taskDate: .init(timeIntervalSince1970: 1677241700)),
        DayModel(hour: "11.00", capacity: "40", taskDate: .init(timeIntervalSince1970: 1677241700)),
        DayModel(hour: "12.00", capacity: "54", taskDate: .init(timeIntervalSince1970: 1677241700)),
        DayModel(hour: "13.00", capacity: "43", taskDate: .init(timeIntervalSince1970: 1677241700)),
        DayModel(hour: "14.00", capacity: "5", taskDate: .init(timeIntervalSince1970: 1677241700)),
        DayModel(hour: "15.00", capacity: "23", taskDate: .init(timeIntervalSince1970: 1677241700))
        
    
    ]
    
    init(){
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    func filterTodayTasks(){
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            
            let filtered = self.storedDays.filter{
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
            DispatchQueue.main.async {
                withAnimation{
                    self.filteredDays = filtered
                }
            }
        }
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

