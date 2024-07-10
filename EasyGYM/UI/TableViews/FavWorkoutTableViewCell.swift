//
//  FavWorkoutTableViewCell.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.06.2024.
//

import UIKit


class FavWorkoutTableViewCell: UITableViewCell {
    

    @IBOutlet weak var ivFavWorkout: UIImageView!
    @IBOutlet weak var lblFavName: UILabel!
    @IBOutlet weak var lblFavPrimary: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

