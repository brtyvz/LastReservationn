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
                    Text("Çıkış Yap")
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
