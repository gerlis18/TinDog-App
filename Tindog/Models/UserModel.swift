//
//  UserModel.swift
//  Tindog
//
//  Created by SimpleAp on 30/05/18.
//  Copyright © 2018 SimpleAp. All rights reserved.
//

import Foundation
import Firebase

struct UserModel {
    let uid: String
    let email: String
    let displayName: String
    let provider: String
    let profileImage: String
    let userIsOnMatch: Bool
    
    init?(snapshot: DataSnapshot) {
        let uid = snapshot.key
        guard let dic = snapshot.value as? [String: Any],
            let email = dic["email"] as? String,
            let displayName = dic["displayName"] as? String,
            let provider = dic["provider"] as? String,
            let profileImage = dic["profileImage"] as? String,
            let userIsOnMatch = dic["userIsOnMatch"] as? Bool else {
                return nil
            }
        
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.profileImage = profileImage
        self.provider = provider
        self.userIsOnMatch = userIsOnMatch
    }
}
