//
//  WorkoutTableViewCell.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.06.2024.
//

import UIKit

protocol WorkoutCellDelegate : AnyObject{
    func didTapFavorite(indexPath: IndexPath)
}

class WorkoutTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ivWorkout: UIImageView!
    @IBOutlet weak var lblWorkoutName: UILabel!
    @IBOutlet weak var lblPrimaryMuscle: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    
    
    var cellProtocol: WorkoutCellDelegate?
    var workout: Workout?
    var indexPath:IndexPath?
    var isFavorite: Bool = false {
        didSet {
            updateFavoriteButton()
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
            print("Favorite button tapped for workout")
        guard let indexPath = indexPath else { return }
           cellProtocol?.didTapFavorite(indexPath: indexPath)

       }
    
    private func updateFavoriteButton() {
           let imageName = isFavorite ? "heart.fill" : "heart"
        btnFav.setImage(UIImage(systemName: imageName), for: .normal)
       }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
