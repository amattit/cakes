//
//  Constants.swift
//  Cakes
//
//  Created by Mikhail Seregin on 04.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

struct Constants {
  struct NotificationKeys {
    static let SignedIn = "onSignInCompleted"
  }
  
  struct Segues {
    static let SignInToCl = "SignInToAddPh"
    static let FpToSignIn = "FPToSignIn"
    static let CakeListToCategory = "FromListToCategory"
  }
    
    struct DBStruct {
        static let rootCakes = "cakes"
        static let rootCatalog = "catalog"
        static let chat = "chat"
        
        struct Category {
            static let cake = "cake"
            static let pirozhnoe = "pirozhnoe"
            static let capCake = "capcake"
            static let cakePops = "cakePops"
            static let macarons = "macarons"
            static let beze = "beze"
            static let zefir = "zefir"
        }
        
        struct Message {
            static let message = "message"
            static let author = "author"
            static let image = "image"
        }
    }

}
