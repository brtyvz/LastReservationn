//
//  Task.swift
//  LastReservation
//
//  Created by Berat Yavuz on 17.02.2023.
//

import Foundation
import FirebaseFirestore



struct Task: Identifiable{
    
    var id = UUID().uuidString
    var title:String
    var time:Date = Date()
}

struct TaskMetaData: Identifiable{
    var id = UUID().uuidString
    var task: [Task]
    var taskDate: Date
}

func getSampleData(offset: Int) -> Date {
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

var tasks: [TaskMetaData] = [

    TaskMetaData(task: [
    Task(title: "Task1"),
    Task(title: "Last Task")
    ], taskDate: getSampleData(offset: 1)),
    
        TaskMetaData(task: [
        Task(title: "Task2"),
        Task(title: "first Task")
        ], taskDate: getSampleData(offset: -3)),
        
    TaskMetaData(task: [
    Task(title: "Task3"),
    Task(title: "middle🦹‍♀️ Task")
    ], taskDate: getSampleData(offset: -8)),
]



