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
    var category: CategoryItem?{
        didSet{
            loadItems()
        }
    }
    
    var todos:[TodoItem]=[TodoItem]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                 item.parent = self.category
                 self.saveItems()
                 self.loadItems()
             }
         }
        
        alertController.addAction(addAction)
        
        alertController.addTextField { (textField) in
            uiTextField = textField
            textField.placeholder = "Enter Todo Item"
        }
 
        present(alertController, animated: true, completion: nil)
    }
    
    func loadItems(_ request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()){
        do{
            let catPredicate = NSPredicate(format:"parent.title MATCHES[cd] %@" ,category?.title ?? "")
            if let searchPredicate = request.predicate{
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate,searchPredicate])
            }else{
                request.predicate = catPredicate
            }

            todos = try context.fetch(request)
            self.tableView.reloadData()
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

//MARK: -  Search Bar Delegate methods

extension TodoViewController :UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count == 0){
            loadItems()
        }
    }
}
