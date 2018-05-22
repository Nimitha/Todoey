//
//  ViewController.swift
//  Todoey
//
//  Created by DP on 10/05/18.
//  Copyright © 2018 nimitha. All rights reserved.
//

import UIKit
import RealmSwift

class TodoeyTableViewController: UITableViewController {
    
    var todoeyItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory:Category?{
        didSet{
            loadItems()
            
        }
    }
    
    let plistFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    let persistentContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // print(plistFilePath)
       
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoeyItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark:.none
        }else{
            cell.textLabel?.text = "No items added yet"
          
        }
        
        return cell
    }
    
    //MARK - tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        todoeyItems[indexPath.row].done = !todoeyItems[indexPath.row].done
//        saveItems()
//
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  //MARK - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)

        let alerAction = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory{
                
                do{
                    try! self.realm.write {
                        let newItem = Item()
                        if let title = textField.text{
                            newItem.title = title
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
    
    func saveItems(){
       
        do{
          try persistentContext.save()
        }catch{
            print("Error while encoding item array \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func loadItems(){
        
        todoeyItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name!)!)
//
//       if let additionalPredicate = predicate{
//
//           request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//        do{
//        itemArray = try persistentContext.fetch(request)
//        }catch{
//            print("Error fetching data from context \(error)")
//        }
        tableView.reloadData()
    }

}

//MARK:- search bar methods

//extension TodoeyTableViewController:UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request:NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request,predicate: predicate)
//
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//
//}

