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
    @Published var didAuthenticateUser = false
    @Published var currentUser:User?
    private var tempUserSession:FirebaseAuth.User?
    
    let auth = Auth.auth()
    private let service = UserService()
    
    init(){
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    //MARK: - Login
        func login(email email: String, password: String) {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("DEBUG: Failed to register with error \(error.localizedDescription)")
                    return
                }
                
                guard let user = result?.user else { return }
                self.userSession = user
                self.fetchUser()
                print("DEBUG: Did Log user in.. \(String(describing: self.userSession?.email))")
            }
        }
    
    func register(email:String,password:String,number:String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let user  = result?.user else {return}
            self.tempUserSession = user
            
            print("Registered user succesfuly")
            let data = ["email":email,"number":number,"uid":user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in
                    print("did upload user data")
                    self.didAuthenticateUser = true
                }
        }
    }
    
    func signOut() {
        userSession = nil
        try? auth.signOut()
    }
    
    func fetchUser() {
           guard let uid = self.userSession?.uid else { return }
           
           service.fetchUser(withUid: uid) { user in
               self.currentUser = user
           }
       }
}
