//
//  Message.swift
//  Cakes
//
//  Created by Михаил Серёгин on 11.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import Foundation
import UIKit

class Message {
    var message: String!
    var author: String!
    var imagePath: String?
    var image: UIImage?
    init(message: String, author: String?, image: String?) {
        self.author = author
        self.imagePath = image
        self.message = message
    }
}
