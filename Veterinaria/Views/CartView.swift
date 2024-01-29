//
//  CartView.swift
//  Veterinaria
//
//  Created by David Grau Beltrán  on 21/01/24.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        ScrollView {
            if cartManager.paymentSuccess {
                //thanks for your purchase
                Text("Thanks for your purchase! You'll also recieve an email confirmation shortly.")
                    .padding()
            } else {//otherwise we'll display the current if else statement checking for the number of products in the user's cart
                if cartManager.products.count > 0 {
                    //if the prodcuts are higher than 0, we'll want to iterate over the products array and display a product row for each item that we have in our cart, Otherwise, it means that our cart is empty
                    ForEach(cartManager.products, id: \.id){//in the statement
                        product in
                        ProductRow(product: product)
                    }
                    
                    HStack{
                        Text("Your cart total is")
                        Spacer()
                        Text("$\(cartManager.total).00")
                            .bold()
                    }
                    .padding()
                    
                    PaymentButton(action: cartManager.pay) //it requires an action, so for the moment we´ll simply pass curly brackets (action: {}) // now we replace {} to cartManager pay function
                        .padding()
                    
                } else {
                    Text("Your cart is empty")
                }
            }
        }
        .navigationTitle(Text("My Cart"))
        .padding(.top)
        .onDisappear { //so we'll only reset the paymentSuccess if it is true 
            if cartManager.paymentSuccess {
                cartManager.paymentSuccess = false
            }
        }
    }
}

#Preview {
    CartView()
        .environmentObject(CartManager())
    //if we dont put pahrenthesis on CartManager error is: Type 'CartManager.Type' cannot conform to 'ObservableObject', so we need to inicialize an instance CartManager
}
