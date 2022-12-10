//
//  UIButton + Extension.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 09/12/22.
//

import UIKit

extension UIButton {

    func configurButton(
        title: String,
        isShowIndicator: Bool = true
        ) {
            var config = UIButton.Configuration.filled()
            config.title = title
            config.showsActivityIndicator = isShowIndicator
            self.isHidden = false
            self.configuration = config
        }

}
