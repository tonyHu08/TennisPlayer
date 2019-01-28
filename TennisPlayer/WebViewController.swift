//
//  WebViewController.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2019/1/23.
//  Copyright © 2019 Junwei Hu. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var url = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = self.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
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
