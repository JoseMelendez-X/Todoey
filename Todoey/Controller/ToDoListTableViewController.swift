//
//  ToDoListTableViewController.swift
//  Todoey
//
//  Created by Jose Melendez on 3/16/18.
//  Copyright © 2018 Jose Melendez. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController{
    
    // MARK: - Properties

    var itemArray = [Item]()
    var selectedCategory: Category?{
        didSet{
            loadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a table view cell object
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//      itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //context.delete must be called before itemArray.remove
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
     
  
        //updates the data, must be called
        saveItems()
        
        //removes the gray highlighting of a cell
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //local variable
        var textField = UITextField()
        
        //alert controller
        let alert = UIAlertController(title: "Add Todoey item", message: "", preferredStyle: .alert)
        
        //alert action
        let alertAction = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            //add new item to itemArray
             self.itemArray.append(newItem)
            //save the new item
            self.saveItems()
        }
        //add action to alert
        alert.addAction(alertAction)
        
        //add text field to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
        }
        
        //present alert controller
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    func saveItems() {
        
        //creates data (saves) for our database
        do {
            try context.save()
        } catch {
            print("error saving context \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        //talk to the context
        do{
        itemArray = try context.fetch(request) //returns an NSFetchRequestResult, which is an array of Item
        }catch {
            print("Error fetching data from our context: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}

// MARK: - SearchBar Methods

extension ToDoListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sort data you get back
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //sorts alphabetically
        
        loadData(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

