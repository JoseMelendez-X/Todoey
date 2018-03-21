//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Jose Melendez on 3/20/18.
//  Copyright © 2018 Jose Melendez. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadData()
    }
    
    //Model
    var categories = [Category]()
    
    //Get the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var text = UITextField()
        
        //create alert
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        //create an action for the alert
        let action = UIAlertAction(title: "add category", style: .default) { (action) in
            //perform action when user taps add category button
            let newCategory = Category(context: self.context)
            newCategory.name = text.text!
            self.categories.append(newCategory)
            self.saveData()
            self.tableView.reloadData()
        }
        //add textfield to alert
        alert.addTextField { (textField) in
            textField.placeholder = "category name"
            text = textField
        }
        //add action to alert
        alert.addAction(action)
        //present alert to the user
        present(alert, animated: true, completion: nil)
        
    }
    

    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ToDoListTableViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories[indexPath.row]
            }
        }
    }
    
    //MARK: - Data Manipulation - CRUD
    
    //Save aka Create data to the database
    func saveData() {
        do {
            try context.save()
        } catch {
            print("could not save data: \(error.localizedDescription)")
        }
    }
    
    //Read data fromt the database
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    do {
          categories = try context.fetch(request)
        }catch {
            print("Could not fetch requested category: \(error.localizedDescription)")
        }
    }
    
}
