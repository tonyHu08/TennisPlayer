//
//  NewPlayerController.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2019/1/2.
//  Copyright © 2019 Junwei Hu. All rights reserved.
//

import UIKit
import AVKit
import CoreData

class NewPlayerController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    var nation = [Nation]()

    @IBAction func nationBtn(_ sender: UIButton) {
        self.present(alertNationController, animated: true, completion: nil)
    }
    @IBOutlet weak var nationBtnText: UIButton!

    @IBAction func dateBtn(_ sender: UIButton) {
        self.present(alertDateController, animated: true, completion: nil)
    }
    @IBOutlet weak var dateBtnText: UIButton!

    let alertDateController: UIAlertController = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)

    let alertNationController: UIAlertController = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
    let nationPickerView = UIPickerView()
    let birthPicker = UIDatePicker()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var chinenseNameTextField: UITextField!
    @IBOutlet weak var GSTextField: UITextField!
    @IBOutlet var textField: [UITextField]!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
//    @IBOutlet weak var nationPickerView: UIPickerView!

    @IBOutlet weak var introduceTextView: UITextView!
//    @IBOutlet weak var birthPicker: UIDatePicker!

    @IBAction func playVideo(_ sender: UIButton) {
        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(url: videoUrl)

        self.present(playerVC, animated: true) {
            playerVC.player?.play()
        }
    }

    var videoUrl: URL!
    var nationPickerSelect = "中国"
    var introducePlaceholderText = "在此输入球员简介"
    var nationSelect: [Int] = []


    var continent: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
        GSTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        for textF in textField {
            textF.delegate = self
        }

        //设置textView
        introduceTextView.delegate = self
        introduceTextView.layer.borderWidth = 1
        introduceTextView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        introduceTextView.text = introducePlaceholderText
        introduceTextView.textColor = UIColor.lightGray


        //滑动tableView时隐藏键盘
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag

        //弹出pickerView
        nationPickerAlert()
        birthPickerAlert()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // 按下保存按钮后执行的方法
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        // 判断有没有空白的输入框，有的话则弹出提示框提示
        var textHasNil = false
        for text in textField {
            if !text.hasText {
                textHasNil = true
            }
        }
        if textHasNil {
            alertWarning(title: "提示", message: "请将信息填写完整", btnTitle: "确定")
        } else {
            //将新数据保存进coredata
            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            let player = PlayerMO(context: appDelegate.persistentContainer.viewContext)
            player.name = nameTextField.text!
            player.chineseName = chinenseNameTextField.text!
            player.nation = nationPickerSelect

            if let imageData = headImg.image!.jpegData(compressionQuality: 0.7) {
                player.image = imageData
            }
            player.birth = changeValueDate(datePickerV: birthPicker)
            player.favorate = false
            if introduceTextView.textColor == UIColor.lightGray {
                player.introduce = ""
            } else {
                player.introduce = introduceTextView.text
            }
            player.rating = ""
            if let gs_num = Int64(GSTextField.text!) {
                player.gs_num = gs_num
            } else {
                alertWarning(title: "提示", message: "大满贯数量不能输入数字以外的字符", btnTitle: "确定")
                return
            }

            print("正在保存")
            appDelegate.saveContext()
            
            saveToCloud(player: player)

            self.dismiss(animated: true, completion: nil)
        }
    }

    func saveToCloud(player: PlayerMO) {
        let cloudObject = AVObject(className: "Player")

        cloudObject["name"] = player.name!
        cloudObject["chineseName"] = player.chineseName!
        cloudObject["nation"] = player.nation!
        cloudObject["birth"] = player.birth!
        cloudObject["rating"] = player.rating!
        cloudObject["gs_num"] = player.gs_num
        cloudObject["favorate"] = player.favorate

        let originImg = UIImage(data: player.image!)
        let factor = (originImg!.size.width > 1024) ? (1024 / originImg!.size.width) : 1
        let scaledImg = UIImage(data: player.image!, scale: factor)

        let imgFile = AVFile(name: "\(String(describing: player.name!)).jpg", data: scaledImg!.jpegData(compressionQuality: 0.7)!)

        cloudObject["image"] = imgFile
        
        cloudObject.saveInBackground { (succees, error) in
            if succees {
                print("LeanCloud保存成功！")
            } else {
                print(error ?? "未知错误")
            }
        }
    }

    //返回分区头部视图
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        //headerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: 30)
        headerView.addSubview(blurView)

        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 30))

        switch section {
        case 0:
            label.text = "添加照片"
        case 1:
            label.text = "基本信息"
        default:
            label.text = "个人简介"
        }

        headerView.addSubview(label)

        return headerView
    }

    //弹出国家选择器
    func nationPickerAlert() {
        nationPickerView.delegate = self
        nationPickerView.dataSource = self
        nationPickerView.tag = 10
        let width = tableView.frame.width
        alertNationController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.nationBtnText.setTitle(self.nationPickerSelect, for: .normal)
        }))
        alertNationController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        nationPickerView.frame = CGRect(x: 0, y: 0, width: width, height: 200)

        alertNationController.view.addSubview(nationPickerView)

    }

    //设置日期选择器和弹出日期选择器
    func birthPickerAlert() {
        //设置时间PickerView
        birthPicker.datePickerMode = UIDatePicker.Mode.date
        birthPicker.locale = Locale.init(identifier: "zh_CN")
        birthPicker.setDate(Date(), animated: true)
        birthPicker.addTarget(self, action: #selector(changeValueDate), for: .valueChanged)
        birthPicker.maximumDate = Date()
        self.dateBtnText.titleLabel?.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        //弹出
        let width = alertDateController.view.frame.width
        alertDateController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.dateBtnText.setTitle(self.changeValueDate(datePickerV: self.birthPicker), for: .normal)
        }))
        alertDateController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        birthPicker.frame = CGRect(x: 0, y: 0, width: width, height: 200)

        alertDateController.view.addSubview(birthPicker)

    }

    //以下两个方法都是在实现textview的占位符
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        //此时不可用textView.text == nil来做判断,isEmpty是判断字符串是否为空
        if textView.text.isEmpty {
            textView.text = introducePlaceholderText
            introduceTextView.textColor = UIColor.lightGray
        }
    }

    // 弹出框方法
    func alertWarning(title: String, message: String, btnTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: btnTitle, style: .default) { (action) in
            print("点击了确定")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // 按下键盘的return键后执行的方法
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 按下return后所有输入框都重设第一响应者（重设键盘焦点）
        for textF in self.textField {
            textF.resignFirstResponder()
        }
        // 实现当按下return后焦点向下一个输入框移动
        switch textField.tag {
        case 10:
            chinenseNameTextField.becomeFirstResponder()
        case 11:
            GSTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }

    //获取时间PickerView的选中时间(字符串转时间)
    @objc func changeValueDate(datePickerV: UIDatePicker) -> String {
        //获取当前选中的时间
        let dateE = datePickerV.date

        //转换时间格式
        let formatterR = DateFormatter.init()
        formatterR.dateFormat = "yyyy-MM-dd"
        let dateStr = formatterR.string(from: dateE)
        return dateStr
    }

    func nationNameToNum(nationName: String) -> Array<Int> {
        var i = 0, j = 0

        for continent in nation {
            for nation in continent.countries {
                if nation == nationName {
                    return [i, j]
                }
                j += 1
            }
            i += 1
            j = 0
        }
        return [0, 0]
    }




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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //读取国家数据json
    func loadJson() {
        let coder = JSONDecoder()
        do {
            let url = Bundle.main.url(forResource: "nation", withExtension: "json")!
            let nationData = try Data(contentsOf: url)
            nation = try coder.decode([Nation].self, from: nationData)
        } catch {
            print("编码错误")
        }
    }

}
