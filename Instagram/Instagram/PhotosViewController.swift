//
//  PhotosViewController.swift
//  Instagram
//
//  Created by CongTruong on 10/12/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    let refreshControl = UIRefreshControl()
    var photos: [NSDictionary] = [NSDictionary]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 320
        
        let userId = "435569061"
        let accessToken = "435569061.c66ada7.d12d19c8687e427591f254586e4f3e47"
        let url = URL(string: "https://api.instagram.com/v1/users/\(userId)/media/recent/?access_token=\(accessToken)")
        
        if let url = url {
            let request = URLRequest(
                url: url,
                cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: nil,
                delegateQueue: OperationQueue.main)
            let task = session.dataTask(
                with: request,
                completionHandler: { (dataOrNil, response, error) in
                    if let data = dataOrNil {
                        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            if let photoData = responseDictionary["data"] as? [NSDictionary] {
                                self.photos = photoData
                                
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                        }
                    }
            })
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        
        // user name
        let user = self.photos[indexPath.row]["user"] as! NSDictionary
        // photo
        let image = self.photos[indexPath.row]["images"] as! NSDictionary
        let lowResolution = image["low_resolution"] as! NSDictionary
        
        
        cell.photoImageView.setImageWith(URL(string: lowResolution["url"] as! String)!)
        cell.userNameLabel.text = user["username"] as? String
        cell.avatarImageView.setImageWith(URL(string: user["profile_picture"] as! String)!)
        
        
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexPath = self.tableView.indexPathForSelectedRow
        
        let image = self.photos[(indexPath?.row)!]["images"] as! NSDictionary
        let lowResolution = image["low_resolution"] as! NSDictionary

        let nextVC = segue.destination as! PhotoDetailsViewController
        
        nextVC.photoURL = lowResolution["url"] as! String
        
        
        
        
    }
    

}
