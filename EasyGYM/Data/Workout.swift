//
//  Workout.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.06.2024.
//

import FirebaseFirestore
import FirebaseStorage

enum MuscleType: String, Codable {
    case biceps = "Biceps"
    case triceps = "Triceps"
    case chest = "Chest"
    case lats = "Lats"
    case forearmFlexors = "Forearm Flexors"
    case glutes = "Glutes"
    case lowerBack = "Lower Back"
    case quads = "Quads"
    case hamstrings = "Hamstrings"
    case adductors = "Adductors"
    case trapezius = "Trapezius"
    case rearDeltoids = "Rear Deltoids"
    case rotatorCuffs = "Rotator Cuff"
    case frontDeltoid = "Front Deltoid"
}

enum MovementType: String, Codable {
    case push = "Push"
    case pull = "Pull"
    case leg = "Leg"
}

struct Workout: Codable {
    var id: String
    var name: String
    var movementType: MovementType
    var description: String
    var photoURL: String
    var muscle: Muscle
    
    enum CodingKeys: String, CodingKey {
            case id
            case name
            case muscle
            case movementType = "movement_type"
            case description
            case photoURL
        }
}

struct Muscle: Codable {
    var primary: [MuscleType]
    var secondary: [MuscleType]?
    
    enum CodingKeys: String, CodingKey {
        case primary = "Primary"
        case secondary = "Secondary"
    }
}

