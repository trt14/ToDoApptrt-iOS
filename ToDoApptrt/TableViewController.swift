//
//  TableViewController.swift
//  ToDoApptrt
//
//  Created by Tarooti on 23/05/1443 AH.
//


import UIKit
import CoreData

struct Notes{
    let title: String
    let notes: String
    let date: String
    var isChecked: Bool?
}

class TableViewController: UITableViewController {

    var allNotes: [NotesEntity] = []


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        fetchAllNotes()

    }
    // makes our cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! ToDoCell
        cell.lblTitle.text = allNotes[indexPath.row].title
        cell.lblNote.text = allNotes[indexPath.row].notes
        cell.lblDate.text = allNotes[indexPath.row].date
        cell.isChecked.isHidden = allNotes[indexPath.row].isHidden
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        updateItem(path: indexPath.row)
        
        tableView.reloadData()
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        deleteItem(path: indexPath.row)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let navController = segue.destination as? UINavigationController else {return}
        if let formVC = navController.topViewController as? FormViewController{
            
            formVC.formVCDelegate = self
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "show", sender: sender)
    }
    //rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }
    
    func getUpdatedContext()->NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext

    }
    func fetchAllNotes(){
        let context = getUpdatedContext()
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesEntity")

        do{
            let results = try context.fetch(itemRequest)
            allNotes = results as! [NotesEntity]
        }catch{
            
            print(error.localizedDescription)
        }

    }
    func addItem(title: String, note: String, date: String, isHidden: Bool){
        let context = getUpdatedContext()
        let noteEntity = NotesEntity.init(context: context)
        noteEntity.title = title
        noteEntity.notes = note
        noteEntity.date = date
        noteEntity.isHidden = isHidden
        
        allNotes.append(noteEntity)
        
        do{
            //finally saving the context so the item
            //is persisted
            try context.save()
        }catch{
            
            print(error.localizedDescription)
        }
        
    }
    func updateItem(path: Int){
        let context = getUpdatedContext()
        
        allNotes[path].isHidden.toggle()
        

        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }


    }
    func deleteItem(path: Int){
        let context = getUpdatedContext()
        
        context.delete(allNotes[path])
        allNotes.remove(at: path)
        
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
        
        
    }

   

}
extension TableViewController: FormViewDelegate{
    func addItemPressed(title: String, notes: String, date: String) {
        
        addItem(title: title, note: notes, date: date, isHidden: true)
        tableView.reloadData()
        
        
    }
    
    func cancelButtonPressed(with viewContoller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
