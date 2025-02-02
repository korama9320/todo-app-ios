//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    var todos:[TodoItem]=[TodoItem]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadItems()
    }
    

    //MARK: - TableView Data Source Methods.
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
       
       // Configure the cell’s contents.
        cell.textLabel!.text = todos[indexPath.row].title
        
        cell.accessoryType = todos[indexPath.row].done ? .checkmark : .none
        
    
        
       return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todos [indexPath.row].done = !todos[indexPath.row].done
        tableView.reloadRows(at: [indexPath], with: .none)
        saveItems()
    }
    
    //MARK: - Add Todo Item
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        var uiTextField = UITextField()
        let alertController = UIAlertController(title: "Add Todo Item", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
             if let text = uiTextField.text {
                 let item = TodoItem(context: self.context)
                 item.title = text
                 item.done = false
                 self.saveItems()
                 self.loadItems()
                 self.tableView.reloadData()

             }
         }
        
        alertController.addAction(addAction)
        
        alertController.addTextField { (textField) in
            uiTextField = textField
            textField.placeholder = "Enter Todo Item"
        }
 
        present(alertController, animated: true, completion: nil)
    }
    
    func loadItems(){
        do{
            let request: NSFetchRequest<TodoItem>=TodoItem.fetchRequest()
            todos = try context.fetch(request)
        }catch{
            print("error \(error)")
         }
    }
    
    func saveItems(){
        do{
          try context.save()
        }
        catch{
            print("error \(error)")
        }
    }

}

