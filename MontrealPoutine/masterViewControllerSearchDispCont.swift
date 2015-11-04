//
//  masterViewControllerSearchDispCont.swift
//  MontrealPoutine
//
//  Created by Jean-Guy Bergeron on 2015-07-22.
//  Copyright (c) 2015 Jean-Guy Bergeron. All rights reserved.
//

import UIKit

class masterViewControllerSearchDispCont: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    
    
    
    @IBOutlet weak var triSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [EntiteeItem] = restosData as! [EntiteeItem]
    
    let SORT_KEY_NOM   = "nom";
    let SORT_KEY_NOTE = "note";
    let WB_SORT_KEY     = "WB_SORT_KEY";
    let WB_NEXT_ID_KEY     = "NEXT_ID";
    
    var searchActive : Bool = false
    
    var sectionNames = [String]()
    var sectionData = [[EntiteeItem]]()
    var filtered = [[EntiteeItem]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 88
        
        // Do any additional setup after loading the view.
        
        getRestaurants()
        
        //self.tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "Cell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 88;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell;
        //var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        //var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        
        
        //var cell:CustomCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        
        var item : EntiteeItem
        
        
        
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            item = filtered[indexPath.section][indexPath.row]
        } else {
            item = sectionData[indexPath.section][indexPath.row]
        }
        
        
        
        /*
        if (searchActive)
        {
            item = self.filtered[indexPath.section][indexPath.row]
            
        } else {
            item = self.sectionData[indexPath.section][indexPath.row]
        }
        */
        
        
        //let item = self.sectionData[indexPath.section][indexPath.row]
        //item = self.sectionData[indexPath.section][indexPath.row]
        
        cell.nomLabel.text = item.nom
        cell.poutineLabel.text = item.poutine
        //cell.fiveStarsRate.rating = item.note
        
        if (item.ville == "Montréal") {
            cell.adresseLabel.text = item.adresse
        } else {
            let needToChangeStr:NSString = item.ville
            let display_string:NSString = item.adresse + ", " + item.ville
            let begin:Int = display_string.length - needToChangeStr.length
            let end:Int = needToChangeStr.length
            let myMutableString = NSMutableAttributedString(string: display_string as String, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Thin", size: 12.0)!])
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 12.0)!, range: NSRange(location:begin,length:end))
            cell.adresseLabel.attributedText = myMutableString
        }
        
        if item.vautLeDetour == true {
            cell.imageSpecial.image = UIImage(named: "VautLeDetour")
            print("VautLeDetour")
        } else {
            //cell.imageSpecial.image = UIImage(named: "imageVide")
            cell.imageSpecial.image = nil
        }
        
        if item.signet == true {
            cell.signetImage.image = UIImage(named: "SignetON")
        } else {
            cell.signetImage.image = UIImage(named: "SignetOFF")
        }
        
        if item.logo.utf16.count > 0 {
            cell.logoImage.image = UIImage(named: item.logo)
            // cell.logoImage.image = UIImage(named: "generique_logo")
        } else {
            cell.logoImage.image = UIImage(named: "generique_logo")
        }
        
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell
        
        //cell.nomLabel?.text = data[indexPath.row];
        
        return cell;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        let sortBy = defaults.stringForKey("WB_SORT_KEY")
        
        
        //if (searchActive)
        if tableView == self.searchDisplayController!.searchResultsTableView
        {
            print("dans numberOfSectionsInTableView de SEARCH")
            return self.filtered.count
        } else {
            print("dans numberOfSectionsInTableView de NORMAL")
            if sortBy == SORT_KEY_NOM
            {
                return self.sectionNames.count
            } else {
                return self.sectionData.count
            }
        }
        
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            //return self.filtered.count
            print("dans numberOfRowsInSection de SEARCH")
            return 1
        } else {
            print("dans numberOfRowsInSection de normal")
            return self.sectionData[section].count
        }
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: tableView)
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            
            
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            //controller.detailItem = object
            
            //controller.detailItem = sectionData[indexPath.section][indexPath.row]
            
            
            
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            
        } else if segue.identifier == "showDetail" {
            
            if self.searchDisplayController!.active {
                let indexPath = self.searchDisplayController?.searchResultsTableView.indexPathForSelectedRow
                if indexPath != nil {
                    print("une ligne")
                    //speciesDetailVC.species = self.speciesSearchResults?[indexPath!.row]
                }
            } else {
                let indexPath = self.tableView?.indexPathForSelectedRow
                
                //let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
                if indexPath != nil {
                    //let destinationTitle = self.filtered[indexPath!.section][indexPath!.row].nom
                    print("une ligne")
                    //speciesDetailVC.species = self.species?[indexPath!.row]
                }
            }
            
            //let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            /*
            if sender as! UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                println("tableView searchDisplayController")
                //let destinationTitle = self.filteredCandies[indexPath.row].name
                //candyDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                println("tableView NORMALE")
                //let destinationTitle = self.candies[indexPath.row].name
                //candyDetailViewController.title = destinationTitle
            }
            */
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getRestaurants() {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let path = ""
        var success: Bool
        
        let SORT_KEY_NOM   = "nom";
        let SORT_KEY_NOTE = "note";
        let WB_SORT_KEY     = "WB_SORT_KEY";
        let WB_NEXT_ID_KEY     = "NEXT_ID";
        
        items.removeAll()
        sectionNames.removeAll()
        sectionData.removeAll()
        
        
        let database = FMDatabase(path: path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let sortBy = defaults.stringForKey("WB_SORT_KEY")
        
        var querySQL = ""
        if sortBy == SORT_KEY_NOM
        {
            //let resultats = database.executeQuery("select * from Restaurant ORDER BY nom", withArgumentsInArray: nil)
            querySQL = "select * from Restaurant ORDER BY nom_pour_tri"
        } else {
            //let resultats = database.executeQuery("select * from Restaurant ORDER BY note DESC, nom", withArgumentsInArray: nil)
            querySQL = "select * from Restaurant ORDER BY note DESC, nom_pour_tri"
        }
        
        // if let resultats = database.executeQuery("select * from Restaurant ORDER BY nom", withArgumentsInArray: nil) {
        if let resultats = database.executeQuery(querySQL,withArgumentsInArray: nil) {
            while resultats.next() {
                let itemID = resultats.intForColumn("RestaurantID")
                let nom = resultats.stringForColumn("Nom")
                let nomPourTri = resultats.stringForColumn("nom_pour_tri")
                let logo = resultats.stringForColumn("Logo")
                let adresse = resultats.stringForColumn("Adresse")
                let ville = resultats.stringForColumn("Ville")
                let province = resultats.stringForColumn("Province")
                let codePostal = resultats.stringForColumn("Code_Postal")
                let phone = resultats.stringForColumn("Phone")
                let poutine = resultats.stringForColumn("Poutine_vedette")
                let fichierCarte = resultats.stringForColumn("Fichier_carte")
                let itemLatitude = resultats.doubleForColumn("latitude")
                let itemLongitude = resultats.doubleForColumn("longitude")
                let note = resultats.doubleForColumn("note")
                let itemDescription = resultats.stringForColumn("description")
                let commentaire = resultats.stringForColumn("commentaire")
                let BDInitiale = resultats.intForColumn("bd_initiale")
                let siteWeb = resultats.stringForColumn("site_web")
                let chaine = resultats.intForColumn("chaine")
                let signet = resultats.intForColumn("signet")
                let coupDeCoeur = resultats.intForColumn("coup_de_coeur")
                let cellBackground = resultats.stringForColumn("cell_background")
                let vautLeDetour = resultats.intForColumn("vaut_le_detour")
                let adresseGPS = resultats.stringForColumn("adresseGPS")
                let dimanche = resultats.stringForColumn("dimanche")
                let lundi = resultats.stringForColumn("lundi")
                let mardi = resultats.stringForColumn("mardi")
                let mercredi = resultats.stringForColumn("mercredi")
                let jeudi = resultats.stringForColumn("jeudi")
                let vendredi = resultats.stringForColumn("vendredi")
                let samedi = resultats.stringForColumn("samedi")
                
                
                
                let rowitem = EntiteeItem(
                    itemID:Int(itemID),
                    nom:nom,
                    nomPourTri:nomPourTri,
                    logo:logo,
                    adresse:adresse,
                    ville:ville,
                    province:province,
                    codePostal:codePostal,
                    phone:phone,
                    poutine:poutine,
                    fichierCarte:fichierCarte,
                    itemLatitude:Float(itemLatitude),
                    itemLongitude:Float(itemLongitude),
                    note:Float(note),
                    itemDescription:itemDescription,
                    commentaire:commentaire,
                    BDInitiale:Bool(Int(BDInitiale)),
                    siteWeb:siteWeb,
                    chaine:Bool(Int(chaine)),
                    signet:Bool(Int(signet)),
                    coupDeCoeur:Bool(Int(coupDeCoeur)),
                    cellBackground:cellBackground,
                    vautLeDetour:Bool(Int(vautLeDetour)),
                    adresseGPS:adresseGPS,
                    dimanche:dimanche,
                    lundi:lundi,
                    mardi:mardi,
                    mercredi:mercredi,
                    jeudi:jeudi,
                    vendredi:vendredi,
                    samedi:samedi
                    
                )
                
                items.append(rowitem)
                
                
                print("ID = \(itemID); nom = \(nom); chaine = \(Bool(Int(chaine))); note = \(Float(note))")
            }
        } else {
            print("select failed: \(database.lastErrorMessage())")
        }
        
        database.close()
        
        
        
        //items.sort({ $0.nom < $1.nom })
        
        //let defaults = NSUserDefaults.standardUserDefaults()
        //defaults.setObject(SORT_KEY_NOTE, forKey: WB_SORT_KEY)
        
        //let defaults = NSUserDefaults.standardUserDefaults()
        //let sortBy = defaults.stringForKey("WB_SORT_KEY")
        if sortBy == SORT_KEY_NOM
        {
            //items.sort({ $0.nom < $1.nom })
            var previous = ""
            for aItem in items {
                // get the first letter
                let c = (aItem.nomPourTri as NSString).substringWithRange(NSMakeRange(0,1))
                // only add a letter to sectionNames when it's a different letter
                if c != previous {
                    previous = c
                    self.sectionNames.append(c.uppercaseString)
                    // and in that case also add new subarray to our array of subarrays
                    self.sectionData.append([EntiteeItem]())
                }
                sectionData[sectionData.count-1].append(aItem)
            }
        } else {
            //items.sort({$0.note > $1.note;$0.nom < $1.nom })
            
            
            //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true, key: "title", ascending: true)
            
            for aItem in items {
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append([EntiteeItem]())
                sectionData[sectionData.count-1].append(aItem)
            }
        }
        
        //filtered = sectionData
        print("Une ligne de getRestaurants")
    }
    
    
    
    func filterContentForSearchText(searchText: String) {
        filtered.removeAll()
        
        
        for index in 0..<self.sectionData.count {
            //for item in self.sectionData {
            //println("item \(item)")
            //println("index = \(index)")
            for item in self.sectionData[index] {
                //println("item \(item.nom)")
                
                
                
                
                
                var tmp = item.nom
                let rangeNom = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                
                tmp = item.poutine
                let rangePoutine = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                //println("Pour une ligne")
                
                if (rangeNom != nil || rangePoutine != nil){
                    print("exists")
                    
                    
                    self.filtered.append([EntiteeItem]())
                    filtered[filtered.count-1].append(item)
                    
                    
                    
                    
                }
                
                
                
            }
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString!)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true
    }
    
}
