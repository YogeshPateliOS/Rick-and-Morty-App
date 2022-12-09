//
//  CharacterCell.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import UIKit

class CharacterCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    var character: Result?{
        didSet{
            thumbnailImage.loadImageAsync(with: character?.image)
            nameLabel.text = character?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
