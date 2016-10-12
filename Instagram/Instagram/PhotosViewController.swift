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
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 320
        self.tableView.addSubview(refreshControl)
        
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
                                //self.refreshControl.endRefreshing()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        
        
        // user name
//        let user = self.photos[indexPath.section]["user"] as! NSDictionary
        // photo
        let image = self.photos[indexPath.section]["images"] as! NSDictionary
        let lowResolution = image["low_resolution"] as! NSDictionary
        
//        
        cell.photoImageView.setImageWith(URL(string: lowResolution["url"] as! String)!)
//        cell.userNameLabel.text = user["username"] as? String
//        cell.avatarImageView.setImageWith(URL(string: user["profile_picture"] as! String)!)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let avatarImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 15
        avatarImage.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        avatarImage.layer.borderWidth = 1
        // user name
        let user = self.photos[section]["user"] as! NSDictionary
        avatarImage.setImageWith(URL(string: user["profile_picture"] as! String)!)

        headerView.addSubview(avatarImage)
        return headerView
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexPath = self.tableView.indexPathForSelectedRow
        
        let image = self.photos[(indexPath?.section)!]["images"] as! NSDictionary
        let lowResolution = image["low_resolution"] as! NSDictionary

        let nextVC = segue.destination as! PhotoDetailsViewController
        
        nextVC.photoURL = lowResolution["url"] as! String
        
        
        
        
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
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
    

}
