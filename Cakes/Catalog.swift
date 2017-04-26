//
//  Catalog.swift
//  Cakes
//
//  Created by Михаил Серёгин on 09.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import Foundation
import UIKit

class Catalog {
    var name: String!
    var desc: String!
    var image: String!
    var count = 0
    
    init(name: String, desc: String, image: String) {
        self.name = name
        self.desc = desc
        self.image = image
    }
}
