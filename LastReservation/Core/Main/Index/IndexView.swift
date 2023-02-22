//
//  IndexView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 12.02.2023.
//

import SwiftUI

struct IndexView: View {
    var body: some View {
        VStack {
            Button {
                    
                } label: {
                    VStack(spacing:5) {
                        HStack {
                            Text("Saat").bold()
                            Text("9.00").bold()
                        }
                        .padding()
                        HStack {
                            Text("Kapasite").bold()
                            Text("%55").bold()
                        }
                        .padding()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .background(Color.blue)
                   .foregroundColor(Color.white)
                   .cornerRadius(10)
                  
                }
        }
    }
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView()
    }
}
