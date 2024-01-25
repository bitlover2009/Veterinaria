//
//  PaymentButton.swift
//  Veterinaria
//
//  Created by David Grau Beltrán  on 24/01/24.
//

import SwiftUI
import PassKit// this framework will allow us to use Apple Pay in our application

struct PaymentButton: View {
    //This payment button will accept one argument and it will be an action
    var action: () -> Void
    
    var body: some View {
        Representable(action: action)
            .frame(minWidth: 100, maxWidth: 400)
            .frame(height: 45)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    PaymentButton(action: {})
}

//before to create the body we need to create an extension

extension PaymentButton {
    //this extension will allow us to use the already built in apple pay button, cause' we cannot build it from scratch and just copy the desing
    struct Representable: UIViewRepresentable {
        var action: () -> Void
        
        func makeCoordinator() -> Coordinator {
            Coordinator(action: action)
        }
        
        func makeUIView(context: Context) -> some UIView {
            context.coordinator.button
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {
            context.coordinator.action = action
            
        //so we need to create a coordinator inside of this extension to silence all the error that we see now
        }
    }
    
    class Coordinator: NSObject{
        var action: () -> Void
        var button = PKPaymentButton(paymentButtonType: .checkout, paymentButtonStyle: .automatic)
        
        init(action: @escaping () -> Void){
            self.action = action
            super.init()
            
            button.addTarget(self, action: #selector(callback(_:)), for: .touchUpInside)
        }
        
        @objc
        func callback(_ sender: Any){
            action()
        } //all of our errors are silenced, becuase we added all the code required to make our PaymentButton
        //This code was taken froom the Fruta sample app from Apple
    }
}
