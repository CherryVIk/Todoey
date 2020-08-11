//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Victoria Boichenko on 06.08.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()

        
    }
  
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
       
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added"
        
        return cell
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func saveCategories(category : Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("Error adding category in realm")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let category = alert.textFields![0]
            if category.text?.count != 0 {
                let newCategory = Category()
                newCategory.name = category.text!
                self.saveCategories(category: newCategory)
            }
           

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
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}

