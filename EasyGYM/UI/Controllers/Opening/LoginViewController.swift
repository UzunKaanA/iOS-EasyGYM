//
//  LoginViewController.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 19.06.2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var switchKeepMeSigned: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        setUpElements()
        
        // Set switch state based on saved preference
        let keepMeSignedIn = UserDefaults.standard.bool(forKey: "keepMeSignedIn")
        switchKeepMeSigned.isOn = keepMeSignedIn
        
        checkUserStatus()
    }
    
    func setUpElements() {
        //Hide Error lbl.
        lblError.alpha = 0
        
        //Style TF
        Utilities.styleTextField(tfEmail)
        Utilities.styleTextField(tfPassword)
        Utilities.styleHollowButton(btnLogin)
        Utilities.styleHollowButton(btnSignUp)
        btnSignUp.backgroundColor = .none
        
    }
    @IBAction func actionKeepMeSigned(_ sender: Any) {
        
        UserDefaults.standard.set((sender as AnyObject).isOn, forKey: "keepMeSignedIn")
    }
    
    func checkUserStatus() {
        if UserDefaults.standard.bool(forKey: "keepMeSignedIn") {
            if Auth.auth().currentUser != nil {
                let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarViewController) as! TabBarViewController
                view.window?.rootViewController = homeViewController
                view.window?.makeKeyAndVisible()
            }
        }
    }
    
    private func setUpBackground(){
        let backgroundImage = UIImage(named: "auth")
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = backgroundImage
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        // TODO: Validate Text Fields
        
        // Create cleaned versions of the text field
        let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.lblError.text = error!.localizedDescription
                self.lblError.alpha = 1
            }
            else {
                
                
                
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarViewController) as? TabBarViewController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        
    }
    
}
