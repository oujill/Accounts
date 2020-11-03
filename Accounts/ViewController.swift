//
//  ViewController.swift
//  Accounts
//
//  Created by JillOU on 2020/11/3.
//  Copyright © 2020 Jillou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var currentyear = Calendar.current.component(.year, from: Date()), currentmonth = Calendar.current.component(.month, from: Date()), currentday = Calendar.current.component(.day, from: Date())//現在的年月日
    var numberOfDays:Int{//這個月有幾天
         let datecomponents = DateComponents(year: currentyear, month: currentmonth)
         guard let date = Calendar.current.date(from: datecomponents) else{return 0}
         let numberOfDays = Calendar.current.range(of: .day, in: .month, for: date)
        return numberOfDays?.count ?? 0
    }
    var numberOfWeek:Int{//這個月1號是星期幾
        let datecomponents = DateComponents(year:currentyear, month: currentmonth)
        guard let date = Calendar.current.date(from: datecomponents) else{return 0}
        return Calendar.current.component(.weekday, from: date)
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //手勢左右滑動觸發
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_ : )))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_ : )))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipe(_ recognizer:UISwipeGestureRecognizer){
        switch recognizer.direction {
        case .left:
            if currentmonth >= 12{
                currentmonth = 1
                currentyear += 1
            }else{
                currentmonth += 1
            }
            collectionView.reloadData()
        case .right:
            if currentmonth <= 1{
                currentmonth = 12
                currentyear -= 1
            }else{
                currentmonth -= 1
            }
            collectionView.reloadData()
        default:
            print("defaulttt")
        }
        //日期超出該越能顯示的日期
        if currentday>numberOfDays{
            currentday = numberOfDays
        }
    }
    
    //日曆的View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDays+numberOfWeek-1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collecioncell", for: indexPath) as! CollectionViewCell
        if indexPath.row<numberOfWeek-1{
            cell.dateLabel.text = ""
        }else{
            cell.dateLabel.text = "\(indexPath.row-numberOfWeek+2)"
        }
        //顯示日曆年月日
        timeLabel.text = "\(currentyear) / \(currentmonth) / \(currentday)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/7, height: collectionView.bounds.width/7)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.row
        currentday = item+2-numberOfWeek
        collectionView.reloadData()
    }
    


}

