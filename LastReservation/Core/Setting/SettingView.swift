//
//  SettingView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 21.12.2022.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var viewModel:AuthViewModel
    @State private var currencyIndex = AppUserDefaults.currencyIndex
    @EnvironmentObject var settings: SettingsViewModel
    @StateObject var settingsViewModel = SettingsViewModel()
    @State private var themeType = AppUserDefaults.preferredTheme
    
    let colors : [UIColor] = [
           .systemRed,
           .systemBlue,
           .systemGray,
           .systemCyan,
           .systemGreen,
           .systemBrown,
           .systemIndigo,
           .systemOrange,
           .systemPurple,
           .systemPink
       ]
    
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
            
            
            Section(header: Text("Temalar")) {
                               HStack {
                                   Text("Uygulama Teması")
                                   Spacer()
                                   CustomColorPicker(colors: colors) { color in
                                       
                                       settings.changeAppColor(color: color)
                                       
                                   }
                               }
                               HStack {
                                   Text("Görünüm")
                                   Spacer()
                                   Picker("",selection: $themeType.onChange(themeChange)) {
                                       Text("Varsayılan").tag(0)
                                       Text("Açık").tag(1)
                                       Text("Koyu").tag(2)
                                   }.fixedSize()
                               }
                           }.modifier(SectionHeaderStyle())
            
        }
            
            .navigationTitle(Text("Ayarlar"))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    func themeChange (_ tag: Int) {
           settings.changeApptheme(theme: tag)
       }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct SectionHeaderStyle: ViewModifier {
    func body(content:Content) -> some View {
        Group {
            if #available(iOS 14, *) {
                AnyView(content.textCase(.none))
                
            } else {
                content
            }
        }
    }
}


extension Binding {
    func didSet(execute:@escaping (Value)->Void) -> Binding {
        return Binding(
            get: {self.wrappedValue },
            set:{
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
    
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding <Value> {
        return Binding(
            get: {self.wrappedValue },
            set:{ selection in
                self.wrappedValue = selection
                handler(selection)
            })
    }
}
