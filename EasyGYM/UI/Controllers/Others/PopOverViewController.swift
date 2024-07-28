//
//  PopOverViewController.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.07.2024.
//

import UIKit

class PopOverViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let movementTypesTableView = UITableView()
    private let muscleTypesTableView = UITableView()
    
    private let lblMovementType: UILabel = {
        let label = UILabel()
        label.text = "Movement Type Filter"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let lblMuscleType: UILabel = {
        let label = UILabel()
        label.text = "Muscle Type Filter"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    var movementTypes = ["Push",
                         "Pull",
                         "Leg"
    ]
    
    var muscleTypes = ["Biceps",
                       "Triceps",
                       "Chest",
                       "Lats",
                       "Forearm Flexors",
                       "Glutes",
                       "Lower Back",
                       "Quads",
                       "Hamstrings",
                       "Adductors",
                       "Trapezius",
                       "Rear Deltoids",
                       "Rotator Cuff",
                       "Front Deltoid"
    ]
    
    var selectedMovementTypes = [Bool]()
    var selectedMuscleTypes = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up labels & tableViews constraints
        setupLabelAndTableViews()
        
        //Setting scroll view
        setupScrollView()
        
        //registering cell
        movementTypesTableView.register(
            SimpleSelectionTableViewCell.self,
            forCellReuseIdentifier: "MovementTypesCell"
        )
        muscleTypesTableView.register(
            SimpleSelectionTableViewCell.self,
            forCellReuseIdentifier: "MuscleTypesCell"
        )
        
        //setting up delegate and datasource
        movementTypesTableView.delegate = self
        movementTypesTableView.dataSource = self
        muscleTypesTableView.delegate = self
        muscleTypesTableView.dataSource = self
        
        movementTypesTableView.reloadData()
        muscleTypesTableView.reloadData()
        print("View did load")
        print("Table view datasource and delegate set")
    }
    
    func setupLabelAndTableViews(){
        contentView.addSubview(lblMovementType)
        contentView.addSubview(movementTypesTableView)
        contentView.addSubview(lblMuscleType)
        contentView.addSubview(muscleTypesTableView)
        
        lblMovementType.translatesAutoresizingMaskIntoConstraints = false
        lblMuscleType.translatesAutoresizingMaskIntoConstraints = false
        movementTypesTableView.translatesAutoresizingMaskIntoConstraints = false
        muscleTypesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        selectedMovementTypes = Array(repeating: false, count: movementTypes.count)
        selectedMuscleTypes = Array(repeating: false, count: muscleTypes.count)
        
        // Setting up constraints
        NSLayoutConstraint.activate([
            // Movement Type Label
            lblMovementType.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            lblMovementType.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            lblMovementType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            lblMovementType.heightAnchor.constraint(equalToConstant: 30),
            
            // Movement Types Table View
            movementTypesTableView.topAnchor.constraint(equalTo: lblMovementType.bottomAnchor, constant: 10),
            movementTypesTableView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            movementTypesTableView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            movementTypesTableView.heightAnchor.constraint(equalToConstant: 100),
            
            // Muscle Type Label
            lblMuscleType.topAnchor.constraint(equalTo: movementTypesTableView.bottomAnchor, constant: 10),
            lblMuscleType.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            lblMuscleType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            lblMuscleType.heightAnchor.constraint(equalToConstant: 30),
            
            // Muscle Types Table View
            muscleTypesTableView.topAnchor.constraint(equalTo: lblMuscleType.bottomAnchor, constant: 10),
            muscleTypesTableView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            muscleTypesTableView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            muscleTypesTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            muscleTypesTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setupScrollView(){
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
    }
}

//MARK: TableView
extension PopOverViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case movementTypesTableView:
            return movementTypes.count
        case muscleTypesTableView:
            return muscleTypes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case movementTypesTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovementTypesCell", for: indexPath) as? SimpleSelectionTableViewCell else {
                print("Could not dequeue cell")
                return UITableViewCell()
            }
            cell.filterName.text = movementTypes[indexPath.row]
            cell.checkBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
            cell.checkBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
            cell.checkBoxButton.isSelected = selectedMovementTypes[indexPath.row]
            cell.checkBoxButton.tag = indexPath.row
            cell.checkBoxButton.addTarget(self, action: #selector(movementCheckBoxTapped(_:)), for: .touchUpInside)
            return cell
        case muscleTypesTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MuscleTypesCell", for: indexPath) as? SimpleSelectionTableViewCell else {
                print("Could not dequeue cell")
                return UITableViewCell()
            }
            cell.filterName.text = muscleTypes[indexPath.row]
            cell.checkBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
            cell.checkBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
            cell.checkBoxButton.isSelected = selectedMuscleTypes[indexPath.row]
            cell.checkBoxButton.tag = indexPath.row
            cell.checkBoxButton.addTarget(self, action: #selector(muscleCheckBoxTapped(_:)), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
    }
    //Selecting row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func movementCheckBoxTapped(_ sender: UIButton) {
            sender.isSelected.toggle()
            selectedMovementTypes[sender.tag] = sender.isSelected
        }
        
        @objc func muscleCheckBoxTapped(_ sender: UIButton) {
            sender.isSelected.toggle()
            selectedMuscleTypes[sender.tag] = sender.isSelected
        }
}
