//
//  CartManager.swift
//  Veterinaria
//
//  Created by David Grau Beltrán  on 21/01/24.
//

// we need a file in which we handle everything realted to our cart So a file in which we will add a function to add something to our cart, as well as remove some thing from our cart and update the total price of our cart

import Foundation


class CartManager: ObservableObject { //so that the changes in this class will be updated instantly in the UI
    @Published private(set) var products: [Product] = []//remember to add the private set keyword, so that this variable can only be set within this class // var products / array [Product]-> Product is the Product model... and let's set it to an empty array initially
    @Published private(set) var total: Int = 0
    //for those published variables we need 2 variables
    let paymentHandler = PaymentHandler()
    @Published /*private(set)*/ var paymentSuccess = false //this paymentSuccess variable will let us know if the payment was a success or not
    
    func addToCart(product: Product) { //asset the product which will be of type Product
        products.append(product) //inside this func we call a prodcuts array and append the product that we pass to this function
        //also we need to update the total price of our cart, so
        total += product.price //we're adding the price of the product that we passed to his function to the toal variable in this class
    }
    //2do function
    func removeFromCart(product: Product){
        //we'll reassing the products array will now be products.filter and we want to filter out the products where the ID is not equals to the product that we pass ed to this function, meaning that we only want the products where th ID isn´t the ID of this product that we passed
        products = products.filter{ $0.id != product.id}// si product.id es diferente del id del Product se removera el precio(quiere decir que lo eliminaron del carrito)
        total -= product.price
    }
    
    func pay() {
        //Remember that it requieres a products array, a total and a completion handler
        paymentHandler.startPayment(products: products, total: total) { success in//in the completion handler, we'll get a success, which will be a boolean variable
            self.paymentSuccess = success //success boolean value that we get in return
            self.products = [] //then we'll also need to reset the products array to an empty
            self.total = 0 // the total will be $0
            //now let's go to our CartView
        }
    }
    
}
