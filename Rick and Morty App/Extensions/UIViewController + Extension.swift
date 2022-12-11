//
//  UIViewController + Extension.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 09/12/22.
//

import UIKit

// MARK: - Generic - Get ViewController object using Storyboard
extension UIViewController {

    static func instantiateFromStoryboard(_ name: String = "Main") -> Self? {
        return instantiateFromStoryboardHelper(name)
    }

    private static func instantiateFromStoryboardHelper<T>(_ name: String) -> T? {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "\(Self.self)") as? T
        return controller
    }

}

// MARK: - Reusable AlertController
extension UIViewController {

    func openAlert(title: String? = nil,
                   message: String? = nil,
                   actions: [UIAlertAction] = [.dismissAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertController.addAction($0) }
        self.present(alertController, animated: true)
    }

    func configNavigation(title: String, largeTitle: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = largeTitle
        navigationItem.title = title
    }

}
// Common action
extension UIAlertAction {

    static func okAction(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: "Okay", style: .default, handler: handler)
    }

    static var dismissAction: UIAlertAction {
        UIAlertAction(title: "Dissmis", style: .default)
    }

    static var cancelAction: UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel)
    }

    static func tryAgainAction(handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction {
        UIAlertAction(title: "Try Again", style: .default, handler: handler)
    }

}
