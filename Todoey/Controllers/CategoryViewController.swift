//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Roboost Mobile on 05/02/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories:[CategoryItem]=[CategoryItem]()
    var selectedCategory: CategoryItem?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadItems()
    }
    
    
    //MARK: - TableView Data Source Methods.
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "categoryListCell", for: indexPath)
       
       // Configure the cell’s contents.
        cell.textLabel!.text = categories[indexPath.row].title
    
       return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        selectedCategory = categories[indexPath.row]

        self.performSegue(withIdentifier: "GoToTodoItems", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        destinationVC.category = selectedCategory!
    }
    
  
    

    
    //MARK: - Add Category Item
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        var uiTextField = UITextField()
        let alertController = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
             if let text = uiTextField.text {
                 let item = CategoryItem(context: self.context)
                 item.title = text
                 self.saveItems()
                 self.loadItems()
             }
         }
        
        alertController.addAction(addAction)
        
        alertController.addTextField { (textField) in
            uiTextField = textField
            textField.placeholder = "Enter Category"
        }
 
        present(alertController, animated: true, completion: nil)
    }
    
    func loadItems(_ request: NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()){
        do{
            categories = try context.fetch(request)
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
