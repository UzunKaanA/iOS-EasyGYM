//
//  Workout.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.06.2024.
//

import FirebaseFirestore
import FirebaseStorage

enum MuscleType: String, Codable {
    case biceps
    case triceps
    case chest
    case lats
    case forearmFlexors
    case glutes
    case lowerBack
    case quads
    case hamstrings
}

enum MovementType: String, Codable {
    case push
    case pull
    case leg
}

struct Workout {
    var id: String
    var name: String
    var primaryMuscle: [MuscleType]
    var secondaryMuscle: [MuscleType]
    var movementType: MovementType
    var description: String
    var photoURL: String
}
