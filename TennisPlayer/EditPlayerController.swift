//
//  EditPlayerController.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2019/1/17.
//  Copyright © 2019 Junwei Hu. All rights reserved.
//

import UIKit

class EditPlayerController: NewPlayerController {
    
    @IBAction func nationEditBtn(_ sender: UIButton) {
        present(alertNationEditController, animated: true, completion: nil)
    }
    @IBAction func dateEditBtn(_ sender: UIButton) {
        present(alertDateEditController, animated: true, completion: nil)
    }
    
    let alertDateEditController: UIAlertController = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
    
    let alertNationEditController: UIAlertController = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)

    @IBOutlet weak var navigate: UINavigationItem!
    var player: PlayerMO!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏样式
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "theme")

        nameTextField.text = player.name
        chinenseNameTextField.text = player.chineseName
        GSTextField.text = String(player.gs_num)
        if player.introduce!.isEmpty {
            introduceTextView.text = introducePlaceholderText
        } else {
            introduceTextView.text = player.introduce
            introduceTextView.textColor = UIColor.black
        }
        
        nationEditPickerAlert()
        birthEditPickerAlert()
        
        headImg.image = UIImage(data: player.image!)
        birthPicker.date = string2Date(player.birth!)
        nationBtnText.setTitle(player.nation, for: .normal)
        dateBtnText.setTitle(player.birth, for: .normal)
        nationPickerSelect = player.nation!
        nationSelect = nationNameToNum(nationName: player.nation!)
        nationPickerView.selectRow(nationSelect[0], inComponent: 0, animated: false)
        nationPickerView.selectRow(nationSelect[1], inComponent: 1, animated: false)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 设置导航栏样式
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "theme")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    

    override func saveBtn(_ sender: UIBarButtonItem) {
        // 判断有没有空白的输入框，有的话则弹出提示框提示
        var textHasNil = false
        for text in textField {
            if !text.hasText {
                textHasNil = true
            }
        }
        //如果信息完整
        if textHasNil {
            alertWarning(title: "提示", message: "请将信息填写完整", btnTitle: "确定")
        } else {
            player.name = nameTextField.text!
            player.chineseName = chinenseNameTextField.text!
            player.nation = nationPickerSelect
            if introduceTextView.textColor == UIColor.lightGray {
                player.introduce = ""
            } else {
                player.introduce = introduceTextView.text
            }
            if let imageData = headImg.image!.jpegData(compressionQuality: 1.0) {
                player.image = imageData
            }
            if let gs_num = Int64(GSTextField.text!) {
                player.gs_num = gs_num
            } else {
                alertWarning(title: "提示", message: "大满贯数量不能输入数字以外的字符", btnTitle: "确定")
            }
            player.birth = changeValueDate(datePickerV: birthPicker)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveContext()
    
            self.navigationController?.popViewController(animated: true)
            print("修改成功")
        }
    }

    func string2Date(_ string: String, dateFormat: String = "yyyy-MM-dd") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date!
    }
    
    func birthEditPickerAlert() {
        //设置时间PickerView
        birthPicker.datePickerMode = UIDatePicker.Mode.date
        birthPicker.locale = Locale.init(identifier: "zh_CN")
        birthPicker.setDate(Date(), animated: true)
        birthPicker.addTarget(self, action: #selector(changeValueDate), for: .valueChanged)
        birthPicker.maximumDate = Date()
        self.dateBtnText.titleLabel?.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        //弹出
        let width = alertDateController.view.frame.width
        alertDateEditController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.dateBtnText.setTitle(self.changeValueDate(datePickerV: self.birthPicker), for: .normal)
        }))
        alertDateEditController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        birthPicker.frame = CGRect(x: 0, y: 0, width: width, height: 200)
        
        alertDateEditController.view.addSubview(birthPicker)
    }
    
    func nationEditPickerAlert() {
        nationPickerView.delegate = self
        nationPickerView.dataSource = self
        nationPickerView.tag = 10
        let width = tableView.frame.width
        alertNationEditController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.nationBtnText.setTitle(self.nationPickerSelect, for: .normal)
        }))
        alertNationEditController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        nationPickerView.frame = CGRect(x: 0, y: 0, width: width, height: 200)
        
        alertNationEditController.view.addSubview(nationPickerView)
    }

    // MARK: - Table view data source



    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        print("开始跳转！")
        let distination = segue.destination as! DetailController
        distination.player = player
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
