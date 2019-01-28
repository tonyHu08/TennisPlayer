//
//  ContentViewController.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2019/1/18.
//  Copyright © 2019 Junwei Hu. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var actionButton: UIButton!
    @IBAction func touchActionBtn(_ sender: UIButton) {
        //记录已经显示过
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "guiderShowed")
        self.dismiss(animated: true, completion: nil)
    }
    
    var index = 0
    var titleText = ""
    var image = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.currentPage = index
        if index == 2 {
            actionButton.isHidden = false
        }

        backImage.image = UIImage(named: image)!
        titleLable.text = titleText
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
