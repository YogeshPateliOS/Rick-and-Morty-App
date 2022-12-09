//
//  CharacterCell.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import UIKit

class CharacterCell: UICollectionViewCell {

    @IBOutlet weak var episodeCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    var character: Character?{
        didSet{
            thumbnailImage.loadImageAsync(with: character?.image)
            nameLabel.text = character?.name
            episodeCountLabel.text = "Episodes: \(character?.episode.count ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
    }

}

extension CharacterCell{
    static var idetifier: String{
        "\(Self.self)"
    }
}
