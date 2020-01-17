//
//  ProfileViewController.swift
//  Loompa
//
//  Created by Brian Griffin on 1/17/20.
//  Copyright © 2020 swiftapprentice. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var artistDescription: UITextView!
    
    var imageURL = ""
    var profile = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: imageURL)
        let imageData = try! Data(contentsOf: url!)

        let image = UIImage(data: imageData)

        // Do any additional setup after loading the view.
        
        profileImage.image = image
        artistDescription.text = profile
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
