//
//  DayView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 12.04.2023.
//

import SwiftUI

import Firebase

struct DayView: View {
    let day: Days
    @Binding var selectedDay: Days?

    var body: some View {
        VStack {
            Text(day.date.dateValue(), style: .date)
                .foregroundColor(day == selectedDay ? .white : .black)
                .frame(width: 60, height: 60)
                .background(day == selectedDay ? Color.black : Color.clear)
                .cornerRadius(30)
                .onTapGesture {
                    selectedDay = day
                }
            Divider()
            ForEach(day.sessions.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                HStack {
                    Text(key)
                        .foregroundColor(day == selectedDay ? .white : .black)
                        .onTapGesture {
                            // Handle session tap here
                        }
                    Spacer()
                    Text("\(value.capacity)")
                        .foregroundColor(day == selectedDay ? .white : .black)
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(day == selectedDay ? Color.black.opacity(0.8) : Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.vertical)
    }
}


