//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Roboost Mobile on 11/02/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController ,SwipeTableViewCellDelegate{

    override func viewDidLoad() {
        tableView.separatorStyle = .none
        
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
       return cell
    }

    //MARK: - SwipeCellKit Delegate
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
         guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.updateCell(indexPath)
            }

            // customize the action appearance
            deleteAction.image = UIImage(systemName: "delete")

            return [deleteAction]
     }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
     
    func updateCell(_ indexPath: IndexPath){
        
    }
     
}
