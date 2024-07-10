//
//  ProfileViewController.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 20.06.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var ivProfilePicture: UIImageView!
    @IBOutlet weak var lblNameSurname: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    
    @IBOutlet weak var btnFavs: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        fetchUserInfo()
        setUpElements()
    }
    
    func setUpElements() {
        //Style TF
        Utilities.styleFilledButton(btnLogout)
        Utilities.styleFilledButton(btnFavs)
    }
    
    private func setUpBackground() {
            let backgroundImage = UIImage(named: "main")
            let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.image = backgroundImage
            self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    private func updateBackgroundImage(updateBg:String) {
        let backgroundImage = UIImage(named: updateBg)
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = backgroundImage
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Check if the user interface style has changed
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // User interface style has changed (light to dark or vice versa)
            if self.traitCollection.userInterfaceStyle == .light {
                // Code to execute in light mode
                updateBackgroundImage(updateBg: "mainLight")
                print("App switched to light mode")
            } else {
                // Code to execute in dark mode
                updateBackgroundImage(updateBg: "main")
                print("App switched to dark mode")
            }
        }
    }
    
    func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(user.uid)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let firstName = data?["firstname"] as? String ?? ""
                let lastName = data?["lastname"] as? String ?? ""
                self.lblNameSurname.text = "\(firstName) \(lastName)"
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func btnFav(_ sender: Any) {
        
    }
    
    
    @IBAction func btnLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            //navigate to the Login Screen
            
            let firstViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.firstViewController) as? FirstViewController
            self.view.window?.rootViewController = firstViewController
            self.view.window?.makeKeyAndVisible()
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
}
