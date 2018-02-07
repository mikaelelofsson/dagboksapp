//
//  DiaryTableViewController.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-26.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit

class DiaryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var diaryTableView: UITableView!
    var diaryEntriesFeed = [DiaryEntry]()
    fileprivate var isLoadingEntries = false
    
    //Created for testing
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRecentEntries()
    }
    
    fileprivate func loadRecentEntries() {

        isLoadingEntries = true
        
        //Gettings entries from the database and stores them in to an array
        
        PostService.shared.downloadLatestEntries(startTime: diaryEntriesFeed.first?.timeStamp, limit: 10){ (newEntries) in

                if newEntries.count > 0 {
                    self.diaryEntriesFeed.insert(contentsOf: newEntries, at:0)
                }
                self.isLoadingEntries = false
            self.displayEntries(newEntries:newEntries)
    }
    }
    
        func displayEntries(newEntries:[DiaryEntry]) {
        
            guard newEntries.count > 0 else {return}
            
            //Display the entries in the table view
            
            var indexPaths:[IndexPath] = []
            self.diaryTableView.beginUpdates()
            
            for num in 0...(newEntries.count-1){
                let indexPath = IndexPath(row: num, section:0)
                indexPaths.append(indexPath)
            }
            
            self.diaryTableView.insertRows(at:indexPaths, with: .fade)
            self.diaryTableView.endUpdates()
            
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return diaryEntriesFeed.count
    }

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DiaryTableViewCell

        // Configure the cell...
        cell.entryLabel.text = String(diaryEntriesFeed[indexPath.row].timeStamp)
        cell.thumbnailImageView.image = UIImage(named:"restaurant")
        cell.previewLabel.text = diaryEntriesFeed[indexPath.row].entryText

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
  
        //När användaren synliggör de två sista cellerna i listan så ska nya objekt laddas från firebase
        guard !isLoadingEntries, diaryEntriesFeed.count - indexPath.row == 2 else {
            return
        }
        
        isLoadingEntries = true
        
        guard let lastEntryTimestamp = diaryEntriesFeed.last?.timeStamp else {
            isLoadingEntries = false
            return
        }
        
        PostService.shared.getOldEntries(startTime: lastEntryTimestamp, limit: 3) { (newEntries) in
            
            var indexPaths:[IndexPath] = []
            self.diaryTableView.beginUpdates()
            
            for newEntry in newEntries {
                self.diaryEntriesFeed.append(newEntry)
                let indexPath = IndexPath(row:self.diaryEntriesFeed.count-1, section: 0)
                indexPaths.append(indexPath)
            }
            
            self.diaryTableView.insertRows(at: indexPaths, with: .fade)
            self.diaryTableView.endUpdates()
            
            self.isLoadingEntries = false
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
//
//        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler:nil)
//
//
//        let editActionHandler = { (action:UIAlertAction!) -> Void in
//            let alertMessage = UIAlertController(title:"Not yet connected", message:"This is not yet connected to editing view", preferredStyle: .alert)
//            alertMessage.addAction(UIAlertAction(title:"OK", style:.default, handler:nil))
//            self.present(alertMessage, animated:true, completion: nil)
//        }
//
//        let checkMarkAction = UIAlertAction(title:"Check", style: .default, handler: {
//            (action:UIAlertAction!) -> Void in
//            let cell = tableView.cellForRow(at: indexPath)
//            cell?.accessoryType = .checkmark
//        })
//
//        let editAction = UIAlertAction(title:"Edit", style: .default, handler:editActionHandler)
//
//        optionMenu.addAction(checkMarkAction)
//        optionMenu.addAction(editAction)
//        optionMenu.addAction(cancelAction)
//
//        present(optionMenu, animated:true, completion:nil)
//
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDiaryDetail" {
            if let indexPath  = diaryTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! DetailViewController
                destinationController.diaryEntry = diaryEntriesFeed[indexPath.row]
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
