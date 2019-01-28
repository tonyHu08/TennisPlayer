//
//  DetailController.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2018/12/28.
//  Copyright © 2018 Junwei Hu. All rights reserved.
//

import UIKit
import CoreData

class DetailController: UITableViewController {


    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet var buttons: [UIButton]!

    var player: PlayerMO!

    var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        headerImageView.image = UIImage(data: player.image!)
        if (player.rating != "") {
            let tennisEmoji = makeRateTennis(player.rating!)
            rateBtn.setTitle("评分：\(tennisEmoji)", for: .normal)
        }
        // 设置导航栏样式
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.barTintColor = nil
        // 将表头设为表面表头
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        // 表上留出边距
        tableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
        //设置按钮样式
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.barTintColor = nil
        headerImageView.image = UIImage(data: player.image!)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        headerView.frame = CGRect(x: 0, y: offSetY, width: tableView.bounds.width, height: -offSetY)
    }

    // 状态栏字体颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = String(describing: DetailCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DetailCell
        //去除cell的点击变色效果
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "姓名"
            cell.valueLabel.text = player.name
        case 1:
            cell.keyLabel.text = "译名"
            cell.valueLabel.text = player.chineseName
        case 2:
            cell.keyLabel.text = "国籍"
            cell.valueLabel.text = player.nation
        case 3:
            cell.keyLabel.text = "生日"
            cell.valueLabel.text = player.birth
        case 4:
            cell.keyLabel.text = "大满贯数量"
            cell.valueLabel.text = player.gs_num.description
        case 5:
            cell.keyLabel.isHidden = true
            if (player.introduce?.isEmpty)! {
                cell.valueLabel.text = "暂无简介"
            } else {
                cell.valueLabel.text = player.introduce
            }
        default:
            break
        }

        return cell
    }


    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }

    // 在RateController页返回后
    @IBAction func backToDetail(segue: UIStoryboardSegue) {
        if let rating = segue.identifier {
            player.rating = rating
            let tennisEmoji = makeRateTennis(rating)
            rateBtn.setTitle("评分：\(tennisEmoji)", for: .normal)
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }

    // 根据评分分数设置🎾个数
    func makeRateTennis(_ rating: String) -> String {
        let ratingNum = Int(rating)!
        var tennisEmoji = ""
        for _ in 1...ratingNum {
            tennisEmoji += "🎾"
        }
        return tennisEmoji
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }



//    // 用UIColor制作UIImage
//    func generateImageWith(_ color: UIColor, andFrame frame: CGRect) -> UIImage? {
//        // 开始绘图
//        UIGraphicsBeginImageContext(frame.size)
//
//        // 获取绘图上下文
//        let context = UIGraphicsGetCurrentContext()
//        // 设置填充颜色
//        context?.setFillColor(color.cgColor)
//        // 使用填充颜色填充区域
//        context?.fill(frame)
//
//        // 获取绘制的图像
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//
//        // 结束绘图
//        UIGraphicsEndImageContext()
//        return image
//    }

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
        if segue.identifier == "EditPlayerInfo" {
            let distination = segue.destination as! EditPlayerController
            distination.player = player
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
