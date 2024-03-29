//
//  SideMenuView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 22.12.2022.
//

import SwiftUI


struct SideMenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var date:String = "1 ekim"
    @State var hour:String = "10.00"
    @State var capacity:String = "50"
    var body: some View {
//
        VStack {
            if let user = authViewModel.currentUser {
                VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading) {
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.email)
                            .font(.headline)
                        
                    }
                    
                }
                .padding(.leading)
                
                ForEach(SideMenuViewModel.allCases, id:\.rawValue) { viewModel in
                    if viewModel == .main {
                        NavigationLink {
                           NewMainMenu()
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    }
                    
                    else if viewModel == .calendar{
                        NavigationLink {
                           CalendarView()
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    }
                    
                    else if viewModel == .reservations{
                        NavigationLink {
                            ReservationsView()
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    }
                    
                    else if viewModel == .logout {
                        Button {
                            print("logout")
                            authViewModel.signOut()
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    } else {
                        SideMenuOptionRowView(viewModel: viewModel)
                    }
                }
                Spacer()
                }
            } else {
                EmptyView()
            }
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
