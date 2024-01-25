//
//  CartButton.swift
//  Veterinaria
//
//  Created by David Grau Beltrán  on 21/01/24.
// Numb of products that the user has in therir cart
//Remember to fix the preview by passing a numb of products integer to the CartButton instance here as well (error: "Missing argument for parameter 'numberOfProducts' in call")

import SwiftUI

struct CartButton: View {
    var numberOfProducts: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            Image(systemName: "cart")
                .padding(.top, 5)
            
            if numberOfProducts > 0 {
                Text("\(numberOfProducts)")
                    .font(.caption2).bold()
                    .foregroundColor(.white)
                    .frame(width: 15, height: 15)
                    .background(Color(hue: 1.0, saturation: 0.89, brightness: 0.835))
                    .cornerRadius(50)
            }
            
        }
    }
}

#Preview {
    CartButton(numberOfProducts: 1)
}
