//
//  PopOverViewController.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 22.07.2024.
//

import UIKit

class PopOverViewController: UIViewController {
    
    
    @IBOutlet weak var movementTypesTableView: UITableView!
    
    var movementTypes: [MovementType] = [.push, .pull, .leg]
    var selectedMovementTypes: Set<MovementType> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.preferredContentSize = CGSize(width: 200, height: 175)
        //To check the if getting the page
        view.backgroundColor = .systemRed
        movementTypesTableView.dataSource = self
        movementTypesTableView.delegate = self
        movementTypesTableView.reloadData()
        print("View did load")
                print("Table view datasource and delegate set")
    }

}

//MARK: TableView
extension PopOverViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(movementTypes.count)Number of rows in section called")
        return movementTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("Cell for row at index path called for row \(indexPath.row)")
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovementTypesCell", for: indexPath) as? MovementTypesFilterTableViewCell else {
                print("Could not dequeue cell")
                return UITableViewCell()
            }
            
            let movementType = movementTypes[indexPath.row]
            cell.lblMovementName.text = movementType.rawValue
            cell.btnMovementCheckBox.isSelected = selectedMovementTypes.contains(movementType)
            cell.btnMovementCheckBox.setImage(UIImage(systemName: "square"), for: .normal)
            cell.btnMovementCheckBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
            cell.btnMovementCheckBox.tag = indexPath.row
            
            return cell
        }

    
    @objc func checkBoxTapped(_ sender: UIButton) {
            let index = sender.tag
            let movementType = movementTypes[index]
            
            if selectedMovementTypes.contains(movementType) {
                selectedMovementTypes.remove(movementType)
            } else {
                selectedMovementTypes.insert(movementType)
            }
            
            sender.isSelected = !sender.isSelected
        }
    
}
