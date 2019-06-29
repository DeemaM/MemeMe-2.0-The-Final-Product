//
//  MemeDisplayImage.swift
//  Meme1.0
//
//  Created by Deema  on 04/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit


class MemeDisplayImage: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
    }

}
