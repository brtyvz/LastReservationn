//
//  CalendarMainView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 13.02.2023.
//

import SwiftUI

struct CalendarMainView: View {
    var body: some View {
        HStack {
            ScrollView{
                Button {
                    
                } label: {
                    VStack(spacing:5) {
                        HStack {
                            Text("29 Kasım 2023").bold()
                        }
                        .padding()
                    }
                    
                    .background(Color.green)
                   .foregroundColor(Color.white)
                   .cornerRadius(10)
                  
                }

            }
        }
    }
}

struct CalendarMainView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMainView()
    }
}
