//
//  TennisPlayerTableViewController.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2018/12/27.
//  Copyright © 2018 Junwei Hu. All rights reserved.
//

import UIKit
import CoreData

class TennisPlayerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    static var data: [PlayerMO] = []
    var fc: NSFetchedResultsController<PlayerMO>!
    var sc: UISearchController!

    var searchResult: [PlayerMO] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        // 将大标题和小标题设置为主题色
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "theme")!
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "theme")!
        ]

        //设置tabBar,部分设置在appdelegate里
        tabBarController?.tabBar.tintColor = UIColor.black
        navigationController?.visibleViewController?.title = "球员"

        //实现搜索框的显示
        sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.searchBar.delegate = self
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.barTintColor = UIColor(named: "themeGray")
        sc.searchBar.tintColor = UIColor.gray
        sc.searchBar.placeholder = "输入球员名字进行搜索"
        tableView.tableHeaderView = sc.searchBar



        //防止tableview因为reloadData乱跳
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;


        //滑动tableView时隐藏键盘
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag

        // 设置导航栏背景色
        // navigationController?.navigationBar.barTintColor = bgcolor
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchAllData()
        tableView.reloadData()
        //将detail页设置的导航样式还原
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //默认隐藏搜索框
        //tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: UITableView.ScrollPosition.top, animated: false)

        //显示引导页
        let defaults = UserDefaults.standard

        if !defaults.bool(forKey: "guiderShowed") {
            if let pageVC = storyboard?.instantiateViewController(withIdentifier: "GuideController") as? GuideViewController {
                self.present(pageVC, animated: true, completion: nil)
            } else {
                print("引导页加载失败")
            }
        }
    }

    //实现搜索框的搜索
    func searchFilter(text: String) {
        searchResult = TennisPlayerTableViewController.data.filter({ (data) -> Bool in
            if sc.isActive {
                sc.searchBar.searchBarStyle = .default
            }
            if data.name!.localizedCaseInsensitiveContains(text) {
                return data.name!.localizedCaseInsensitiveContains(text)
            } else {
                return data.chineseName!.localizedCaseInsensitiveContains(text)
            }
        })
    }

    //UISearchResultsUpdating协议所遵从的方法
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text {
            text = text.trimmingCharacters(in: .whitespaces)
            searchFilter(text: text)
            tableView.reloadData()
        }
    }

    //点击搜索按钮后
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        sc.searchBar.searchBarStyle = .minimal
//    }

    //点击取消按钮后
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        sc.searchBar.searchBarStyle = .minimal

    }

    //爱心按钮
    @IBAction func favBtn(_ sender: UIButton) {
        // 得到按钮在父容器中的坐标
        let btnPos = sender.convert(CGPoint.zero, to: self.tableView)
        // 通过坐标得出按钮位于第几个section
        let indexPath = tableView.indexPathForRow(at: btnPos)!
        TennisPlayerTableViewController.data[indexPath.row].favorate = !TennisPlayerTableViewController.data[indexPath.row].favorate
        let cell = tableView.cellForRow(at: indexPath) as! CardCell
        cell.favorate = TennisPlayerTableViewController.data[indexPath.row].favorate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .none)
        default:
            tableView.reloadData()
        }

        if let object = controller.fetchedObjects {
            TennisPlayerTableViewController.data = object as! [PlayerMO]
        }
    }

    //取回coredata中的数据
    func fetchAllData() {
        //从储存中检索数据
        let request: NSFetchRequest<PlayerMO> = PlayerMO.fetchRequest()
        //排序，以名称升序排序
        let sd = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sd]

        //获取上下文
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //NSFetchedResultsController使数据在刷新的时候只刷新部分
        fc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fc.delegate = self

        do {
            //获取数据，把查询到的数据放入数组中
            try fc.performFetch()
            if let object = fc.fetchedObjects {
                TennisPlayerTableViewController.data = object
            }
        } catch {
            print(error)
        }
    }

//    原生的获取coredata的方法
//    func fetchAllData() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        do {
//            TennisPlayerTableViewController.data = try appDelegate.persistentContainer.viewContext.fetch(PlayerMO.fetchRequest())
//        } catch {
//            print(error)
//        }
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sc.isActive ? searchResult.count : TennisPlayerTableViewController.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        let player = sc.isActive ? searchResult : TennisPlayerTableViewController.data

        cell.nameLabel.text = player[indexPath.row].name
        cell.ChineseNameLabel.text = player[indexPath.row].chineseName
        cell.nationLabel.text = player[indexPath.row].nation
        cell.background.image = UIImage(data: player[indexPath.row].image!)
        cell.favorate = player[indexPath.row].favorate
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { (_, _, completion) in
//            原生的表格删除单元格的方法
//            TennisPlayerTableViewController.data.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            let alertController = UIAlertController(title: "确定要删除吗？", message: nil, preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { (UIAlertAction) in
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext

                context.delete(self.fc.object(at: indexPath))
                appDelegate.saveContext()
                completion(true)
            }))
            self.present(alertController, animated: true, completion: nil)


        }

        let shareAction = UIContextualAction(style: .normal, title: "分享") { (_, _, completion) in
            let image = UIImage(data: TennisPlayerTableViewController.data[indexPath.row].image!)!
            let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(ac, animated: true)

            completion(true)
        }
        shareAction.backgroundColor = UIColor.orange

        let config = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return config
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlayerDetail" {
            let row = tableView.indexPathForSelectedRow!.row
            let destination = segue.destination as! DetailController
            destination.player = sc.isActive ? searchResult[row] : TennisPlayerTableViewController.data[row]
            sc.searchBar.searchBarStyle = .minimal
            sc.searchBar.endEditing(true)
            sc.isActive = false
        }
    }

    //读取json数据
//    func loadJson() {
//        let coder = JSONDecoder()
//        do {
//            let url = Bundle.main.url(forResource: "player", withExtension: "json")!
//            let playerData = try Data(contentsOf: url)
//            //TennisPlayerTableViewController.data = try coder.decode([PlayerMO].self, from: playerData)
//        } catch {
//            print("编码错误")
//        }
//    }

    //    将数据转为json
    //    func saveToJson() {
    //        let coder = JSONEncoder()
    //        do {
    //            let data = try coder.encode(self.data.player)
    //            let saveURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("player.json")
    //
    //            try data.write(to: saveURL)
    //            print("编码成功:",saveURL)
    //        } catch  {
    //            print("编码错误")
    //        }
    //    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return !sc.isActive
    }


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


    @IBAction func backToHome(segue: UIStoryboardSegue) {

    }

}
