//
//  ViewController.swift
//  OpenCVSwift
//
//  Created by Rashed Sahajee on 25/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var openCV = OpenCVWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.detectLine()
    }
    
    func detectLine() {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let uiimage = UIImage(named: "court.jpg") else {return}
            
            let result = OpenCVWrapper.lineDectection(uiimage)
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = result
            }
        
            
        }
    }

}

