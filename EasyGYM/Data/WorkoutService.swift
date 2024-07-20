//
//  WorkoutService.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.06.2024.
//

import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class WorkoutService {
    static let shared = WorkoutService()
    private let db = Firestore.firestore()
    var favoriteWorkoutIDs: Set<String> = []
    
    //generic
    func fetchCollection<T: Codable>(collectionName: String, completion: @escaping (Result<[T], Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection(collectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No documents found"])))
                return
            }
            
            do {
                var objects: [T] = []
                for document in documents {
                    var data = document.data()
                    // Add more detailed logging to inspect data before decoding
                    data["id"] = document.documentID
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let jsonString = String(data: jsonData, encoding: .utf8) ?? "nil"
                        print("json string : \(jsonString)")
                        
                        let decodedObject = try Firestore.Decoder().decode(T.self, from: data)
                        objects.append(decodedObject)
                    } catch {
                        print("Failed to decode document with data: \(data)")
                        print("Error: \(error)")
                        throw error
                    }
                }
                completion(.success(objects))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func fetchWorkouts(completion: @escaping ([Workout]?, Error?) -> Void) {
        fetchCollection(collectionName: "workouts") { (result: Result<[Workout], Error>) in
            switch result {
            case .success(let workouts):
                completion(workouts, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchFavoriteWorkouts(completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userID).collection("favorites").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching favorites: \(error.localizedDescription)")
                return
            }
            for document in snapshot?.documents ?? [] {
                self.favoriteWorkoutIDs.insert(document.documentID)
            }
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
