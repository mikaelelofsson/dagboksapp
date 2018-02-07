//
//  DetailViewController.swift
//  Dagboksapp
//
//  Created by Mikael Elofsson on 2018-01-29.
//  Copyright © 2018 Mikael Elofsson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: DiaryDetailHeaderView!
    
    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryTextView: UITextView!
    
    var diaryEntry: DiaryEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        
        
        headerView.titleLabel.text = String(diaryEntry.timeStamp)
        headerView.headerImageView.image = UIImage(named:"restuarant")
        
        // MARK: - Table Data Source
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DiaryDetailSubheadCell.self), for: indexPath) as! DiaryDetailSubheadCell
            
            cell.subheadTextLabel.text = "Just a meaningless label"
            
            return cell
            
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:DiaryDetailSubheadCell.self), for: indexPath) as! DiaryDetailSubheadCell
            
            cell.subheadTextLabel.text = "Just a meaningless label"
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DiaryDetailTextCell.self), for: indexPath) as! DiaryDetailTextCell
            cell.entryText.text = diaryEntry.entryText
            
            return cell
            
        default:
            fatalError("Failed")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
