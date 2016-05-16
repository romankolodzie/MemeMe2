//
//  MemeDetailViewController.swift
//  MemeMe2
//
//  Created by Roman Kolodzie on 3/22/16.
//  Copyright © 2016 RomanKolodzie. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = meme.newMemeImage
    }
    

}
