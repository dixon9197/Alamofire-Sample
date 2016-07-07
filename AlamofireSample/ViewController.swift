//
//  ViewController.swift
//  AlamofireSample
//
//  Created by dixon on 16/7/7.
//  Copyright © 2016年 Monaco1. All rights reserved.
//

import UIKit
import Alamofire
import MRProgress
import KFSwiftImageLoader

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tv:UITableView!
    var imageUrls:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let overlay = MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        
        let request = Alamofire.request(.GET, "http://52.74.254.34/api/merchant-api.php?a=merchant_categories")
        request.responseJSON { (response:Response) in
            
            if response.result.isSuccess {
               
                if let value = response.result.value {
                    
                    if value is [String:AnyObject] {
                        
                        let dataArr = value["Data"]
                        
                        if dataArr is [AnyObject] {

                            for objects in dataArr as! [AnyObject] {
                                
                                if objects is [String:AnyObject] {
                                    
                                    let resultDic:[String:AnyObject] = objects as! [String:AnyObject]
                                    
                                    if let data = resultDic["cat_image"] {
                                        
                                        if data is String {
                                            
                                            let utf8String = data.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
   
                                            if let utf8String = utf8String {
                                                self.imageUrls.append(utf8String)

                                            }
                                            
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }
                overlay.mode = MRProgressOverlayViewMode.Checkmark
            }else{
                overlay.mode = MRProgressOverlayViewMode.Cross
            }
            self.tv.reloadData()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                overlay.dismiss(true)
            }
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //tableview delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let imageUrl = imageUrls[indexPath.row]
        let iv:UIImageView = cell.viewWithTag(100) as! UIImageView
        iv.loadImageFromURLString(imageUrl)
        
        return cell
    }
}

