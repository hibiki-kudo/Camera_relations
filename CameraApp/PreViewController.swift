//
//  PreViewController.swift
//  CameraApp
//
//  Created by 工藤 響 on 2018/10/28.
//  Copyright © 2018 工藤 響. All rights reserved.
//

import UIKit

class PreViewController: UIViewController {

    var image = UIImage()
    
    @IBOutlet var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageView.image = image
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func SaveImage(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true,completion: nil)
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
