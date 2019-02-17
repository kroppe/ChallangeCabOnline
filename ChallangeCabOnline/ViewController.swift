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
    @IBOutlet weak var dogTableView: UITableView!
    var dogs: [DogModel] = []
    var dataService = DataService()
    var selectedDog: DogModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIAIView.isHidden = false
        self.UIAIView.startAnimating()
        dogTableView.delegate = self
        dogTableView.dataSource = self
        
            //dataService.deleteCoreData(){data in print(data) }
    
    }
    override func viewWillAppear(_ animated: Bool) {

            updateTableView()
        
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

            self.selectedDog = self.dogs[indexPath.row]       
            self.performSegue(withIdentifier: "DogView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DogViewController
        {
            let vc = segue.destination as? DogViewController
            vc?.dog = self.selectedDog
        }
    }
    
    func updateTableView() {
        
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
    

}

