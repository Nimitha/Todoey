//
//  ViewController.swift
//  Todoey
//
//  Created by DP on 10/05/18.
//  Copyright © 2018 nimitha. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoeyTableViewController: SwipeTableCellViewController{
    
    var todoeyItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory:Category?{
        didSet{
            loadItems()
            
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let coulourHex = selectedCategory?.colour{
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist")}
            
            navigationController?.navigationBar.barTintColor = UIColor(hexString: coulourHex)
        }
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - tableview DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoeyItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoeyItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoeyItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
            }
            
            cell.accessoryType = item.done == true ? .checkmark:.none
        }else{
            cell.textLabel?.text = "No items added yet"
          
        }
        
        return cell
    }
    
    //MARK - tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoeyItems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch{
                print("Error savind item status, \(error)")
            }
        }
       
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  //MARK - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)

        let alerAction = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory{
                
                do{
                    try self.realm.write {
                        let newItem = Item()
                        if let title = textField.text{
                            newItem.title = title
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }                       
                }
                }catch{
                    print("Error saving item to realm \(error)")
                }
            }
      
            self.tableView.reloadData()
            

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(alerAction)
        present(alert, animated: true, completion: nil)
    }
    
   
    
    func loadItems(){        
        todoeyItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    override func updateTableItem(at indexPath:IndexPath){
        if let itemForDeletion = todoeyItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("Error deleting realm object, \(error)")
            }
            
            
        }
    }

}

//MARK:- search bar methods

extension TodoeyTableViewController:UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoeyItems = todoeyItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}

