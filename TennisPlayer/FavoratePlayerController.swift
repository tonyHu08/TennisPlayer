//
//  FavoratePlayerController.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2019/1/27.
//  Copyright © 2019 Junwei Hu. All rights reserved.
//

import UIKit

class FavoratePlayerController: UITableViewController {

    var favoratePlayer: [PlayerMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        findFavPlayer(data: TennisPlayerTableViewController.data)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.favoratePlayer.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavPlayerCell", for: indexPath) as! FavoratePlayerCell

        cell.playerImage.image = UIImage(data: favoratePlayer[indexPath.row].image!)
        cell.playerNameLabel.text = favoratePlayer[indexPath.row].name!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detail = storyBoard.instantiateViewController(withIdentifier: "detail") as! DetailController
        detail.player = favoratePlayer[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favAction = UIContextualAction(style: .destructive, title: "取消收藏") { (_, _, completion) in
            self.favoratePlayer[indexPath.row].favorate = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveContext()
            self.favoratePlayer.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        let config = UISwipeActionsConfiguration(actions: [favAction])
        return config
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

    func findFavPlayer(data: [PlayerMO]){
        for player in data {
            if player.favorate {
                self.favoratePlayer.append(player)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("============")
        let row = tableView.indexPathForSelectedRow!.row
        let destination = segue.destination as! DetailController
        destination.player = TennisPlayerTableViewController.data[row]
    }
    

}
