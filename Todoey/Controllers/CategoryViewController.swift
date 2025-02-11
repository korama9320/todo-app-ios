//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Roboost Mobile on 05/02/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories:Results<CategoryItem>!
    var selectedCategory: CategoryItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadItems()
    }
    
    
    //MARK: - TableView Data Source Methods.
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
       // Configure the cell’s contents.
        cell.textLabel!.text = categories?[indexPath.row].title ?? "No categories available yet"
    
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
                 let category = CategoryItem()
                 category.title = text
                 self.saveItems(category)
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
    
    func loadItems(){
            categories = realm.objects(CategoryItem.self)
            self.tableView.reloadData()
    
    }
    
    func saveItems(_ category: CategoryItem){
        do{
            try realm.write{
                realm.add(category)
            }
        }
        catch{
            print("error \(error)")
        }
    }
    
    override func updateCell(_ indexPath: IndexPath) {
        do{
            try self.realm.write{
                self.realm.delete(self.categories[indexPath.row])
            }
        }catch{
            print("error \(error)")
        }
    }

}
