//
//  GuideViewController.swift
//  TennisPlayer
//
//  Created by JunWei Hu on 2019/1/18.
//  Copyright © 2019 Junwei Hu. All rights reserved.
//

import UIKit

class GuideViewController: UIPageViewController, UIPageViewControllerDataSource {

    let backImage = ["federer7", "GS", "nadal2"]
    let titleText = ["添加和查看你喜爱的球员信息", "添加和查看赛事安排", "分享你所爱"]



    override func viewDidLoad() {
        super.viewDidLoad()
        print("================")

        dataSource = self
        if let startVC = vc(atIndex: 0) {
            setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
    }


    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        print("before")
        return vc(atIndex: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        print("after")
        return vc(atIndex: index)
    }

    func vc(atIndex: Int) -> ContentViewController? {
        if atIndex >= 0 && atIndex <= 2 {
            print("vc")
            if let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentController") as? ContentViewController {
                contentVC.image = backImage[atIndex]
                contentVC.titleText = titleText[atIndex]
                contentVC.index = atIndex

                return contentVC
            }
        }
        return nil
    }
    
//    添加页码
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return backImage.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 0
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
