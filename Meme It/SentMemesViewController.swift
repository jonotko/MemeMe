//
//  ViewController.swift
//  Meme It
//
//  Created by Jonathan Agarrat on 12/3/15.
//  Copyright © 2015 Jenius. All rights reserved.
//

import UIKit

var memes = [MemeObject]()

class SentMemesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var sentMemesTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sentMemesTableView.delegate = self
        
        sentMemesTableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print(memes.count)
        
        sentMemesTableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")
        
        let meme = memes[indexPath.row]
        
        cell?.textLabel?.text = meme.topText
        cell?.imageView?.image = meme.memedImage
        
        return cell!
    }

   


}

