//
//  GameCell.swift
//  GamOn
//
//  Created by Shahla Almasri Hafez on 2/19/18.
//

import UIKit

class GameCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    
    ///
    ///
    ///
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.backgroundColor = .specialPurple
    }
}
