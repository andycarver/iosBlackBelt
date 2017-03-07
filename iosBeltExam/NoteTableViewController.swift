//
//  NoteTableViewController.swift
//  iosBeltExam
//
//  Created by Andrew Carver on 1/27/17.
//  Copyright © 2017 Andrew Carver. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController, UISearchResultsUpdating {

    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    var notes = [Note]()
    var filteredNotes = [Note]()
    
    @IBAction func addNotePressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotes()
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getNotes()
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredNotes = self.notes.filter { (note) -> Bool in
            if(note.name?.lowercased().contains(self.searchController.searchBar.text!.lowercased()))!{
                return true
            } else{
                return false
            }
        }
        self.resultsController.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            let note = notes[indexPath.row]
            let controller = segue.destination as! EditNoteViewController
            controller.noteToEdit = note
        }
    }
    
    func getNotes(){
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortByNewest = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortByNewest]
        do{
            let results = try context.fetch(fetchRequest)
            notes = results
            tableView.reloadData()
        }catch {
            print(error)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.tableView {
            return notes.count
        } else {
            return self.filteredNotes.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
            cell.textLabel?.text = notes[indexPath.row].name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let strNoteDate = notes[indexPath.row].date!
            let noteDate = dateFormatter.string(from: strNoteDate as Date)
            cell.detailTextLabel?.text = noteDate
            return cell
        } else{
            let cell = UITableViewCell()
            cell.textLabel?.text = filteredNotes[indexPath.row].name
            return cell
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            context.delete(note)
            ad.saveContext()
            
            do {
                notes = try context.fetch(Note.fetchRequest())
            }
            catch {
                print("fetch failed")
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editSegue", sender: indexPath)
    }
   
}
