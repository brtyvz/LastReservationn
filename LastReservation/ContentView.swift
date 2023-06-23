//
//  ContentView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 17.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showMenu = true
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            // user not logged in
            if viewModel.userSession == nil {
                LoginView()
            }
            //user logged in
            else {
                mainInterfaceView
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
    
    var mainInterfaceView: some View {
        ZStack(alignment: .topLeading) {
            MainTabView()
                .navigationBarHidden(showMenu)
            
            if showMenu {
                ZStack {
                    Color(.black)
                        .opacity(0.25)
                }.onTapGesture {
                    withAnimation(.easeInOut) {
                        showMenu = false
                    }
                }
                .ignoresSafeArea()
            }
            
            SideMenuView()
                .frame(width: 300)
                .offset(x: showMenu ? 0 : -300, y: 0)
                .background(showMenu ? Color.white : Color.clear)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let user = viewModel.currentUser {
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showMenu.toggle()
                        }
                    } label: {
                        Image("logo").resizable().frame(width: 40, height: 40, alignment: .center)
                            .cornerRadius(25)
                    }
                }
            }
        }
        .onAppear {
            showMenu = false
        }
    }
    
}
