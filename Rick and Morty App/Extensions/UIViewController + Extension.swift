//
//  UIViewController + Extension.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 09/12/22.
//

import UIKit

extension UIViewController{
    
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self
    {
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T
    {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "\(Self.self)") as! T
        return controller
    }
}
