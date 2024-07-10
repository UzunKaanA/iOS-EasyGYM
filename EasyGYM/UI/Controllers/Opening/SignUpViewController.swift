//
//  SignUpViewController.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 19.06.2024.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        setUpElements()
    }
    
    func setUpElements(){
        //Hide Error.
        lblError.alpha = 0
        
        //Style Text Fields
        Utilities.styleTextField(tfFirstName)
        Utilities.styleTextField(tfLastName)
        Utilities.styleTextField(tfEmail)
        Utilities.styleTextField(tfPassword)
        Utilities.styleHollowButton(btnSignUp)
    }
    
    private func setUpBackground(){
        let backgroundImage = UIImage(named: "auth")
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = backgroundImage
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    
    //Check fields and validate the data, if everything correct -> nil. Otherwise, return error message.
    func validateFields() -> String? {
        //Check all the fields are filled.
        if tfFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //Check if password secure.
        
        let cleanedPassword = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword!) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        
        return nil
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        //Validate the fields
        let error = validateFields()
        if error != nil {
            //Something wrong in the fields, show error.
            showError(error!)
        }else{
            
            let firstName = tfFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = tfLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Create User
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if err != nil {
                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    let db = Firestore.firestore()
                    
                    db.collection("Users").document(result!.user.uid).setData(["firstname":firstName,
                                                              "lastname":lastName,
                                                              "uid":result!.user.uid
                                                             ]) { (error) in
                        if error != nil {
                            //show error
                            print(error?.localizedDescription ?? "err")
                        }
                    }
                    //to HomeScreen
                    self.navigateToHome()
                }
            }
        }
    }
    
    func showError(_ message: String){
        lblError.text = message
        lblError.alpha = 1
    }
    
    func navigateToHome() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarViewController) as? TabBarViewController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
    
}
