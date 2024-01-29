//
//  ProductCard.swift
//  Veterinaria
//
//  Created by David Grau Beltrán  on 20/01/24.
//

import SwiftUI
//our product card will show us the image card or our products, and show this when we'll be iterating over all the product toys from our productList variable
struct ProductCard: View {
    @EnvironmentObject var cartManager: CartManager
    var product: Product
    
    
    //variable / and type
    var body: some View {
        ZStack(alignment: .topTrailing) { //parent ZStack(embed in ZStack
            ZStack(alignment: .bottom){//child ZStack
                Image(product.image)
                    .resizable()
                    .cornerRadius(20)
                    .frame(width: 180)
                    .scaledToFit()
                VStack(alignment: .leading){
                    Text(product.name)
                        .bold()
                    Text("\(product.price)$")
                        .font(.caption)
                }
                .padding()
                .frame(width: 180, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                
            }
            .frame(width: 180, height: 250)
            .shadow(radius: 3)
            
            Button {
                //print("Added to cart!")
                cartManager.addToCart(product: product)
                
            } label: { //we create the "+" simbol for add to cart
                Image(systemName: "plus")
                    .padding(10)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(50)
                    .padding()//Relleno: Añade una cantidad de relleno igual a los bordes específicos de esta vista.
            }
            
        }
    }
}
// error: Missing argument for parameter 'prodcut' in call remeber to fix the preview by passing a product to it as well
#Preview {
    ProductCard(product: productList[0])
    //remmber to add the enviromentObject modifier to our preview and to initialize an instance of CartManager for the preview to work again 
        .environmentObject(CartManager())
}
