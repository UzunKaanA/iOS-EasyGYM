//
//  Workout.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.06.2024.
//

import FirebaseFirestore
import FirebaseStorage

struct Workout {
    var id: String
    var name: String
    var primaryMuscle: [String]
    var secondaryMuscle: [String]
    var movementType: String
    var description: String
    var photoURL: String
}
