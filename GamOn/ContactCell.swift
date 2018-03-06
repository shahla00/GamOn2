//
//  ContactCell.swift
//  GamOn
//
//  Created by Shahla Almasri Hafez on 2/21/18.
//  Copyright © 2018 MrRobot. All rights reserved.
//

import UIKit

protocol ContactCellDelegate {
    func didTapFavoriteButton(on identifier: String)
}

class ContactCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate: ContactCellDelegate? = nil
    var contactIdentifier = "" {
        didSet {
            let index = AppDelegate.indexInFavorite(identifier: contactIdentifier)
            favoriteButton.setImage(
                index == -1 ? UIImage(named: "starUnfilled") : UIImage(named: "starFilled"),
                for: .normal)
        }
    }
    
    ///
    ///
    ///
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        label.textColor = .specialPurple
    }
    
    ///
    ///
    ///
    @IBAction func tappedFavoriate() {
        delegate?.didTapFavoriteButton(on: contactIdentifier)
    }
    
    ///
    ///
    ///
    override func prepareForReuse() {
        label.text = ""
        contactIdentifier = ""
    }
}
