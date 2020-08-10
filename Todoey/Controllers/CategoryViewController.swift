//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Victoria Boichenko on 06.08.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
//    var categories = ["Category 1","Category 2", "Category 3"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()

        
    }
  
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
       
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func saveCategories(){
        do {
            try context.save()
        } catch  {
            print("Error saving data from context")
        }
        tableView.reloadData()
    }
    func loadCategories(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            // you get data using intermidiary (context) from database
            categoryArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context")
        }
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let category = alert.textFields![0]
            if category.text?.count != 0 {
                let item = Category(context: self.context)
                item.name = category.text!
                self.categoryArray.append(item)
            }
            self.saveCategories()
          
        }
        alert.addTextField { (textField) in
        
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
      }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}

