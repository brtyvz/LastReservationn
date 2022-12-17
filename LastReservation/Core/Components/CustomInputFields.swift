//
//  CustomInputFields.swift
//  LastReservation
//
//  Created by Berat Yavuz on 17.12.2022.
//

import SwiftUI

struct CustomInputFields: View {
    let image:String
    let placeholderText:String
    @Binding var text: String
    var body: some View {
        VStack {
            HStack {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                
                TextField(placeholderText, text: $text)
            }
           Divider()
                .background(Color(.darkGray))
        }
    }
}

struct CustomInputFields_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputFields(image: "envelope", placeholderText: "mail", text: .constant(""))
    }
}
