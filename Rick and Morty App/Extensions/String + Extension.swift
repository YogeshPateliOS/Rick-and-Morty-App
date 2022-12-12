//
//  String + Extension.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 11/12/22.
//

import Foundation

extension String{

    func localizableString() -> String{
        let code = UserDefaults.standard.getLanguageCode()
        if let path = Bundle.main.path(forResource: code, ofType: "lproj"),
           let bundle = Bundle(path: path){
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }else{
            return ""
        }
    }

}
