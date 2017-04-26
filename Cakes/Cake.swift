//
//  Cake.swift
//  Cakes
//
//  Created by Михаил Серёгин on 08.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import Foundation
import UIKit

class Cake {
    var name: String?
    var prise: String?
    var imagePath:[String?]
    var image:UIImage?
    //var miniImagePath: String?
    var category: String?
    
    init (name: String?, prise: String?, imagePath: [String], category: String?/*, miniImagePath: String?*/) {
        self.name = name
        self.prise = prise
        self.imagePath = imagePath
        self.category = category
        //self.miniImagePath = miniImagePath
    }
}
