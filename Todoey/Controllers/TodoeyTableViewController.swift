//
//  ViewController.swift
//  Todoey
//
//  Created by DP on 10/05/18.
//  Copyright © 2018 nimitha. All rights reserved.
//

import UIKit

class TodoeyTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let plistFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find shoes"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "buy milk"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Buy Groceries"
        itemArray.append(newItem3)
        
        loadItems()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - tableview DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark:.none
        return cell
    }
    
    //MARK - tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  //MARK - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        let alerAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(alerAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: plistFilePath!)
        }catch{
            print("Error while encoding item array \(error)")
        }
         self.tableView.reloadData()
    }
    
    func loadItems(){
        
        do{
            if let data = try? Data(contentsOf: plistFilePath!){
             let decoder = PropertyListDecoder()
               itemArray = try decoder.decode([Item].self, from: data)
            }
        }catch{
            print("error while decoding data \(error)")
        }
        
        self.tableView.reloadData()
    }
    
}

