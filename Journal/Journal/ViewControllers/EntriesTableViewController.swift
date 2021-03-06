//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Carolyn Lea on 8/9/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController
{
    // MARK: - Properties
    
    let entryController = EntryController()
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        entryController.fetchEntries { (error) in
            if let error = error
            {
                NSLog("problem \(error)")
                return
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return entryController.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        let entry = entryController.entries[indexPath.row]
        
        cell.entry = entry


        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let entry = entryController.entries[indexPath.row]
            entryController.deleteEntry(entry: entry) { (error) in
                if let error = error
                {
                    NSLog("problem \(error)")
                    return
                }
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
    
    // MARK: - Navigation (ShowAddView, ShowEditView)

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowAddView"
        {
            guard let addView = segue.destination as? EntryDetailViewController else {return}
            addView.entryController = entryController
        }
        else if segue.identifier == "ShowEditView"
        {
            guard let editView = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            editView.entryController = entryController
            editView.entry = entryController.entries[indexPath.row]
            
            
        }
    }
    

}
