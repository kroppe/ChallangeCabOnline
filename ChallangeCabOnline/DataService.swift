//
//  DataService.swift
//  ChallangeCabOnline
//
//  Created by Robert Andersson on 2019-02-17.
//  Copyright © 2019 Kroppe. All rights reserved.
//
import Foundation
import CoreData
import UIKit

struct responsdata {
    
    let Name: String
    let subName: [String?]
}

struct coreData {
    
    let dogBreed: String!
    let dogImageData: Data!
    
}

class DataService {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    func getAndSaveData(completionHandler: @escaping () -> Void) {
        var allSaved: Int = 0
        
        self.getAllDogs() {data in
            print(data.count)
            for dog in data {
                
                self.getDogImageUrl(dogBreed: dog) {imageUrl in
                    
                    self.getImageData(url: imageUrl) {imageData in
                        
                        self.saveCoreData(dog: coreData(dogBreed: dog, dogImageData: imageData))
                        allSaved += 1
                        if(allSaved == data.count) {
                            completionHandler()
                        }
                        
                    }
                }

            }
        }
        
    }
    
    func getDogImageUrl(dogBreed:String, completionHandler: @escaping (String) -> Void) {
        
        var dogUrl: String!
        var responsImageUrl: String!
        let dogBreedSplit = dogBreed.split(separator: " ")
        
        if(dogBreedSplit.count == 1) {
            dogUrl = "\(dogBreedSplit[0])"
        } else {
            dogUrl = "\(dogBreedSplit[1])"+"/"+"\(dogBreedSplit[0])"
        }
        
        let dogImageUrl: String = "https://dog.ceo/api/breed/\(dogUrl!)/images/random"
        
        let url = URL(string: dogImageUrl)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            
            guard let data = data else { return }
            
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? NSMutableDictionary
                responsImageUrl = json!["message"]! as! String
                
                print(responsImageUrl)
                completionHandler(responsImageUrl)
                
            }
                
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                print("error")
            }
            
            }.resume()
        
    }
    
    func getImageData(url: String!, completionHandler: @escaping (Data) -> Void) {
        
        let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: encoded!)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            print(url!)
            print(data!)
            completionHandler(data!)
            
        }).resume()
        
        
    }
    
    func getAllDogs(completionHandler: @escaping ([String]) -> Void) {
        
        var responsDataArray: [responsdata] = []
        var dogArray: [String] = []
        let listAllUrl:String = "https://dog.ceo/api/breeds/list/all"
        guard let url = URL(string: listAllUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do
            {
                let dictionary = try JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? NSMutableDictionary
                let massage = dictionary!["message"]! as? Dictionary<String,Any>
                for m in massage! {
                    
                    responsDataArray.append(responsdata(Name: m.key, subName: m.value as! [String?]))
                    
                }
                
                for data in responsDataArray{
                    
                    if(data.subName.count == 0 ) {
                        //print(data.Name)
                        dogArray.append(data.Name)
                    } else {
                        for subData in data.subName {
                            //print("\(subData!)" + " " + "\(data.Name)")
                            dogArray.append("\(subData!)" + " " + "\(data.Name)")
                        }
                    }
                }
                
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                print("error")
            }
            dogArray.sort()
            completionHandler(dogArray)
            }.resume()
        
    }
    
    func saveCoreData(dog: coreData) {
        
        context.perform {
            let entity = NSEntityDescription.entity(forEntityName: "Dogs", in: self.context)
            let newDog = NSManagedObject(entity: entity!, insertInto: self.context)
            
            newDog.setValue(dog.dogBreed, forKey: "dogBreed")
            newDog.setValue(dog.dogImageData, forKey: "dogImageData")
            
            
            do {
                try self.context.save()
            } catch {
                print("Failed saving")
            }
        }
        
        
    }
    
    func loadCoreData(completionHandler: @escaping ([DogModel]) -> Void){
        
        var dogs: [DogModel] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dogs")
        request.returnsObjectsAsFaults = false
        
        context.perform {
            do {
                let result = try self.context.fetch(request)
                for data in result as! [NSManagedObject] {
                    
                    let dogBreed:String = (data.value(forKey: "dogBreed") as! String)
                    let dogImageData: Data =  (data.value(forKey: "dogImageData") as! Data)
                    
                    let dogImage: UIImage = UIImage(data: dogImageData)!
                    
                    dogs.append(DogModel(dogBreed: dogBreed, dogImage: dogImage))
                }
            } catch {
                print("Failed")
            }
            dogs.sort(by: { $0.dogBreed < $1.dogBreed })
            completionHandler(dogs)
        }
        
    }
    
    func deleteCoreData(completionHandler: @escaping (String) -> Void){
        context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dogs")
            request.returnsObjectsAsFaults = false
            do {
                let result = try self.context.fetch(request)
                for data in result as! [NSManagedObject] {
                    
                    self.context.delete(data)
                }
                
            } catch {
                
                print("Failed")
            }
            do {
                try self.context.save()
            } catch {
                print("Failed saving")
            }
            
            completionHandler("OK")
        }
        
    }
    
}

