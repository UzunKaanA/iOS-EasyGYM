//
//  HomeViewController.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 19.06.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
    let symbols =    ["X", "X", "X", "X", "X", "X", "X"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        collectionViewCustomize()
        navigationBarCustomize()
    }
    
    func navigationBarCustomize(){
        navigationItem.title = "Homepage"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "Color")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(
          named: "LetterColor")!,
          .font: UIFont(
            name: "Kanit-Regular",
            size: 22)!
        ]
    }
    
    func collectionViewCustomize(){
        calendarCollectionView.layer.shadowColor = UIColor.black.cgColor
        calendarCollectionView.layer.shadowOpacity = 0.5
        calendarCollectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        calendarCollectionView.layer.shadowRadius = 4
        calendarCollectionView.layer.masksToBounds = false
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource  {
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalenderCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.dayLabel.text = daysOfWeek[indexPath.row]
        cell.symbolLabel.text = symbols[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7 // Assuming you want 7 items per row
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
