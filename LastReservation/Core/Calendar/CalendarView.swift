//
//  CalendarView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 21.12.2022.
//

import SwiftUI

struct CalendarView: View {
    @State var currentDate: Date = Date()
    var body: some View {
        ScrollView(.vertical,showsIndicators: false) {
            VStack(spacing: 20) {
                CustomDatePicker(currentDate: $currentDate)
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
