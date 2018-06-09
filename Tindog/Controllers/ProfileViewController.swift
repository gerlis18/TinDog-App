//
//  ProfileViewController.swift
//  Tindog
//
//  Created by SimpleAp on 24/05/18.
//  Copyright © 2018 SimpleAp. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayNameLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    
    var currentUserProfile: UserModel?
    
    @IBAction func closeProfileBtn(_ sender: Any) {
        try! Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.height / 2
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.layer.borderWidth = 1.0
        self.profileImage.clipsToBounds = true
        
        self.emailLb.text = self.currentUserProfile?.email
        self.displayNameLb.text = self.currentUserProfile?.displayName
        self.profileImage.sd_setImage(with: URL(string: (self.currentUserProfile?.profileImage)!), completed: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func importUsers(_ sender: Any) {
        let users  = [["email": "bruno@asd.com", "password": "123456", "displayName": "Bruno", "photoURL":"https://i.imgur.com/YYqOgZB.jpg"],
                      ["email": "bublie@asd.com", "password": "123456", "displayName": "Bublie", "photoURL":"https://i.imgur.com/rmBXzbv.jpg"],
                      ["email": "buddy@asd.com", "password": "123456", "displayName": "Buddy", "photoURL":"https://i.imgur.com/piEDB2T.jpg"],
                      ["email": "boss@asd.com", "password": "123456", "displayName": "Boss", "photoURL":"https://i.imgur.com/gCclkXK.jpg"],
                      ["email": "chipotle@asd.com", "password": "123456", "displayName": "Chipotle", "photoURL":"https://i.imgur.com/ocNYvgJ.jpg"]]
        
        for userDemo in users{
            Auth.auth().createUser(withEmail: userDemo["email"]!, password: userDemo["password"]!, completion: { (user, error) in
                if let user = user{
                    let userData = ["provider": user.providerID, "email": user.email!, "profileImage": userDemo["photoURL"]!, "displayName": userDemo["displayName"]!, "userIsOnMatch": false] as [String: Any]
                    DataBaseService.instance.createFirebaseDBUser(uid: user.uid, userData: userData)
                }
                
            })
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
