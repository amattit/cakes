//
//  ChatTableViewCell.swift
//  Cakes
//
//  Created by Михаил Серёгин on 11.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var meAuthor: UILabel!
    @IBOutlet weak var myMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
