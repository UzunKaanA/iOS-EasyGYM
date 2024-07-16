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
    case forearmFlexors = "Forearm Flexors"
    case glutes
    case lowerBack = "Lower Back"
    case quads
    case hamstrings
}

enum MovementType: String, Codable {
    case push
    case pull
    case leg
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
    var secondary: [MuscleType]
    
    enum CodingKeys: String, CodingKey {
        case primary = "Primary"
        case secondary = "Secondary"
    }
}

