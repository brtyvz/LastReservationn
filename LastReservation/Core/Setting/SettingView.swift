//
//  SettingView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 21.12.2022.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var viewModel:AuthViewModel
    var body: some View {
        NavigationView {
            Form {
                Button {
                    viewModel.signOut()
                } label: {
                    HStack{
                        Text("Çıkış Yap")
                        Image(systemName:"power")
                    }
                  
                }
                if let user = viewModel.currentUser {
                    Text(user.email)
                }
            }
            .navigationTitle(Text("Ayarlar"))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
