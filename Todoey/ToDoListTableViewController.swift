//
//  ToDoListTableViewController.swift
//  Todoey
//
//  Created by Jose Melendez on 3/16/18.
//  Copyright © 2018 Jose Melendez. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    
    // MARK: - Properties

    var itemArray = [Item]()
    var defaults = UserDefaults.standard
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
     guard let items = defaults.array(forKey: "itemArray") as? [Item] else {return}
       itemArray = items
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
  
        tableView.reloadData()
        
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
            //create a new item
            let newItem = Item()
            newItem.title = textField.text!
            //add new item to itemArray
             self.itemArray.append(newItem)
            print(self.itemArray.count)
            //save to userDefaults
            self.defaults.set(self.itemArray, forKey: "itemArray")
            //reload the new data added to itemArray
            self.tableView.reloadData()
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
}
