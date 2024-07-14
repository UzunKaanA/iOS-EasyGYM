//
//  FavouritesViewController.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.06.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var favSearch: UISearchBar!
    
    @IBOutlet weak var favoriteTableView: UITableView!
    var favoriteWorkouts: [Workout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchFavoriteWorkouts()
    }
    
    private func setupTableView() {
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.reloadData()
    }

    
    private func fetchFavoriteWorkouts() {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        let db = Firestore.firestore()
//        db.collection("Users").document(userID).collection("favorites").getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Error fetching favorites: \(error.localizedDescription)")
//                return
//            }
//            
//            print("Fetched favorites snapshot: \(snapshot?.documents ?? [])")
//            
//            self.favoriteWorkouts = snapshot?.documents.compactMap { document in
//                let data = document.data()
//                return Workout(
//                    id: document.documentID,
//                    name: data["name"] as? String ?? "",
//                    primaryMuscle: (data["primaryMuscle"] as? String ?? "").components(separatedBy: ", "),
//                    secondaryMuscle: (data["secondaryMuscle"] as? String ?? "").components(separatedBy: ", "),
//                    movementType: data["movementType"] as? String ?? "",
//                    description: data["description"] as? String ?? "",
//                    photoURL: data["photoURL"] as? String ?? ""
//                )
//            } ?? []
//            self.favoriteTableView.reloadData()
//        }
    }

}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteWorkouts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as? FavWorkoutTableViewCell else {
            return UITableViewCell()
        }

        let workout = favoriteWorkouts[indexPath.row]
       // cell.workout = workout
        cell.lblFavName.text = workout.name
        cell.lblFavPrimary.text = workout.primaryMuscle.map { $0.rawValue }.joined(separator: ", ")
        
        // Fetch image from Firebase Storage
        WorkoutService.shared.fetchDownloadURL(for: workout.photoURL) { url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                if let imageData = try? Data(contentsOf: URL(string: url)!) {
                    cell.ivFavWorkout.image = UIImage(data: imageData)
                }
            }
        }

        return cell
    }
}
