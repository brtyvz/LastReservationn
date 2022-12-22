//
//  AuthViewModel.swift
//  LastReservation
//
//  Created by Berat Yavuz on 17.12.2022.
//

import Foundation
import SwiftUI
import Firebase

class AuthViewModel:ObservableObject {
    @Published var userSession:FirebaseAuth.User?
    let auth = Auth.auth()
    init(){
        self.userSession = Auth.auth().currentUser
    }
    
    func login(email:String,password:String){
        auth.signIn(withEmail: email, password: password) { result, error in
            if let  error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let user  = result?.user else {return}
            self.userSession = user
            
            print("Login succesfuly")
        }
    }
    
    func register(email:String,password:String,number:String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let user  = result?.user else {return}
            self.userSession = user
            
            print("Registered user succesfuly")
            let data = ["email":email,"number":number,"uid":user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in
                    print("did upload user data")
                }
        }
    }
    
    func signOut() {
        userSession = nil
        try? auth.signOut()
    }
}
