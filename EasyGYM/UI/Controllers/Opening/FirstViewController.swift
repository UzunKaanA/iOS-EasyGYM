//
//  ViewController.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 19.06.2024.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        setUpElements()
    }
    func setUpElements() {
        Utilities.styleHollowButton(btnLogin)
        Utilities.styleHollowButton(btnSignUp)
    }
    
    private func setUpBackground(){
        let backgroundImage = UIImage(named: "EasyGYM")
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = backgroundImage
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    
    
    
    @IBAction func btnLogin(_ sender: Any) {
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
    }
    
}

