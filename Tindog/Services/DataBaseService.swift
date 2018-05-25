//
//  DataBaseService.swift
//  Tindog
//
//  Created by SimpleAp on 20/05/18.
//  Copyright © 2018 SimpleAp. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE_ROOT = Firebase.Database().reference()

class DataBaseService {
    static let instance = DataBaseService()
    
    private let _Base_ref = DB_BASE_ROOT
    private let _User_ref = DB_BASE_ROOT.child("users")
    
    var Base_ref: DatabaseReference {
        return _Base_ref
    }
    
    var User_ref: DatabaseReference {
        return _User_ref
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
        User_ref.child(uid).updateChildValues(userData)
    }
    
}
