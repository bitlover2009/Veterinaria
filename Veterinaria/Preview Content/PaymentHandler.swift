//
//  PaymentHandler.swift
//  Veterinaria
//
//  Created by David Grau Beltrán  on 25/01/24.
//

import Foundation
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void //return void

class PaymentHandler: NSObject {
    var paymentController: PKPaymentAuthorizationController? //will be obtional
    var paymentSummaryItems = [PKPaymentSummaryItem]() //array PKPaymentSummaryItem we will add parentheses at the end, so that means taht we're initializing an empty array of PKPayment summary Item type
    var paymentStatus = PKPaymentAuthorizationStatus.failure //failure because by defult, we don't want the payment status to be a success
    var completionHandler: PaymentCompletionHandler?
    
    //we need to specify the supported networks, in other words, the type of cards our app accepts
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        //inside of this array, we will simply add two networks
        .visa,
        .masterCard
    ]
    
    func shippingMethodCalculator() -> [PKShippingMethod] {
        let today = Date()
        let calendar = Calendar.current
        
        let shippingStart = calendar.date(byAdding: .day, value: 5, to: today) // we're adding five days from the date of today, and this means the first day that the user might receieve the items that they ordered in our application
        let shippingEnd = calendar.date(byAdding: .day, value: 10, to: today)
        //the start and end variables are both optional so we need to unwrap this optionals with if
        
        if let shippingEnd = shippingEnd, let shippingStart = shippingStart {
            let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
            let endComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
            
            let shippingDelivery = PKShippingMethod(label: "Delivery", amount: NSDecimalNumber(string: "0.00")) //"0.00 free shipping
            shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
            shippingDelivery.detail = "Sweaters sent to your address"
            
            return [shippingDelivery]
        }
        return [] // with this our error return '[PKShippingMethod]' was gone
    }//Missing return in instance method expected to return '[PKShippingMethod]' this error is because shipping start and end are not unwrapped, we most also return something so outside of the if statement, but we'll return on empty array if the
    //for shipping calculator
    
    func startPayment(products:[Product], total: Int, completion: @escaping PaymentCompletionHandler){ // so the completion habnlder is what we would want to perform once the function has finished running
        completionHandler = completion//we'll set the completionHandler variable that we created at the top to the completion that we passed to this function
        // Next we'll need to reset our payments, because we want to reset the cart before adding new items to this cart
        paymentSummaryItems = []
        
        //so let's iterate over the products array
        //Products item
        products.forEach{ product in
            let item = PKPaymentSummaryItem(label: product.name, amount: NSDecimalNumber(string: "\(product.price).00"), type: .final)
            //NSDecimalNumber it's the same ads the one that we added in pur shipping delivery
            paymentSummaryItems.append(item) //we append this item to our array, meaning that at the top, our paymentSummaryItems will containt all the products from our cart manager
            
        }
        //we need to created another PKPayment Item
        //Cost total Payment
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "\(total).00"), type: .final)
        paymentSummaryItems.append(total)
        //we'll need to create a payment request
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = "merchant.bitlover2009-gmail.com.Veterinaria-"
        paymentRequest.merchantCapabilities = .threeDSecure
        paymentRequest.countryCode = "MX"
        paymentRequest.currencyCode = "MXN"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        paymentRequest.shippingType = .delivery
        paymentRequest.shippingMethods = shippingMethodCalculator()
        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
        
        //Now after creating the payment request, we need to display it on a sheet presentation. For that we'll be using some UIKit code
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
       
        paymentController?.delegate = self  //Then a payment controller requiers a delegate, so we'll do payment controller and since this is optional, we need to add a question mark dot, so that means that we're setting a delegate to the payment controller, error --> Cannot assign value of type 'PaymentHandler' to type '(any PKPaymentAuthorizationControllerDelegate)?'
        //APPLE PAY SHEET PRESENTATION
        paymentController?.present(completion: { (present: Bool) in
            if present{
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
            }
            
        })
    }
}

//fix Cannot assign value of type 'PaymentHandler' to type '(any PKPaymentAuthorizationControllerDelegate)?'
// Add missing conformance to 'PKPaymentAuthorizationControllerDelegate' to class 'PaymentHandler'


extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let errors = [Error]()
        let status = PKPaymentAuthorizationStatus.success
        
        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        //because the sheet presentation that we will call will not be dismissed by itself once the payment has been succeeeded
        controller.dismiss{//we call controller.dismiss and inside of this closure
            DispatchQueue.main.async {
               // if self.paymentStatus == .success{ //ERROR
                  if let completionHandler = self.completionHandler{ //FIX
                    completionHandler(true)//if paymentStatus is success we call completionHandler the boolean true, meaning that the payment has been a succes
                // ERROR --> Value of optional type 'PaymentCompletionHandler?' (aka 'Optional<(Bool) -> ()>') must be unwrapped to a value of type 'PaymentCompletionHandler' (aka '(Bool) -> ()')
                    
                } else {//otherwise, we want to call our completion handler and we will return false because we ran into an error
                    if let completionHandler = self.completionHandler {
                        completionHandler(false)
                    }
                }
            }
        }
    }
}


