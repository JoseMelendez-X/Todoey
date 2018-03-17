//
//  ToDoListTableViewController.swift
//  Todoey
//
//  Created by Jose Melendez on 3/16/18.
//  Copyright © 2018 Jose Melendez. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {

    var itemArray = ["Jose", "Eddie", "James"]
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a table view cell object
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //add checkmark at the selected cell
        let cellAtIndex = tableView.cellForRow(at: indexPath)
        
        if cellAtIndex?.accessoryType == .checkmark {
            cellAtIndex?.accessoryType = .none
        } else {
            cellAtIndex?.accessoryType = .checkmark
        }
        
        
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
            //add new item to itemArray
            textField.text == "" ? textField.text = "" : self.itemArray.append(textField.text!)
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
