//
//  ViewController.swift
//  Meme It
//
//  Created by Jonathan Agarrat on 12/3/15.
//  Copyright © 2015 Jenius. All rights reserved.
//

import UIKit


class SentMemesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var sentMemesFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var sentMemesCollectionView: UICollectionView!
    
    @IBOutlet weak var sentMemesNavbar: UINavigationItem!
    
    // Get the memes objects from the App Delegate
    
    var memes: [MemeObject] {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 25)!,
            NSStrokeWidthAttributeName: NSNumber(float: -3.0),
        ]

        sentMemesCollectionView.dataSource = self
        
        sentMemesCollectionView.delegate = self
        
        let space: CGFloat = 10.0
        
        let leftMargin: CGFloat = 5.0
        
        let rightMargin: CGFloat = 5.0
        
        let topMargin: CGFloat = 1.0
        
        let bottomMargin: CGFloat = 0
        
        let dimension = (self.view.frame.size.width -  (space + 2 * (leftMargin + rightMargin) )) / 2
        
        sentMemesFlowLayout.minimumInteritemSpacing = space
        
        sentMemesFlowLayout.minimumLineSpacing = space
        
        sentMemesFlowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        sentMemesFlowLayout.sectionInset = UIEdgeInsetsMake(topMargin, leftMargin, bottomMargin, rightMargin)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "appBackground")!)
        
        sentMemesCollectionView.backgroundColor = UIColor().colorWithAlphaComponent(0.0)
        
        //sentMemesCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: "appBackground")!)
        
        navigationController?.navigationBar.barTintColor = UIColorFromHex(0x61827B, alpha: 1.0)
        
        navigationController?.navigationBar.titleTextAttributes = memeTextAttributes
                
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print(memes.count)
        
        sentMemesCollectionView.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCell", forIndexPath: indexPath) as! CustomMemeCell
        
        cell.memedImage.image = memes[indexPath.row].memedImage
        
        return cell
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

   


}

