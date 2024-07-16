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
                        let data = document.data()
                        print("document data : \(data)")
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let decodedObject = try Firestore.Decoder().decode(T.self, from: data)
                        objects.append(decodedObject)
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
