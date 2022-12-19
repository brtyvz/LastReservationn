//
//  ContentView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 17.12.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel:AuthViewModel
    var body: some View {
        Group {
            // user not logged in
            if viewModel.userSession == nil {
                LoginView()
            }
         //user logged in
            else {
                MainView
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
       
    }
}


extension ContentView {
   
    private var MainView: some View {
        Text("Logged in")
    }
    
    
}
