//
//  masterViewControllerSearch.swift
//  MontrealPoutine
//
//  Created by Jean-Guy Bergeron on 2015-06-25.
//  Copyright (c) 2015 Jean-Guy Bergeron. All rights reserved.
//

import UIKit
import Foundation


class masterViewControllerSearch: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    
    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    
    //@IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchActive : Bool = false
    
    @IBOutlet weak var triSegmentedControl: UISegmentedControl!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    
    var items: [EntiteeItem] = restosData as! [EntiteeItem]
    //var filtered:[EntiteeItem] = []
    
    let SORT_KEY_NOM   = "nom";
    let SORT_KEY_NOTE = "note";
    let WB_SORT_KEY     = "WB_SORT_KEY";
    let WB_NEXT_ID_KEY     = "NEXT_ID";
    
    var sectionNames = [String]()
    var sectionData = [[EntiteeItem]]()
    var filtered = [[EntiteeItem]]()
    
    //var resultSearchController = UISearchController()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            //self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0,right: 0)
        // tableView.contentInset = UIEdgeInsets(top: -70, left: 0, bottom: 0,right: 0)
        
        tableView.contentInset = UIEdgeInsets(top: -108, left: 0, bottom: 0,right: 0)
        
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 88
        
        tableView.delegate = self
        tableView.dataSource = self
        //searchBar.delegate = self
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let sortBy = defaults.stringForKey("WB_SORT_KEY")
        
        if sortBy == SORT_KEY_NOM
        {
            triSegmentedControl.selectedSegmentIndex = 0
            
        } else {
            triSegmentedControl.selectedSegmentIndex = 1
            //tableView.contentInset = UIEdgeInsets(top: -70, left: 0, bottom: 0,right: 0)
        }
        
        getRestaurants()
        
        /*
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            
            return controller
        })()
        */

        self.tableView.reloadData()
        
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
        
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //self.tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "Cell")
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        print("Dans searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        print("Dans searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.tableView.reloadData()
        print("Dans searchBarCancelButtonClicked")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        print("Dans searchBarSearchButtonClicked")
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        let sortBy = defaults.stringForKey("WB_SORT_KEY")
        
        
        if (searchActive)
        {
            return self.filtered.count
        } else {
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
            return self.filtered[section].count
        } else {
            return self.sectionData[section].count
            //return 10
        }
        
        //return data.count
        /*
        if (searchActive)
        {
            return self.filtered[section].count
        } else {
            return self.sectionData[section].count
        }
        */
            
        
    }
    
    
    //override func tableView(tableView: UITableView,titleForHeaderInSection section: Int) -> String {
    func tableView(tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
            let defaults = NSUserDefaults.standardUserDefaults()
            let sortBy = defaults.stringForKey("WB_SORT_KEY")
        
        
        if (searchActive)
        {
            return ""
        } else {
            if sortBy == SORT_KEY_NOM
            {
                return self.sectionNames[section]
            } else {
                return ""
            }
        }
        
        
        
        
            
            
            //println("Dans titleForHeaderInSection")
            
    }
    
    
    /* section index titles
    displayed to the right of the `UITableView` */
    //override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject] {
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String] {
            let defaults = NSUserDefaults.standardUserDefaults()
            let sortBy = defaults.stringForKey("WB_SORT_KEY")
        
        
        
        if (searchActive)
        {
            let sectionNamesEmpty = [String]()
            return sectionNamesEmpty
        } else {
            if sortBy == SORT_KEY_NOM
            {
                print(sortBy)
                return self.sectionNames
            } else {
                let sectionNamesEmpty = [String]()
                return sectionNamesEmpty
            }
        }
        
        
        
        
            
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell;
        //var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        //var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        
        
        //var cell:CustomCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        
        var item : EntiteeItem
        if (searchActive)
        {
            item = self.filtered[indexPath.section][indexPath.row]
            
        } else {
            item = self.sectionData[indexPath.section][indexPath.row]
        }
        
        
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
    
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 88;
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
            
            //println("indexPathForSelectedRow = \(self.tableView.indexPathForSelectedRow())")
            //println("indexPathForCell = \(tableView.indexPathForCell(sender as! CustomCell))")
            
            let selectedIndex = self.tableView.indexPathForCell(sender as! CustomCell)

            
            
            /*
            if self.resultSearchController.active {
                println("resultSearchController is active")
            } else {
                println("resultSearchController is NOT active")
            }
            */
            
            //let indexPath = [self.tableView, indexPathForCell,:sender]
            //let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            /*
            if self.searchController.active {
                let indexPath = self.searchDisplayController?.searchResultsTableView.indexPathForSelectedRow()
            }
            */
            
            
            
            //if let indexPath = self.tableView.indexPathForSelectedRow() {
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                //let object = objects[indexPath.row] as! NSDate
                
                
                
                
                
                
                if tableView == self.searchDisplayController!.searchResultsTableView {
                    //return 10
                } else {
                    //return  0
                }
                                
                
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
                
                if (searchActive)
                {
                    controller.itemToEdit = filtered[indexPath.section][indexPath.row]
                } else {
                    controller.itemToEdit = sectionData[indexPath.section][indexPath.row]
                }
            
                
                controller.itemToEdit = sectionData[indexPath.section][indexPath.row]
                
                //controller.detailItem = object
                
                //controller.detailItem = sectionData[indexPath.section][indexPath.row]
                //controller.itemToEdit = sectionData[indexPath.section][indexPath.row]
                
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func itemDetailViewController(controller: DetailViewController, didFinishEditingItem unRestaurant: EntiteeItem) {
        print("Dans didFinishEditingItem de itemDetailViewController")
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let item = self.sectionData[indexPath.section][indexPath.row]
        
        if item.BDInitiale == true {
            return self.editing ? .Delete : .None
        } else {
            //return self.editing ? .Delete : .None
            return UITableViewCellEditingStyle.Delete;
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
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
    
    
    // MARK: - SearchBar textDidChange
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("Dans searchBar textDidChange \(searchText)")
        
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
                
                
                /*
                if (rangeNom.location != NSNotFound) {
                
                }
                */
                
                
                
                //return rangeNom.location == nil
                
                
                
                
                //if(rangeNom.location != NSNotFound || descriptionRange.location != NSNotFound)
                
                //println(rangeNom.location)
                
                //return rangeNom.location != NSNotFound
                
                /*
                if(rangeNom.location != Foundation.NSNotFound) {
                    //[filteredTableData addObject:food];
                }
                */
                
            }
        }
        
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
        
        /*
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
        
        
        
        
        filtered = sectionData.filter({ (entitee : EntiteeItem) -> Bool in
            
            //let tmp: NSString = text
            let tmp: NSString = "Allo"
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
*/
        
    }
    
    
    /*
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println("Dans searchBar textDidChange \(searchText)")
        
        filtered = sectionData.filter({ (entitee : EntiteeItem) -> Bool in
            
            //let tmp: NSString = text
            let tmp: NSString = "Allo"
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
    
    func getRestaurants() {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
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
        
        filtered = sectionData
        print("Une ligne")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            //let item = items[indexPath.row]
            
            
            let item = self.sectionData[indexPath.section][indexPath.row]
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.section, forKey: "restaurantIndexSection")
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "restaurantIndexRow")
            
            self.performSegueWithIdentifier("showDetail", sender: indexPath)
            //self.performSegueWithIdentifier("WebSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
            
            
            
            //tableView.setContentOffset(CGPointMake(0,  -70 ), animated: true)
            
            
            tableView.setContentOffset(CGPointMake(0,  UIApplication.sharedApplication().statusBarFrame.height ), animated: true)
            
            tableView.setContentOffset(CGPointMake(0,  0 - self.tableView.contentInset.top ), animated: true)
            
            
            //tableView.setContentOffset(CGPointMake(0,  0 - self.tableView.contentInset.top ), animated: true)
            
            tableView.reloadData()
            
            print("Tri sur la note")
        default:
            break;
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("updateSearchResultsForSearchController")
    }
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        /*
        self.filtered = self.items.filter({( candy : EntiteeItem) -> Bool in
            var categoryMatch = (scope == "All") || (candy.category == scope)
            var stringMatch = candy.nom.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
        */
        
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
        /*
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as! [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
*/
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            /*
            let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as! [String]
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
*/
            return true
    }

}
