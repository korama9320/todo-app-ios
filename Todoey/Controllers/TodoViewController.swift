//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoViewController: SwipeTableViewController {

    let realm = try! Realm()
    var catColor:UIColor?
    
    @IBOutlet weak var searcchBar: UISearchBar!
    
    var category: CategoryItem?{
        didSet{
            loadItems()
        }
    }
    
    var todos: Results<TodoItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        catColor = UIColor(hexString: category?.color)
        let catContrastColor = UIColor(contrastingBlackOrWhiteColorOn:catColor, isFlat:true)
        if let navBar = navigationController?.navigationBar{
            navBar.backgroundColor = catColor
            navBar.tintColor = catContrastColor
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: catContrastColor ?? .white]
        }
        
        title = category?.title

        searcchBar.barTintColor = catColor
    }
    
    

   
    
    //MARK: - TableView Data Source Methods.
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 1
    }
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel!.text = todos?[indexPath.row].title ?? "No items available yet"
       if let color = catColor?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todos?.count ?? 1)){
           cell.backgroundColor = color
           cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)
        }
        cell.accessoryType = todos?[indexPath.row].done ?? false ? .checkmark : .none
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todos?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                
            }
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    //MARK: - Add Todo Item
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        var uiTextField = UITextField()
        let alertController = UIAlertController(title: "Add Todo Item", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
             if let text = uiTextField.text {
                 let item = TodoItem()
                 item.title = text
                 item.done = false
                 if self.category != nil  {
                     self.saveItem(item)
                 }
                     
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
    
    //MARK: - Data manipulation
    
    func loadItems(){
            todos = category?.items.sorted(byKeyPath: "title", ascending: true)
            self.tableView.reloadData()
      
    }
    
    func saveItem(_ item: TodoItem){
        do{
            try self.realm.write{
                self.realm.add(item)
                self.category?.items.append(item)
            }
        }catch{
            print("error \(error)")
        }
    }
    
    override func updateCell(_ indexPath: IndexPath) {
        do{
            try self.realm.write{
                self.realm.delete(self.todos[indexPath.row])
            }
        }catch{
            print("error \(error)")
        }
    }
}

//MARK: -  Search Bar Delegate methods

extension TodoViewController :UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todos = category?.items.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count == 0){
            loadItems()
        }
    }
}
