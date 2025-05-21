//
//  SecretsManager.swift
//  BasicNoteApp
//
//  Created by Max on 13.03.2025.
//

import Foundation
// to attain api key, use secrets manager

class SecretsManager {
    static let shared = SecretsManager() // singleton purposes
    
    private init() {} // prevents initialization from outside

    func getAPIKey(forKey key: String) -> String? {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
            print("error: couldn't find 'Secrets.plist'")
            return nil
        }

        guard let plistData = FileManager.default.contents(atPath: path) else {
            print("error: couldn't read 'Secrets.plist'")
            return nil
        }

        do {
            let plist = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil)
            if let dictionary = plist as? [String: Any], let value = dictionary[key] as? String {
                return value
            } else {
                print("error: couldn't find 'key' in 'Secrets.plist'")
                return nil
            }
        } catch {
            print("error occured while reading 'Secrets.plist'")
            return nil
        }
    }
}

