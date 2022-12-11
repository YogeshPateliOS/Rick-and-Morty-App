//
//  UITableViewCell + Extension.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 11/12/22.
//

import UIKit

extension UITableViewCell {

    func episodeListContentConfiguration() -> UIListContentConfiguration {
        self.selectionStyle = .none
        var content = self.defaultContentConfiguration()
        content.textProperties.font = .textFont
        content.secondaryTextProperties.font = .secondTextFont
        content.secondaryTextProperties.color = .secondaryLabel
        content.textToSecondaryTextVerticalPadding = 2
        return content
    }

}

extension UIFont {

    static var textFont: UIFont {
        UIFont.systemFont(ofSize: 16, weight: .medium)
    }

    static var secondTextFont: UIFont{
        UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}
