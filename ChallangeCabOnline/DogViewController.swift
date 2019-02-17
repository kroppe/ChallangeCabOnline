//
//  DogViewController.swift
//  ChallangeCabOnline
//
//  Created by Robert Andersson on 2019-02-17.
//  Copyright © 2019 Kroppe. All rights reserved.
//

import UIKit

class DogViewController: UIViewController {

    @IBOutlet weak var dogLabel: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    var dog: DogModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backButton.isHidden = false
        dogLabel.text = dog.dogBreed
        dogImageView.image = dog.dogImage
    }
    @IBAction func backButton(_ sender: Any) {
        backButton.isHidden = true
    }
    
}
