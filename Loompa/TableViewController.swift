//
//  TableViewController.swift
//  Loompa
//
//  Created by Brian Griffin on 1/17/20.
//  Copyright © 2020 swiftapprentice. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UISearchDisplayDelegate, UISearchBarDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var artistList = [Artist]()
    
    
    var imageURL = ""
    var profileDesc = ""
    
    var isSearching = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let searchBarView = Bundle.main.loadNibNamed("SearchBar", owner: self, options: nil)?.first as? SearchBarView {
            
            searchBarView.newSearchBar.delegate = self
            searchBarView.newSearchBar.returnKeyType = UIReturnKeyType.done // tap click away from search
            searchBarView.frame.size = CGSize(width: self.view.frame.width, height: 50)
            
            let textField = searchBarView.newSearchBar.searchTextField
            textField.backgroundColor = UIColor.white
            self.view.addSubview(searchBarView)
        }
        
        
       
        fetchAndSaveData()
        
        fetchAndPopulateList()
       // print(artistList.count)
        artistList.sort(by: {$0.name ?? "n/a" < $1.name ?? "n/a"})
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            var predicate : NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
            fetchRequest.predicate = predicate
            
            do {
                artistList = try context.fetch(fetchRequest) as! [Artist]
            } catch {
                print("Could not fetch search data")
            }
            
        } else {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
            do {
                artistList = try context.fetch(fetchRequest) as! [Artist]
                artistList.sort(by: {$0.name ?? "n/a" < $1.name ?? "n/a"})
            } catch {
                print("could not reload data")
            }
        }
        
        tableView.reloadData()
    }
    
 
    func fetchAndSaveData() {
        
        if let url = URL(string: "http://assets.aloompa.com.s3.amazonaws.com/rappers/rappers.json") {
                          // Begin URL session
                          URLSession.shared.dataTask(with: url) { data, response, error in
                              
                              typealias JSONDictionary = [String:Any]
                              
                              do {
                              
                                  if let parsedData = try JSONSerialization.jsonObject(with: data!) as? JSONDictionary,
                                      let artists = parsedData["artists"] as? [JSONDictionary] {
                                      for artist in artists {
                                        
                                   
                                  
                                        let name = artist["name"] as? String ?? "n/a"
                                        let desc = artist["description"] as? String ?? "n/a"
                                        let image = artist["image"] as? String ?? "n/a"
                                        let id = artist["id"] as? String ?? "n/a"
                                        let appId = artist["appId"] as? String ?? "n/a"
                                        let entity = NSEntityDescription.entity(forEntityName: "Artist", in: self.context)
                                        let newEntity = NSManagedObject(entity: entity!, insertInto: self.context)
                                        
                                        newEntity.setValue(name, forKey: "name")
                                        newEntity.setValue(desc, forKey: "desc")
                                        newEntity.setValue(image, forKey: "image")
                                        newEntity.setValue(id, forKey: "id")
                                        newEntity.setValue(appId, forKey: "appId")
                                        
                                      
                                        if self.artistList.count < 5  {
                                            
                                            do {
                                                try self.context.save()
                                                
                                                print("saved")
                                            } catch {
                                                print("Failed Saving")
                                            }
                                        
                                        }
                                        
                                        
                                       //   print("name: ", artist["name"] as? String ?? "n/a", ", profile: ", artist["description"] as? String ?? "n/a")
                                    
                                        
                                        
//                                       self.list.append(Artist(artistName: artist["name"] as? String ?? "n/a", imgURL: artist["image"] as? String ?? "n/a" , profileDesc: artist["description"] as? String ?? "n/a", artistID: artist["id"] as? String ?? "n/a", appID: artist["appId"] as? String ?? "n/a"))
//                                       // sort artists by name
//                                       self.list.sort(by: {$0.name < $1.name})
//                                       self.names.append(artist["name"] as? String ?? "n/a")
                                        
                                        
                                       
                                      }
                                  }
                              } catch let error {
                                  print(error)
                              }
                            
                          }.resume()
                      }
               
    }
    
    func fetchAndPopulateList() {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
        
        do {
            let results = try context.fetch(fetchRequest)
            self.artistList = results as! [Artist]
        } catch let err as NSError {
            print(err.debugDescription)
            print("Failed to fetch data")
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 334
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return artistList.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
         let cell = Bundle.main.loadNibNamed("MyCustomCell", owner: self, options: nil)?.first as! MyCustomCell
        
        let imageURL = URL(string: artistList[indexPath.item].image ?? "n/a")
        let imageData = try! Data(contentsOf: imageURL!)
        // Configure the cell...
        
        cell.artistNameLabel.text = artistList[indexPath.item].name
        cell.profileImage.image = UIImage(data: imageData)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped cell")
        
        // Fetch  and assign data for selected cell
     

        imageURL = artistList[indexPath.item].image ?? "n/a"
        profileDesc = artistList[indexPath.item].desc ?? "n/a"
        
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        
     
        profileVC.imageURL = imageURL
        profileVC.profile = profileDesc
       
        // Present screen with description of selected artist
        
        self.present(profileVC, animated: true, completion: nil)

        
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
