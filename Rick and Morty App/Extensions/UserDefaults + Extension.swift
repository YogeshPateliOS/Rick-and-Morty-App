//
//  UserDefaults + Extension.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 11/12/22.
//

import Foundation

extension UserDefaults{

    func setLanguageCode(code: String){
        UserDefaults.standard.set(code, forKey: Constants.languageCodeKey)
    }

    func getLanguageCode() -> String{
        return UserDefaults.standard.string(forKey: Constants.languageCodeKey) ?? LanguageCode.english.rawValue
    }
    
}
