//
//  CustomAlertView.swift
//  LastReservation
//
//  Created by Berat Yavuz on 28.02.2023.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var show :Bool
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical:.top)){
            VStack(spacing:25){
                Text("Rezervasyonu Onaylıyor Musunuz?")
                    .font(.title)
                    .bold()
                    .foregroundColor(.purple)
                Text("2 Ekim / Saat: 09.00")
                    .bold()
                
                
                HStack {
                    
                    Button {
                        
                    } label: {
                        Text("Onaylıyorum")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical,10)
                            .padding(.horizontal,25)
                            .background(Color.purple)
                            .clipShape(Capsule())
                    }
                    
                    Button {
                        
                    } label: {
                        Text("Vazgeç")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical,10)
                            .padding(.horizontal,25)
                            .background(Color.purple)
                            .clipShape(Capsule())
                    }
                    
                }
              

            }
            .padding(.vertical,25)
            .padding(.horizontal,30)
            .background(BlurView())
            .cornerRadius(25)
            
            Button {
                withAnimation{
                    show.toggle()
                    
                }
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 28,weight: .bold))
                    .foregroundColor(.black)
            }
            
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.01)
        )
    }
}

struct BlurView:UIViewRepresentable {
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
      
        return view
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(show: .constant(true))
    }
}
