//
//  WorkoutService.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.06.2024.
//

import FirebaseFirestore
import FirebaseStorage

class WorkoutService {
    static let shared = WorkoutService()
    private let db = Firestore.firestore()
    
    func fetchWorkouts(completion: @escaping ([Workout]?, Error?) -> Void) {
        db.collection("workouts").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var workouts = [Workout]()
            for document in snapshot?.documents ?? [] {
                let data = document.data()
                let id = document.documentID
                let name = data["name"] as? String ?? ""
                
                let muscle = data["muscle"] as? [String: Any]
                let primaryMuscle = muscle?["Primary"] as? [String] ?? []
                let secondaryMuscle = muscle?["Secondary"] as? [String] ?? []
                
                let movementType = data["movement_type"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let photoURL = data["photoURL"] as? String ?? ""
                
                let workout = Workout(
                    id: id,
                    name: name,
                    primaryMuscle: primaryMuscle,
                    secondaryMuscle: secondaryMuscle,
                    movementType: movementType,
                    description: description,
                    photoURL: photoURL
                )
                
                workouts.append(workout)
            }
            completion(workouts, nil)
        }
    }
    
    func fetchDownloadURL(for gsURL: String, completion: @escaping (String?) -> Void) {
        let storage = Storage.storage()
        let ref = storage.reference(forURL: gsURL)
        ref.downloadURL { (url, error) in
            if let error = error {
                print("Error fetching download URL: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(url?.absoluteString)
        }
    }
}
