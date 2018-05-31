//
//  CategoryViewController.swift
//  Todoey
//
//  Created by DP on 17/05/18.
//  Copyright © 2018 nimitha. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableCellViewController {

    var categories: Results<Category>?
    
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour) else{fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: categoryColour, isFlat: true)
            
        }
        
        
        
        return cell
    }
    
    // MARK: - Table view delegates method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK:- Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Enter new category"
        }
        present(alert, animated: true, completion: nil)
    }

    
    
    //Data manipulation methods
    func save(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateTableItem(at indexPath:IndexPath){
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting realm object, \(error)")
            }
            
            
        }
    }
}


