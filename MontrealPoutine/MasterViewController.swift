//
//  MasterViewController.swift
//  MontrealPoutine
//
//  Created by Jean-Guy Bergeron on 2015-06-02.
//  Copyright (c) 2015 Jean-Guy Bergeron. All rights reserved.
//

import UIKit

//class MasterViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
class MasterViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, UINavigationControllerDelegate {

    
    
    
        
    
    var detailViewController: DetailViewController? = nil
    
    var objects = [AnyObject]()
    
    @IBOutlet weak var triSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    
    var items: [EntiteeItem] = restosData as! [EntiteeItem]
    var filtered:[EntiteeItem] = []
    
    let SORT_KEY_NOM   = "nom";
    let SORT_KEY_NOTE = "note";
    let WB_SORT_KEY     = "WB_SORT_KEY";
    let WB_NEXT_ID_KEY     = "NEXT_ID";
    
    var sectionNames = [String]()
    var sectionData = [[EntiteeItem]]()

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = 80
        
        searchBar.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let sortBy = defaults.stringForKey("WB_SORT_KEY")
        
        if sortBy == SORT_KEY_NOM
        {
            triSegmentedControl.selectedSegmentIndex = 0
        } else {
            triSegmentedControl.selectedSegmentIndex = 1
        }
        
        getRestaurants()
        
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        /*
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
*/
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver( self,
            selector: "entiteeDidChange:",
            name: WhatsitDidChangeNotification,
            object: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //tableView.selectRowAtIndexPath(saveSelection!, animated: true, scrollPosition: UITableViewScrollPosition.None)
        var index = NSIndexPath(forRow: 0, inSection: 0)
        //tableview.selectRowAtIndexPath(index, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        
        print(index.section)
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            tableView.selectRowAtIndexPath(index, animated: true, scrollPosition: UITableViewScrollPosition.None)
            performSegueWithIdentifier("showDetail", sender: nil)
        }
        //tableView.delegate?.tableView?(tableView,didSelectRowAtIndexPath: index!)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        /*
        let indexSection = 0
        let indexRow = 0
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "restaurantIndexSection")
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "restaurantIndexRow")

        
        //if indexSection >= 0 && index < sectionData.count {
        if indexSection >= 0 && indexSection < sectionData.count {
            let item = self.sectionData[indexSection][indexRow]
            performSegueWithIdentifier("showDetail", sender: item)
        }
*/
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell
        //var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        let item = self.sectionData[indexPath.section][indexPath.row]
        
        cell.nomLabel.text = item.nom
        cell.poutineLabel.text = item.poutine
        cell.fiveStarsRate.rating = item.note
        
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
        
        //let object = objects[indexPath.row] as! NSDate
        //cell.textLabel!.text = object.description
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            
            
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            //controller.detailItem = object
            
            //controller.detailItem = sectionData[indexPath.section][indexPath.row]
            
            
            
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            
        } else if segue.identifier == "showDetail" {
            print("indexPathForSelectedRow = \(self.tableView.indexPathForSelectedRow)")
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row] as! NSDate
                
                
                
                
                
                
                
                //let object = sectionData[indexPath.section][indexPath.row] as EntiteeItem
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                
                /*
                let indexSection = NSUserDefaults.standardUserDefaults().integerForKey("restaurantIndexSection")
                
                if indexSection >= 0 {
                    println("")
                    controller.itemToEdit = sender as? EntiteeItem
                } else {
                    if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                        controller.itemToEdit = sectionData[indexPath.section][indexPath.row]
                    }
                }
                */
                
                controller.itemToEdit = sectionData[indexPath.section][indexPath.row]
                
                //controller.detailItem = object
                
                //controller.detailItem = sectionData[indexPath.section][indexPath.row]
                //controller.itemToEdit = sectionData[indexPath.section][indexPath.row]
                
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return 1
        let defaults = NSUserDefaults.standardUserDefaults()
        let sortBy = defaults.stringForKey("WB_SORT_KEY")
        
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
        /*
        if sortBy == SORT_KEY_NOM
        {
            return self.sectionNames.count
        } else {
            return self.sectionData.count
        }
        */
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        return self.sectionData[section].count
    }

    
    
    
    
    /* section headers
    appear above each `UITableView` section */
    
    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String {
            let defaults = NSUserDefaults.standardUserDefaults()
            let sortBy = defaults.stringForKey("WB_SORT_KEY")
            if sortBy == SORT_KEY_NOM
            {
                return self.sectionNames[section]
            } else {
                return ""
            }
            
            
            //println("Dans titleForHeaderInSection")
            
    }
    
    
    /* section index titles
    displayed to the right of the `UITableView` */
    override func sectionIndexTitlesForTableView(tableView: UITableView)
        -> [String] {
            let defaults = NSUserDefaults.standardUserDefaults()
            let sortBy = defaults.stringForKey("WB_SORT_KEY")
            if sortBy == SORT_KEY_NOM
            {
                print(sortBy)
                return self.sectionNames
            } else {
                let sectionNamesEmpty = [String]()
                return sectionNamesEmpty
            }
            
    }
    
    
    func itemDetailViewController(controller: DetailViewController, didFinishEditingItem unRestaurant: EntiteeItem) {
        print("Dans didFinishEditingItem de itemDetailViewController")
    }
    

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    
    @IBAction func indexSortChanged(sender: UISegmentedControl) {
        

        switch triSegmentedControl.selectedSegmentIndex {
        case 0:
            //items.sort({ $0.nom < $1.nom })
            
            let prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(SORT_KEY_NOM, forKey: WB_SORT_KEY)
            
            getRestaurants()
            
            tableView.setContentOffset(CGPointMake(0,  UIApplication.sharedApplication().statusBarFrame.height ), animated: true)
            
            tableView.setContentOffset(CGPointMake(0,  0 - self.tableView.contentInset.top ), animated: true)
            
            tableView.reloadData()
            
            self.tableView.reloadData()
            print("Tri sur le nom")
        case 1:
            
            
            let prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(SORT_KEY_NOTE, forKey: WB_SORT_KEY)
            
            getRestaurants()
            
           
            tableView.setContentOffset(CGPointMake(0,  -70 ), animated: true)
            
            tableView.reloadData()
 
            print("Tri sur la note")
        default:
            break;
        }
    }

    
    
    
    func getRestaurants() {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        //let path = documentsFolder.stringByAppendingPathComponent("MTL_poutine.sqlite")
        
        //let path = self.applicationDocumentsDirectory.URLByAppendingPathComponent("MTL_poutine.sqlite")
        let path = ""
    

        
        var success: Bool
        
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
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            //let item = items[indexPath.row]
            
            
            let item = self.sectionData[indexPath.section][indexPath.row]
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.section, forKey: "restaurantIndexSection")
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "restaurantIndexRow")
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    
    
    

    func entiteeDidChange(notification: NSNotification) {
        // Received whenever a MyWhatsit object is edited.
        // Find the object in this table (if it is in this table)
        print("Passe par entiteeDidChange")
        if let changedThing = notification.object as? EntiteeItem {
            for (index,thing) in sectionData.enumerate() {
                //println("row = \(index.row)")
                
                //println(index.row)
                
                if thing[0] == changedThing {
                    //let path = NSIndexPath(forItem: index, inSection: 0)
                    let path = NSIndexPath(forItem: 0, inSection: index)
                    self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation: .None)
                }
            }
        }
    }
    
    /*
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = items.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    */
    
    


}

