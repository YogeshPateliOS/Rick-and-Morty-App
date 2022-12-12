//
//  CharacterCell.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import UIKit

class CharacterCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var episodeCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!

    // MARK: - Variables
    var character: Character? {
        didSet {
            thumbnailImage.loadImageAsync(with: character?.image)
            nameLabel.text = character?.name
            episodeCountLabel.text = "\(Constants.Localizable.episodes.capitalized): \(character?.episode.count ?? 0)"
        }
    }

    // MARK: - UI
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
    }

}

extension CharacterCell {
    static var identifier: String {
        "\(Self.self)"
    }
}
