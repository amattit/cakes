//
//  AppState.swift
//  Cakes
//
//  Created by Mikhail Seregin on 04.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import Foundation

class AppState: NSObject {

  static let sharedInstance = AppState()

  var signedIn = false
  var displayName: String?
  var photoURL: URL?
}
