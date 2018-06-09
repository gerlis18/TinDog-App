//
//  HomeViewController.swift
//  Tindog
//
//  Created by SimpleAp on 10/05/18.
//  Copyright © 2018 SimpleAp. All rights reserved.
//

import UIKit
import RevealingSplashView
import Firebase

class NavigationImageView : UIImageView {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 76, height: 39)
    }
}

class HomeViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardProfileImage: UIImageView!
    @IBOutlet weak var homeWrapper: UIStackView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var nopeImage: UIImageView!
    @IBOutlet weak var cardProfileName: UILabel!
    
    let revealingSplashScreen = RevealingSplashView(iconImage: UIImage(named: "splas_icon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    
    let leftBtn = UIButton(type: .custom)
    let rightBtn = UIButton(type: .custom)
    var currentUserProfile: UserModel?
    var users = [UserModel]()
    var secondUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(revealingSplashScreen)
        
        self.revealingSplashScreen.animationType = SplashAnimationType.popAndZoomOut
        self.revealingSplashScreen.startAnimation()
        
        let titleView = NavigationImageView()
        titleView.image = UIImage(named: "Actions")
        self.navigationItem.titleView = titleView
        let homeCR = UIPanGestureRecognizer(target: self, action: #selector(cardDragged(gestureRecognized:)))
        self.cardView.addGestureRecognizer(homeCR)
        
        self.leftBtn.setImage(UIImage(named: "login"), for: .normal)
        self.leftBtn.imageView?.contentMode = .scaleAspectFit
        let leftBarBtn = UIBarButtonItem(customView: self.leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let _ = user {
                print("el usuario ha iniciado sesion")
            } else {
                print("ha cerrado sesion")
            }
            
            DataBaseService.instance.observerProfileImage { (snapshot) in
                self.currentUserProfile = snapshot
            }
            self.getUsers()
        }
        
        UpdateDBService.instance.observeMatch { (matchDict) in
            print("update match")
            if let match = matchDict {
                if let user = self.currentUserProfile {
                    if user.userIsOnMatch == false {
                        print("hay un nuevo match")
                        self.changeRightBtn(active: true)
                    }
                }
            } else {
                self.changeRightBtn(active: false)
            }
        }
        
        self.rightBtn.setImage(UIImage(named: "match_inactive"), for: .normal)
        self.rightBtn.imageView?.contentMode = .scaleAspectFit
        let rightBarBtn = UIBarButtonItem(customView: self.rightBtn)
        self.navigationItem.rightBarButtonItem  = rightBarBtn
        
    }
    
    func changeRightBtn(active: Bool) {
        if (active) {
            self.rightBtn.setImage(UIImage(named: "match_active"), for: .normal)
        } else {
            self.rightBtn.setImage(UIImage(named: "match_inactive"), for: .normal)
        }
    }
    
    func getUsers() {
        DataBaseService.instance.User_ref.observeSingleEvent(of: .value) { (data) in
            let userSnapshot = data.children.flatMap{ UserModel(snapshot: $0 as! DataSnapshot) }
            for user in userSnapshot {
                self.users.append(user)
            }
            if self.users.count > 0 {
                self.updateImage(uid: (self.users.first?.uid)!)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.leftBtn.setImage(UIImage(named: "login_active"), for: .normal)
            self.leftBtn.removeTarget(nil, action: nil, for: .allEvents)
            self.leftBtn.addTarget(self, action: #selector(goToProfile(sender:)), for: .touchUpInside)
        } else {
            self.leftBtn.setImage(UIImage(named: "login"), for: .normal)
            self.leftBtn.removeTarget(nil, action: nil, for: .allEvents)
            self.leftBtn.addTarget(self, action: #selector(goToLogin(sender:)), for: .touchUpInside)
        }
    }

    @objc func goToLogin(sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        present(loginViewController, animated: true, completion: nil)
    }
    
    @objc func goToProfile(sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileViewController = storyBoard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        profileViewController.currentUserProfile = self.currentUserProfile
        self.navigationController?.pushViewController(profileViewController, animated: true)
        //present(profileViewController, animated: true, completion: nil)
    }
    
    @objc func cardDragged(gestureRecognized : UIPanGestureRecognizer) {
        let cardPoint = gestureRecognized.translation(in: view)
        self.cardView.center = CGPoint(x: self.view.bounds.width / 2 + cardPoint.x, y: self.view.bounds.height / 2 + cardPoint.y)
        
        let xFromCenter = (self.view.bounds.width / 2) - self.cardView.center.x
        var rotate = CGAffineTransform(rotationAngle: xFromCenter / 500)
        let scale = min(100 / abs(xFromCenter), 1)
        var finalTransform = rotate.scaledBy(x: scale, y: scale)
        self.cardView.transform = finalTransform
        
        if (self.cardView.center.x < (self.view.bounds.width / 2 - 100)) {
            self.nopeImage.alpha = min(abs(xFromCenter) / 100, 1)
        }
        
        if (self.cardView.center.x > (self.view.bounds.width / 2 + 100)) {
            self.likeImage.alpha = min(abs(xFromCenter) / 100, 1)
        }
        
        
        if (gestureRecognized.state == .ended) {
            if (self.cardView.center.x < (self.view.bounds.width / 2 - 100)) {
                self.nopeImage.alpha = 0
            }
            
            if (self.cardView.center.x > (self.view.bounds.width / 2 + 100)) {
                self.likeImage.alpha = 0
                if (self.secondUID != "") {
                    DataBaseService.instance.createFirebaseDBMatch(uid: (self.currentUserProfile?.uid)!, uid2: self.secondUID)
                }
            }
            
            // update image
            if (self.users.count > 0) {
                updateImage(uid: self.users[self.random(range: 0..<self.users.count)].uid)
            }
            
            rotate = CGAffineTransform(rotationAngle: 0)
            finalTransform = rotate.scaledBy(x: 1, y: 1)
            self.cardView.transform = finalTransform
            
            self.cardView.center = CGPoint(x: self.homeWrapper.bounds.width / 2, y: (self.homeWrapper.bounds.height / 2 - 35))
        }
    }
    
    func random(range: Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
    
    func updateImage(uid: String) {
        DataBaseService.instance.User_ref.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let userProfile = UserModel(snapshot: snapshot) {
                self.cardProfileImage.sd_setImage(with: URL(string: userProfile.profileImage ), completed: nil)
                self.cardProfileName.text = userProfile.displayName
                self.secondUID = userProfile.uid
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
