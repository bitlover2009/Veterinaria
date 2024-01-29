//
//  ContentView.swift
//  Veterinaria
//
//  Created by David Grau Beltrán  on 20/01/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var cartManager = CartManager()//with the parentheses at the end, so that we initialize an instance of CartManager
    //Then we'll need to add the EnviromentObject modifier in two different views, at the top --> go to ProductCart
    
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)] // spacing Adjusting the space between views
    //AQUI ME QUEDE
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(productList, id: \.id){ product in
                        //for each product in this list, we'll display a ProductCard
                        ProductCard(product: product)//we didnt wrap our for each iin a parent group to fix that we'll be using the LazyVGrid: requieres 2 arguments array and spacing as well
                            .environmentObject(cartManager)
                        
                    }
                }
                .padding()
            }
            .navigationTitle(Text("Veterinary Shop"))
            .toolbar {
                NavigationLink{//Link to ContentView to CartView
                    CartView() //1 destination
                        .environmentObject(cartManager)
    
                } label: {//Navigation links has two closures 1 destination and 2 label
                    CartButton(numberOfProducts: cartManager.products.count)
                    //for the dest we want to redirect them to our CartView
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
