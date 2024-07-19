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
    
    var viewModel = LibraryViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var workoutTableView: UITableView!
    var workouts: [Workout] = []           // Array to hold all workouts fetched from Firestore
    var filteredSearchWorkouts: [Workout] = []   // Array to hold filtered workouts based on search query
    var filteredWorkouts: [Workout] = []
    var isSearching = false                // Flag to track if user is currently searching
    var isFiltering = false                // Flag to track if filtering on
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates for table view and search bar
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        searchBar.delegate = self

        viewModel.fetchWorkouts {
            print("Data fetched, reloading table view")
            self.workoutTableView.reloadData()
        }
    }
    
    func reloadTableData(){
        DispatchQueue.main.async {
            self.workoutTableView.reloadData()
        }
    }
    
    @IBAction func filterAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Filter Options", message:"Movement Type", preferredStyle: .actionSheet)

        let filterByPush = UIAlertAction(title: "Push", style: .default) { _ in
            self.viewModel.filterWorkouts(by: .push)
            self.reloadTableData()
        }
        let filterByPull = UIAlertAction(title: "Pull", style: .default) { _ in
            self.viewModel.filterWorkouts(by: .pull)
            self.reloadTableData()
        }
        let filterByLeg = UIAlertAction(title: "Leg", style: .default) {_ in
            self.viewModel.filterWorkouts(by: .leg)
            self.reloadTableData()
        }
        let clearFilter = UIAlertAction(title: "Clear Filter", style: .default) { _ in
            self.viewModel.clearFilter()
            self.reloadTableData()
        }
        
        alertController.addAction(filterByPush)
        alertController.addAction(filterByPull)
        alertController.addAction(filterByLeg)
        alertController.addAction(clearFilter)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    enum filterCriteria {
        case push
        case pull
        case leg
    }
}

// MARK: - Table View Delegate and Data Source Methods
extension LibraryViewController: UITableViewDelegate, UITableViewDataSource, WorkoutCellDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(viewModel.isFiltering) -> tableView")
        if viewModel.isFiltering {
            return viewModel.filteredWorkoutsCount
        } else if isSearching {
            return filteredSearchWorkouts.count
        } else {
            return viewModel.workoutsCount
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! WorkoutTableViewCell
        
        let workout: Workout
        if viewModel.isFiltering {
            workout = viewModel.filteredWorkouts[indexPath.row]
        } else if isSearching {
            workout = filteredSearchWorkouts[indexPath.row]
        } else {
            workout = viewModel.getWorkout(at: indexPath.row)
        }
        
        // Populate cell with workout data
        cell.lblWorkoutName.text = workout.name
        cell.lblPrimaryMuscle.text = workout.muscle.primary.map { $0.rawValue }.joined(separator: ", ").capitalized
        cell.cellProtocol = self
        cell.indexPath = indexPath
        cell.workout = workout
        cell.isFavorite = viewModel.favoriteWorkoutIDs.contains(workout.id)
        
        WorkoutService.shared.fetchDownloadURL(for: workout.photoURL) { url in
            guard let urlString = url, let imageUrl = URL(string: urlString) else {
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
            workout = viewModel.filteredWorkouts[indexPath.row]
        } else if isSearching {
            workout = filteredSearchWorkouts[indexPath.row]
        } else {
            workout = viewModel.getWorkout(at: indexPath.row)
        }
        
        viewModel.didTapFavorite(on: workout) {
            self.workoutTableView.reloadData()
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
            filteredSearchWorkouts = viewModel.workouts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
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
