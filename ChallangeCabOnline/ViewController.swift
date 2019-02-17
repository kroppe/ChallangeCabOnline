//
//  ViewController.swift
//  ChallangeCabOnline
//
//  Created by Robert Andersson on 2019-02-17.
//  Copyright © 2019 Kroppe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var UIAIView: UIActivityIndicatorView!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogTableView: UITableView!
    var dogs: [DogModel] = []
    var dataService = DataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIAIView.isHidden = false
        self.UIAIView.startAnimating()
        dogTableView.delegate = self
        dogTableView.dataSource = self
        

 
            //dataService.deleteCoreData(){data in print(data) }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        dataService.loadCoreData() {dogs in
            
            self.dogs = dogs
            if(dogs.count != 0) {
                DispatchQueue.main.async {
                    
                    self.dogTableView.reloadData()
                    self.UIAIView.stopAnimating()
                    self.UIAIView.isHidden = true
                }
                
            } else {
                
                self.dataService.getAndSaveData(){
                    self.dataService.loadCoreData() {dogs in
                        self.dogs = dogs
                        if(dogs.count != 0) {
                            DispatchQueue.main.async {
                                self.dogTableView.reloadData()
                                self.UIAIView.stopAnimating()
                                self.UIAIView.isHidden = true
                            }
                        }
                    }
                }
            }
            print(dogs.count)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dogTableView.dequeueReusableCell(withIdentifier: "Cell")
        
            cell?.textLabel?.text = self.dogs[indexPath.row].dogBreed
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.dogImageView.image = self.dogs[indexPath.row].dogImage
            
        }
    }
    

}

