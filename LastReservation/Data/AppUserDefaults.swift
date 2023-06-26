//
//  AppUserDefaults.swift
//  LastReservation
//
//  Created by Berat Yavuz on 21.06.2023.
//

import Foundation

struct AppUserDefaults {
    @UserDefault("currency", defaultValue: "$")
    static var currency: String
    
    @UserDefault("currencyIndex", defaultValue: 0)
    static var currencyIndex: Int
    
    @UserDefault("appThemeColor", defaultValue: "")
    static var appThemeColor: String
    
    @UserDefault("preferredTheme", defaultValue: 0)
    static var preferredTheme: Int
}
