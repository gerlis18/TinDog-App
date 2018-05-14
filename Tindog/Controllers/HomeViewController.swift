//
//  HomeViewController.swift
//  Tindog
//
//  Created by SimpleAp on 10/05/18.
//  Copyright © 2018 SimpleAp. All rights reserved.
//

import UIKit

class NavigationImageView : UIImageView {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 76, height: 39)
    }
}

class HomeViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var homeWrapper: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleView = NavigationImageView()
        titleView.image = UIImage(named: "Actions")
        self.navigationItem.titleView = titleView
        let homeCR = UIPanGestureRecognizer(target: self, action: #selector(cardDragged(gestureRecognized:)))
        self.cardView.addGestureRecognizer(homeCR)
        // Do any additional setup after loading the view.
    }

    @objc func cardDragged(gestureRecognized : UIPanGestureRecognizer) {
        let cardPoint = gestureRecognized.translation(in: view)
        self.cardView.center = CGPoint(x: self.view.bounds.width / 2 + cardPoint.x, y: self.view.bounds.height / 2 + cardPoint.y)
        if (gestureRecognized.state == .ended) {
            if (self.cardView.center.x < (self.view.bounds.width / 2 - 100)) {
                
            }
            
            if (self.cardView.center.x > (self.view.bounds.width / 2 + 100)) {
                
            }
            
            self.cardView.center = CGPoint(x: self.homeWrapper.bounds.width / 2, y: (self.homeWrapper.bounds.height / 2 - 35))
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