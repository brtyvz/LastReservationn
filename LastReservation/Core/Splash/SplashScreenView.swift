//
//  SplashScreenView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 6.05.2023.
//

import SwiftUI


struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        let welcomeText = UserDefaults.standard.string(forKey: UserDefaultsKeys.welcomeText.rawValue) ?? "Welcome!"
        
        if isActive {
            ContentView()
        }
        else {
            VStack {
               Image(systemName: "hand.tap")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.bottom,50)
                    .foregroundColor(Color("Purple"))
                
                Text(welcomeText)
                    .font(.system(size: 40))
                    .bold()
                    .foregroundColor(.black.opacity(0.80))
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear{
                        withAnimation(.easeIn(duration: 1.2)){
                            self.size = 1.2
                            self.opacity = 1.0
                        }
                    }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
    
    init() {
        if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFirstLaunch.rawValue) {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isFirstLaunch.rawValue)
            UserDefaults.standard.set("Welcome!", forKey: UserDefaultsKeys.welcomeText.rawValue)
        } else {
            UserDefaults.standard.set("Hello!", forKey: UserDefaultsKeys.welcomeText.rawValue)
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

enum UserDefaultsKeys: String {
    case isFirstLaunch
    case welcomeText
}
