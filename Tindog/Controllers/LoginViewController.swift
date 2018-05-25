//
//  LoginViewController.swift
//  Tindog
//
//  Created by SimpleAp on 17/05/18.
//  Copyright © 2018 SimpleAp. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginCopyLbl: UILabel!
    @IBOutlet weak var subLogin: UIButton!
    var registerMode = true
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginActionBtn(_ sender: Any) {
        if (self.emailTextField.text == "" || self.passwordTextField.text == "") {
            self.showAlert(title: "Error", message: "Alguno de los campos esta vacio")
        } else {
            if let email = self.emailTextField.text {
                if let pass = self.passwordTextField.text {
                    if self.registerMode {
                        Auth.auth().createUser(withEmail: email, password: pass) { (user, err) in
                            if err != nil {
                                self.showAlert(title: "Error", message: err!.localizedDescription)
                            } else {
                                print("usuario registrado")
                                if let user = user {
                                    let userData = ["provider": user.providerID, "email": user.email!, "profileImage": "", "displayName": "crispeta"] as [String: Any]
                                    DataBaseService.instance.createFirebaseDBUser(uid: user.uid, userData: userData)
                                }
                            }
                        }
                    } else {
                        Auth.auth().signIn(withEmail: email, password: pass) { (user, err) in
                            if err != nil {
                                self.showAlert(title: "Error", message: err!.localizedDescription)
                            } else {
                                print("usuario logueado")
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func subLoginActionBtn(_ sender: Any) {
        if (self.registerMode) {
            self.loginBtn.setTitle("Login", for: .normal)
            self.loginCopyLbl.text = "Eres nuevo?"
            self.subLogin.setTitle("Registrate", for: .normal)
            self.registerMode = false
        } else {
            self.loginBtn.setTitle("Crear Cuenta", for: .normal)
            self.loginCopyLbl.text = "Ya tienes cuenta?"
            self.subLogin.setTitle("Login", for: .normal)
            self.registerMode = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bindKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
