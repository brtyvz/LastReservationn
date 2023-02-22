//
//  MainMenuView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 21.12.2022.
//

import SwiftUI

struct MainMenuView: View {
    private let gridItem = [GridItem(.flexible()),GridItem(.flexible())]
    
     
     var body: some View {
         
         VStack {
             
                 ScrollView(.horizontal,showsIndicators: false) {
                     LazyHStack {
                         ForEach(0..<6) { _ in
                             CalendarMainView()
                         }
                     }
                 }.frame( height: 90, alignment: .center)
                 .padding()
             
                 ScrollView() {
                     LazyVGrid(columns: gridItem) {
                         ForEach(0..<6) { _ in
                             IndexView()
                         }
                     }
                 }.padding()
         }
       
        
        
     }
 }


struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}

