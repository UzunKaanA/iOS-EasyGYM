//
//  LibraryViewModel.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.06.2024.
//

import Foundation

class LibraryViewModel {
    
    var libraryRepo = WorkoutService()
    var filteredWorkouts: [Workout] = []
    var workouts: [Workout] = []
    var isFiltering: Bool = false
    var favoriteWorkoutIDs: Set<String> = []
    
    func filterWorkouts(by criteria: LibraryViewController.filterCriteria){
        print("Filtering workouts by \(criteria)")
        switch criteria {
        case .push:
            filteredWorkouts = workouts.filter { $0.movementType == .push }
        case .pull:
            filteredWorkouts = workouts.filter{ $0.movementType == .pull }
        case .leg:
            filteredWorkouts = workouts.filter{ $0.movementType == .leg }
        }
        print("Filtered Workouts: \(filteredWorkouts.count)")
        isFiltering = true
    }
    
    func clearFilter(){
        isFiltering = false
        filteredWorkouts.removeAll()
    }
    
    func fetchWorkouts(completion: @escaping () -> Void) {
        WorkoutService.shared.fetchWorkouts { [weak self] (workouts, error) in
            if let error = error {
                print("Error fetching workouts: \(error.localizedDescription)")
                return
            }
            self?.workouts = workouts ?? []
            print("Fetched Workouts: \(self?.workouts.count ?? 0)")
            completion()
        }
    }
    
    var workoutsCount: Int {
        workouts.count
    }
    
    var filteredWorkoutsCount: Int {
        filteredWorkouts.count
    }
    
    func getWorkout(at index: Int) -> Workout {
        return workouts[index]
    }
    
    func isFavorite(workoutID: String) -> Bool {
        return favoriteWorkoutIDs.contains(workoutID)
    }
    
    func didTapFavorite(on workout: Workout, completion: @escaping () -> Void) {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        let db = Firestore.firestore()
//        let workoutRef = db.collection("users").document(userID).collection("favorites").document(workout.id)
//        
//        if favoriteWorkoutIDs.contains(workout.id) {
//            // Remove from favorites
//            workoutRef.delete { error in
//                if let error = error {
//                    print("Error removing favorite: \(error.localizedDescription)")
//                    return
//                }
//                print("Removed favorite: \(workout.name)")
//                self.favoriteWorkoutIDs.remove(workout.id)
//                completion()
//            }
//        } else {
//            // Add to favorites
//            let workoutData: [String: Any] = [
//                "name": workout.name,
//                "primaryMuscle": workout.primaryMuscle.map { $0.rawValue },
//                "secondaryMuscle": workout.secondaryMuscle.map { $0.rawValue },
//                "movementType": workout.movementType.rawValue,
//                "description": workout.description,
//                "photoURL": workout.photoURL
//            ]
//            workoutRef.setData(workoutData) { error in
//                if let error = error {
//                    print("Error adding favorite: \(error.localizedDescription)")
//                    return
//                }
//                print("Added to favorites: \(workout.name)")
//                self.favoriteWorkoutIDs.insert(workout.id)
//                completion()
//            }
//        }
    }
}
