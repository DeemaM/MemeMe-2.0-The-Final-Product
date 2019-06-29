//
//  MemeCollectionViewController.swift
//  Meme1.0
//
//  Created by Deema  on 04/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    
     var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (view.frame.size.height - (2 * space))/3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: heightDimension)
    }
    
    @IBAction func addButton(_ sender: Any) {
        let viewcontroller = storyboard!.instantiateViewController(withIdentifier: "ViewController")
        navigationController?.pushViewController(viewcontroller, animated: true)
    }
    


   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectonViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.imageView.image = meme.originalImage
        cell.topLabel.text = meme.topTextField
        cell.bottomLabel.text = meme.bottomTextField
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentMeme = memes[indexPath.row]
        let viewcontroller = self.storyboard!.instantiateViewController(withIdentifier: "MemeDisplayImage") as! MemeDisplayImage
        viewcontroller.meme = currentMeme
        navigationController!.pushViewController(viewcontroller, animated: true)
        
    }

}

