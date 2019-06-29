//
//  TableViewController.swift
//  Meme1.0
//
//  Created by Deema  on 06/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class TableViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    var memes:[Meme]! {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        return appDelegate.memes}
    
    @IBOutlet var memeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.memeTableView.reloadData()
        self.memeTableView.endUpdates()
    }
    
    @IBAction func addButton(_ sender: Any) {
        let viewcontroller = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        navigationController?.pushViewController(viewcontroller,animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMemeTable")!
        cell.imageView!.image = meme.originalImage
        cell.detailTextLabel!.text = meme.topTextField + meme.bottomTextField
        cell.textLabel?.text = ""
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMeme = memes[indexPath.row]
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MemeDisplayImage") as! MemeDisplayImage
        vc.meme = currentMeme
        navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}
