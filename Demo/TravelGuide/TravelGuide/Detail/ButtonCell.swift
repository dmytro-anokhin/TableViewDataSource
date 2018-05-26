//
//  ButtonCell.swift
//  TravelGuide
//
//  Created by Dmytro Anokhin on 26/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit


class ButtonCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!

    override func prepareForReuse() {
        super.prepareForReuse()
        button.removeTarget(nil, action: nil, for: .allEvents)
    }
}
