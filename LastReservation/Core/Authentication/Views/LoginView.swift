//
//  LoginView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 17.12.2022.
//

import SwiftUI

struct LoginView: View {
    
    @State var maxCircleHeight:CGFloat = 0
    @State var password:String = ""
    @State var mail: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        VStack{
            
            GeometryReader{proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                DispatchQueue.main.async {
                    if maxCircleHeight == 0{
                        maxCircleHeight = height
                    }
                }
                return AnyView(
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .offset(x: getReact().width/2, y: -height/1.3)
                        
                        Circle()
                            .fill(Color.black)
                            .offset(x: -getReact().width/2, y: -height/1.5)
                            .rotationEffect(.init(degrees: -5))
                        
                        Circle()
                            .fill(Color.cyan)
                            .offset(y: -height/1.3)
                    }
                )
            }
            .frame(maxHeight:getReact().width)
            
            VStack {
                Text("Giriş Yap")
                    .font(.title)
                    .fontWeight(.bold)
                    .kerning(1.1)
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .padding(.bottom,20)
                
                VStack(spacing: 40){
                    CustomInputFields(image: "envelope", placeholderText: "Email", text: $mail)
                    CustomInputFields(image: "lock", placeholderText: "Şifre", text: $password)
                }
                //forgot password
                
                Button {
                    
                } label: {
                    Text("Şifremi Unuttum")
                        .fontWeight(.bold)
                    
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
                .padding(.top,10)
                
                
                //Next Button
                
                Button {
                    viewModel.login(email: mail, password: password)
                } label: {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 24,weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(Circle())
                    //Shadow
                        .shadow(color:Color.blue.opacity(0.6), radius: 5,x:0,y:0)
                }
                
                .frame(maxWidth:.infinity,alignment: .leading)
                .padding(.top,10)
                
                
            }
            
            .padding()
            //remove unwanted space
            .padding(.top,-maxCircleHeight / 1.7)
            .frame(maxHeight:.infinity,alignment: .top)
        }
        .overlay (
            VStack {
                NavigationLink {
                    RegistrationView()
                        .navigationBarHidden(true)
                } label: {
                    Text("Hesabın yok mu ?")
                        .foregroundColor(.gray)
                    Text("Kayıt Ol")
                        .bold()
                        .foregroundColor(.blue)
                }

                
            }
            ,alignment: .bottom
        )
        
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View {
    func getReact()->CGRect{
        return UIScreen.main.bounds
    }
}
