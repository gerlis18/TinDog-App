//
//  DataBaseService.swift
//  Tindog
//
//  Created by SimpleAp on 20/05/18.
//  Copyright © 2018 SimpleAp. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE_ROOT = Database.database().reference()

class DataBaseService {
    static let instance = DataBaseService()
    
    private let _Base_ref = DB_BASE_ROOT
    private let _User_ref = DB_BASE_ROOT.child("users")
    private let _Match_ref = DB_BASE_ROOT.child("match")
    
    var Base_ref: DatabaseReference {
        return _Base_ref
    }
    
    var User_ref: DatabaseReference {
        return _User_ref
    }
    
    var Match_ref: DatabaseReference {
        return _Match_ref
    }
    
    func observerProfileImage(handler: @escaping(_ userProfileDict: UserModel?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            DataBaseService.instance.User_ref.child(currentUser.uid).observe(.value) { (snapshot) in
                if let userDict = UserModel(snapshot: snapshot) {
                    handler(userDict)
                }
            }
        }
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
        User_ref.child(uid).updateChildValues(userData)
    }
    
    func createFirebaseDBMatch(uid: String, uid2: String) {
        Match_ref.child(uid).updateChildValues(["uid2": uid2, "matchIsAccepted": false])
    }
    
}
