//
//  RateController.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2018/12/29.
//  Copyright © 2018 Junwei Hu. All rights reserved.
//

import UIKit

class RateController: UIViewController {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var rateButton: [UIButton]!
    @IBAction func tapBackground(_ sender: Any) {
        // 点击后视图消失
        self.dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置每个按钮的初始位置
        let startPosition = CGAffineTransform(translationX: 0, y: -400)
        let startSize = CGAffineTransform(scaleX: 0.5, y: 0.5)
        rateLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        rateLabel.alpha = 0
        for button in rateButton {
            button.alpha = -1
            button.transform = startPosition.concatenating(startSize)
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        UIViewPropertyAnimator(duration: 0.3, curve: .easeIn, animations: {
            self.rateLabel.transform = .identity
            self.rateLabel.alpha = 1
        }).startAnimation()
        for i in 0...4 {
            let delay = Double(Double(i) / 20.0)
            UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.6) {
                self.rateButton[i].transform = .identity
                self.rateButton[i].alpha = 1
            }.startAnimation(afterDelay: delay)
        }
    }

    // 拖动stackView
    @IBAction func dragStackVIew(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: view)
            let position = CGAffineTransform(translationX: 0, y: translation.y)
            stackView.transform = position
        case .ended:
            UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.6) {
                self.stackView.transform = .identity
                }.startAnimation()
        default:
            break
        }
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
