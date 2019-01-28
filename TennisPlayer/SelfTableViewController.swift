//
//  SelfTableViewController.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2019/1/23.
//  Copyright © 2019 Junwei Hu. All rights reserved.
//

import UIKit

class SelfTableViewController: UITableViewController {

    var sectionContent = [["收藏的球员", "收藏的比赛"], ["在App Store进行评分", "反馈意见"], ["ATP官方网站", " Yammy!"]]
    var links = ["https://www.atptour.com/", "http://www.tonyyam.cn"]

    override func viewDidLoad() {
        super.viewDidLoad()

        let backView = UIView()
        backView.backgroundColor = UIColor(named: "themeGray")
        tableView.backgroundView = backView


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selfCell", for: indexPath)
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        //去除最后一个cell的分割线
        if indexPath.row == 1 && indexPath.section == 2 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.frame.width)
        }
        return cell
    }


//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 15)
//        headerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//
//        return headerView
//    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(15)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                performSegue(withIdentifier: "showFavPlayer", sender: self)
            }
        case 2:
            performSegue(withIdentifier: "showWebView", sender: self)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            let destination = segue.destination as! WebViewController
            let row = tableView.indexPathForSelectedRow!.row

            destination.url = URL(string: links[row])
        }
    }


}
