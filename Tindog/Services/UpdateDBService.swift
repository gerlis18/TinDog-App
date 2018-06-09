//
//  UpdateDBService.swift
//  Tindog
//
//  Created by SimpleAp on 9/06/18.
//  Copyright © 2018 SimpleAp. All rights reserved.
//

import Foundation
import Firebase

class UpdateDBService {
    static let instance = UpdateDBService()
    
    func observeMatch(handler: @escaping(_ matchDict: MatchModel?) -> Void) {
        DataBaseService.instance.Match_ref.observe(.value) { (snapshot) in
            if let matchSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                if matchSnapshot.count > 0 {
                    for match in matchSnapshot {
                        if match.hasChild("uid2") && match.hasChild("matchIsAccepted") {
                            if let matchDict = MatchModel(snapshot: match) {
                                handler(matchDict)
                            }
                        }
                    }
                } else {
                    handler(nil)
                }
            }
        }
    }
}
