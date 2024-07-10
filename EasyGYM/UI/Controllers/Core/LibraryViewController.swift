//
//  LibraryViewController.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 20.06.2024.
//

import UIKit
import SDWebImage
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseFirestore

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var workoutTableView: UITableView!
    var favoriteWorkoutIDs: Set<String> = []
    
    var workouts: [Workout] = []           // Array to hold all workouts fetched from Firestore
    var filteredSearchWorkouts: [Workout] = []   // Array to hold filtered workouts based on search query
    var filteredWorkouts: [Workout] = []
    var isSearching = false                // Flag to track if user is currently searching
    var isFiltering = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates for table view and search bar
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        searchBar.delegate = self
        
        // Fetch workouts from Firestore
        fetchWorkouts()
        fetchFavoriteWorkouts()
    }
    
    @IBAction func filterAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Filter Options", message:"", preferredStyle: .actionSheet)
        let filterByPull = UIAlertAction(title: "Movement: Pull", style: .default) { _ in
            self.FilterWorkouts(by: .Pull)
        }
        let filterByPush = UIAlertAction(title: "Movement: Push", style: .default) { _ in
            self.FilterWorkouts(by: .Push )
        }
        let filterByLeg = UIAlertAction(title: "Movement: Leg", style: .default) {_ in
            self.FilterWorkouts(by: .Leg)
        }
        let clearFilter = UIAlertAction(title: "Clear Filter", style: .default) { _ in
            self.clearFilter()
        }
        
        alertController.addAction(filterByPull)
        alertController.addAction(filterByPush)
        alertController.addAction(filterByLeg)
        alertController.addAction(clearFilter)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    enum FilterCriteria {
        case Push
        case Pull
        case Leg
    }
    
    func FilterWorkouts(by criteria: FilterCriteria) {
        switch criteria {
            
        case .Push:
            filteredWorkouts = workouts.filter { $0.movementType.lowercased() == "push" }
            
        case .Pull:
            filteredWorkouts = workouts.filter{ $0.movementType.lowercased() == "pull" }
        
        case .Leg:
            filteredWorkouts = workouts.filter{ $0.movementType.lowercased() == "leg"}
        }
        
        
        
        isFiltering = true
        DispatchQueue.main.async {
            self.workoutTableView.reloadData()
        }
    }
    
    func clearFilter() {
        isFiltering = false
        filteredWorkouts.removeAll()
        DispatchQueue.main.async {
            self.workoutTableView.reloadData()
        }
    }
    
    
    
    
    private func fetchFavoriteWorkouts() {
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
            self.workoutTableView.reloadData()
        }
    }
    
    // Function to fetch workouts from Firestore using shared instance of WorkoutService
    func fetchWorkouts() {
        WorkoutService.shared.fetchWorkouts { [weak self] (workouts, error) in
            if let error = error {
                print("Error fetching workouts: \(error.localizedDescription)")
                return
            }
            
            // Update workouts array and reload table view on main thread
            DispatchQueue.main.async {
                self?.workouts = workouts ?? []
                self?.workoutTableView.reloadData()
            }
        }
    }
}

// MARK: - Table View Delegate and Data Source Methods
extension LibraryViewController: UITableViewDelegate, UITableViewDataSource, WorkoutCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredWorkouts.count
        } else if isSearching {
            return filteredSearchWorkouts.count
        } else {
            return workouts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! WorkoutTableViewCell
        
        // Determine the correct workout object based on whether searching or filtering
        let workout: Workout
        if isFiltering {
            workout = filteredWorkouts[indexPath.row]
        } else if isSearching {
            workout = filteredSearchWorkouts[indexPath.row]
        } else {
            workout = workouts[indexPath.row]
        }
        
        // Populate cell with workout data
        cell.lblWorkoutName.text = workout.name
        cell.lblPrimaryMuscle.text = workout.primaryMuscle.joined(separator: ", ")
        
        // Set the delegate and indexPath
        cell.cellProtocol = self
        cell.indexPath = indexPath
        cell.workout = workout
        cell.isFavorite = favoriteWorkoutIDs.contains(workout.id)
        
        // Fetch and display workout image from Firebase Storage using SDWebImage
        WorkoutService.shared.fetchDownloadURL(for: workout.photoURL) { url in
            guard let urlString = url, let imageUrl = URL(string: urlString) else {
                // Handle case where URL is invalid or download fails
                return
            }
            cell.ivWorkout.sd_setImage(with: imageUrl, completed: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection if needed
    }
    
    func didTapFavorite(indexPath: IndexPath) {
        let workout: Workout
        if isFiltering {
            workout = filteredWorkouts[indexPath.row]
        } else if isSearching {
            workout = filteredSearchWorkouts[indexPath.row]
        } else {
            workout = workouts[indexPath.row]
        }
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let workoutRef = db.collection("Users").document(userID).collection("favorites").document(workout.id)
        
        if favoriteWorkoutIDs.contains(workout.id) {
            // Remove from favorites
            workoutRef.delete { error in
                if let error = error {
                    print("Error removing favorite: \(error.localizedDescription)")
                    return
                }
                print("Removed favorite: \(workout.name)")
                self.favoriteWorkoutIDs.remove(workout.id)
                self.workoutTableView.reloadData()
            }
        } else {
            // Add to favorites
            let workoutData: [String: Any] = [
                "name": workout.name,
                "primaryMuscle": workout.primaryMuscle.joined(separator: ", "),
                "secondaryMuscle": workout.secondaryMuscle.joined(separator: ", "),
                "movementType": workout.movementType,
                "description": workout.description,
                "photoURL": workout.photoURL
            ]
            workoutRef.setData(workoutData) { error in
                if let error = error {
                    print("Error adding favorite: \(error.localizedDescription)")
                    return
                }
                print("Added to favorites: \(workout.name)")
                self.favoriteWorkoutIDs.insert(workout.id)
                self.workoutTableView.reloadData()
            }
        }
    }
}

// MARK: - Search Bar Delegate Methods
extension LibraryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Clear search results and reload table view with all workouts
            isSearching = false
            filteredSearchWorkouts.removeAll()
        } else {
            // Filter workouts based on search query and reload table view
            isSearching = true
            filteredSearchWorkouts = workouts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        workoutTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Clear search bar text and reset search state to show all workouts
        searchBar.text = ""
        isSearching = false
        workoutTableView.reloadData()
    }
}
