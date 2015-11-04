//
//  ListeViewController.swift
//  MontrealPoutine
//
//  Created by Jean-Guy Bergeron on 2015-08-21.
//  Copyright (c) 2015 Jean-Guy Bergeron. All rights reserved.
//

import UIKit


//class ListeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DetailViewControllerDelegate  {
class ListeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var detailViewController: DetailViewController? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [EntiteeItem] = restosData as! [EntiteeItem]
    
    var searchActive : Bool = false
    
    
    @IBOutlet weak var triSegmentedControl: UISegmentedControl!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    let SORT_KEY_NOM   = "nom";
    let SORT_KEY_NOTE = "note";
    let WB_SORT_KEY     = "WB_SORT_KEY";
    let WB_NEXT_ID_KEY     = "NEXT_ID";
    let searchActiveKeyConstant = "SEARCH_ACTIVE"
    
    var sectionNames = [String]()
    var sectionData = [[EntiteeItem]]()
    var filtered = [[EntiteeItem]]()
    
    //weak var delegate: MonsterSelectionDelegate?
    
    var rechercheResto : Bool = true
    
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

        // Do any additional setup after loading the view.
        //tableView.contentInset = UIEdgeInsets(top: -66, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.rowHeight = 88
        
        //self.navigationItem.title = "Names"
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: nil, action: nil)
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            //self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        
        searchActive = false
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let sortBy = defaults.stringForKey("WB_SORT_KEY")
        
        
        if sortBy == SORT_KEY_NOM
        {
            triSegmentedControl.selectedSegmentIndex = 0
        } else {
            triSegmentedControl.selectedSegmentIndex = 1
        }
        
        getRestaurants()
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver( self,
            selector: "entiteeDidChange:",
            name: WhatsitDidChangeNotification,
            object: nil)
        
        self.tableView.reloadData()
    }

    // called just before MasterViewController is presented on the screen
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayFirstContactOrInstructions()
    }
    
    // if the UISplitViewController is not collapsed,
    // select first contact or display InstructionsViewController
    func displayFirstContactOrInstructions() {
        if let splitViewController = self.splitViewController {
            if !splitViewController.collapsed {
                // select and display first contact if there is one
                if self.tableView.numberOfRowsInSection(0) > 0 {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    self.tableView.selectRowAtIndexPath(indexPath,
                        animated: false,
                        scrollPosition: UITableViewScrollPosition.Top)
                    self.performSegueWithIdentifier(
                        "showDetail", sender: self)
                } else { // display InstructionsViewController
                    
                    print("showInstructions")
                    
                    self.performSegueWithIdentifier(
                        "showInstructions", sender: self)
                }
            }
        }
    }
    
    
    /*
    override func viewWillAppear(animated: Bool) {
        
        //tableView.selectRowAtIndexPath(saveSelection!, animated: true, scrollPosition: UITableViewScrollPosition.None)
        var index = NSIndexPath(forRow: 0, inSection: 0)
        //tableview.selectRowAtIndexPath(index, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        
        println(index.section)
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            tableView.selectRowAtIndexPath(index!, animated: true, scrollPosition: UITableViewScrollPosition.None)
            //performSegueWithIdentifier("showDetail", sender: nil)
        }
        //tableView.delegate?.tableView?(tableView,didSelectRowAtIndexPath: index!)
        
    }
*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 88;
    }
    
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell;
        //var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        //var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        
        
        //var cell:CustomCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        
        
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
    
        //var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        
        
        var item : EntiteeItem
        
        if tableView == self.tableView {
            print("TABLEVIEW normale")
        }
        else {
            print("TABLEVIEW de recherche")
        }
        
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            //if searchActive == true {
            
            item = filtered[indexPath.section][indexPath.row]
        } else {
            item = sectionData[indexPath.section][indexPath.row]
        }
        
        
        cell.nomLabel?.text = item.nom
        cell.poutineLabel.text = item.poutine
        
        if (item.ville == "Montréal") {
            cell.adresseLabel?.text = item.adresse
        } else {
            let needToChangeStr:NSString = item.ville
            let display_string:NSString = item.adresse + ", " + item.ville
            let begin:Int = display_string.length - needToChangeStr.length
            let end:Int = needToChangeStr.length
            let myMutableString = NSMutableAttributedString(string: display_string as String, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Thin", size: 12.0)!])
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 12.0)!, range: NSRange(location:begin,length:end))
            cell.adresseLabel.attributedText = myMutableString
        }
        
        cell.fiveStarsRate.rating = item.note
        
        
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
        
        
        /* 2015-08-10
        cell.nomLabel.text = item.nom
        cell.poutineLabel.text = item.poutine
        //cell.fiveStarsRate.rating = item.note
        
        if (item.ville == "Montréal") {
        cell.adresseLabel.text = item.adresse
        } else {
        var needToChangeStr:NSString = item.ville
        var display_string:NSString = item.adresse + ", " + item.ville
        let begin:Int = display_string.length - needToChangeStr.length
        let end:Int = needToChangeStr.length
        let myMutableString = NSMutableAttributedString(string: display_string as String, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Thin", size: 12.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 12.0)!, range: NSRange(location:begin,length:end))
        cell.adresseLabel.attributedText = myMutableString
        }
        
        if item.vautLeDetour == true {
        cell.imageSpecial.image = UIImage(named: "VautLeDetour")
        println("VautLeDetour")
        } else {
        //cell.imageSpecial.image = UIImage(named: "imageVide")
        cell.imageSpecial.image = nil
        }
        
        if item.signet == true {
        cell.signetImage.image = UIImage(named: "SignetON")
        } else {
        cell.signetImage.image = UIImage(named: "SignetOFF")
        }
        
        if count(item.logo.utf16) > 0 {
        cell.logoImage.image = UIImage(named: item.logo)
        // cell.logoImage.image = UIImage(named: "generique_logo")
        } else {
        cell.logoImage.image = UIImage(named: "generique_logo")
        }
        */
        
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell
        
        //cell.nomLabel?.text = data[indexPath.row];
        
        
    
        
      return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        let sortBy = defaults.stringForKey("WB_SORT_KEY")
        
    if rechercheResto {
        //if (searchActive)
        if tableView == self.searchDisplayController!.searchResultsTableView
        {
            //println("dans numberOfSectionsInTableView de SEARCH")
            return self.filtered.count
        } else {
            //println("dans numberOfSectionsInTableView de NORMAL")
            if sortBy == SORT_KEY_NOM
            {
                //return self.sectionNames.count
                return self.sectionData.count
            } else {
                return self.sectionData.count
            }
        }
    } else {
        
        return 1
    }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        if tableView == self.searchDisplayController!.searchResultsTableView {
            //return self.filtered.count
            //println("dans numberOfRowsInSection de SEARCH")
            return 1
        } else {
            //println("dans numberOfRowsInSection de normal")
            return self.sectionData[section].count
        }
    
    }
    
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String {
            let defaults = NSUserDefaults.standardUserDefaults()
            let sortBy = defaults.stringForKey("WB_SORT_KEY")
            
            if tableView == self.searchDisplayController!.searchResultsTableView {
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
    
    func sectionIndexTitlesForTableView(tableView: UITableView)
        -> [String] {
            let defaults = NSUserDefaults.standardUserDefaults()
            let sortBy = defaults.stringForKey("WB_SORT_KEY")
            if tableView == self.searchDisplayController!.searchResultsTableView {
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

    func entiteeDidChange(notification: NSNotification) {
        // Received whenever a MyWhatsit object is edited.
        // Find the object in this table (if it is in this table)
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let sortBy = defaults.stringForKey("WB_SORT_KEY")
        searchActive = defaults.boolForKey("searchActiveKeyConstant")
        
        if let changedThing = notification.object as? EntiteeItem {
            
            
            
            if (searchActive) {
            //if tableView == self.searchDisplayController!.searchResultsTableView {
                print("Passe par entiteeDidChange de searchActive")
                
                /*
                for (index,thing) in enumerate(filtered) {
                    if thing[0] == changedThing {
                        //let path = NSIndexPath(forItem: index, inSection: 0)
                        let path = NSIndexPath(forItem: 0, inSection: index)
                        self.searchDisplayController!.searchResultsTableView.reloadRowsAtIndexPaths([path], withRowAnimation: .None)
                    }
                }
*/


                self.searchDisplayController!.searchResultsTableView.reloadData()
                
            } else {
                if sortBy == SORT_KEY_NOM
                {
                    print("Passe par entiteeDidChange de SORT_KEY_NOM")
                    for var index = 0; index < sectionData.count; index++
                    {
                        for var index02 = 0; index02 < sectionData[index].count; index02++ {
                            let item = self.sectionData[index][index02]
                            if item == changedThing {
                                let path = NSIndexPath(forItem: index02, inSection: index)
                                self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation: .None)
                            }
                        }
                    }
                    
                } else {
                    print("Passe par entiteeDidChange de SORT_KEY_NOTE")
                    
                    for (index,thing) in sectionData.enumerate() {
                        if thing[0] == changedThing {
                            //let path = NSIndexPath(forItem: index, inSection: 0)
                            let path = NSIndexPath(forItem: 0, inSection: index)
                            self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation: .None)
                        }
                    }

                    //self.tableView.reloadData()
                }
            }
            
            
            
            
            
        }
    }
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let item = self.sectionData[indexPath.section][indexPath.row]
        
        if item.BDInitiale == true {
            return false
        } else {
            return true
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
        }
    }
    
    
    /*
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
*/
    
/*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        /*
        var friend : EntiteeItem
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            friend = self.filtered[indexPath.section][indexPath.row]
        }
        else
        {
            friend = self.sectionData[indexPath.section][indexPath.row]
        }
        
        println(friend.nom)
        println("Passe par didSelectRowAtIndexPath")
        self.performSegueWithIdentifier("showDetail", sender: tableView)
*/
        
        /*
        let selectedMonster = self.monsters[indexPath.row]
        self.delegate?.monsterSelected(selectedMonster)
        
        if let detailViewController = self.delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController.navigationController, sender: nil)
        }
        */
        
        //self.performSegueWithIdentifier("candyDetail", sender: friend)
        
    }
*/
    
    
    func itemDetailViewControllerDidCancel(controller: DetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: DetailViewController, didFinishAddingItem unRestaurant: EntiteeItem) {
        /*
        let newRowIndex = items.count
        items.append(item)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        */
        
        var isInserted = ModelManager.instance.addRestaurantData(unRestaurant)
        
        dismissViewControllerAnimated(true, completion: nil)
        
        //focusOnCurrentCell()
    }

    
    func itemDetailViewController(controller: DetailViewController, didFinishEditingItem unRestaurant: EntiteeItem) {
        /*
        if let index = find(items, item) {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        configureTextForCell(cell, withChecklistItem: item)
        }
        }
        */
        
        var isUpdated = ModelManager.instance.updateRestaurantData(unRestaurant)
        
        //focusOnCurrentCell()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setObject(true, forKey: searchActiveKeyConstant)
        print("Dans searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setObject(false, forKey: searchActiveKeyConstant)
        print("Dans searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setObject(false, forKey: searchActiveKeyConstant)
        self.tableView.reloadData()
        print("Dans searchBarCancelButtonClicked")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setObject(false, forKey: searchActiveKeyConstant)
        print("Dans searchBarSearchButtonClicked")
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
                    //println("exists")
                    
                    
                    self.filtered.append([EntiteeItem]())
                    filtered[filtered.count-1].append(item)
                    
                    
                    
                    
                }
                
                
                
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        
        
        var friend : EntiteeItem
        print("Passe par prepareForSegue")
        
        
        
        
        if segue.identifier == "showDetail" {
            print("Passe par showDetail")
            
            /*
            if sender as! UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                //let destinationTitle = self.filteredCandies[indexPath.row].name
                //candyDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                //let destinationTitle = self.candies[indexPath.row].name
                //candyDetailViewController.title = destinationTitle
            }
            
            
            if (tableView == self.searchDisplayController?.searchResultsTableView)
            {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                friend = self.filtered[indexPath.section][indexPath.row]
            }
            else
            {
                //friend = self.sectionData[indexPath.section][indexPath.row]
            }
            */
            
            //let navigationController = segue.destinationViewController as! UINavigationController
            //let controller = navigationController.topViewController as! DetailViewController
            //controller.delegate = self

            
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            
            // var barBack = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.Plain, target: self, action: "reset:")
            
            
            
            
            
            //var barBack = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.Done, target: self, action: "")
            //controller.navigationItem.leftBarButtonItem = barBack
            
            
            
            
            //let dummyButton = UIBarButtonItem(title: "< Dummy", style: .Plain, target: nil, action: nil)
            
            
            //controller.navigationItem.leftBarButtonItem = dummyButton
            
            //controller.navigationItem.topItem?.leftBarButtonItem?.title = "AnyText"
            
            
            //navigationItem.leftBarButtonItem?.setTitle = "AAA"

            //controller.navigationItem.leftBarButtonItem!.title = "myTitle"
            
            //let navigationBar = (self.view.viewWithTag(-1) as! UINavigationBar)
            //navigationBar.topItem?.leftBarButtonItem?.title = "AnyText"
            
            //self.navigationItem.backBarButtonItem.title = @"Previous"
            
            
            //navigationItem.title = "Pasta to One"
            //navigationItem.backBarButtonItem!.title = "Previous"
            
            
            //self.navigationItem.title = "Names"
            //controller.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: nil, action: nil)
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                /*
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                */
                
                controller.itemToEdit = sectionData[indexPath.section][indexPath.row]
                
                
                
                //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                //controller.navigationItem.leftItemsSupplementBackButton = true
            } else {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow!
                
                /*
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                */
                
                controller.itemToEdit = filtered[indexPath.section][indexPath.row]
            }
            
            
            
            
            
            
            
            
            
            
            
            /*
            let candyDetailViewController = segue.destinationViewController as! UIViewController
            if sender as! UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                //ami01 = self.filtered[indexPath.section][indexPath.row]
                //let destinationTitle = self.filteredCandies[indexPath.row].name
                //candyDetailViewController.title = destinationTitle
                
                friend = self.filtered[indexPath.section][indexPath.row]
                let destinationTitle = friend.nom
                candyDetailViewController.title = destinationTitle
                
                //candyDetailViewController.itemToEdit = sectionData[indexPath.section][indexPath.row]
                
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                //let indexPath = self.tableView.indexPathForSelectedRow()!
                
                
                if let indexPath = self.tableView.indexPathForSelectedRow() {
                    //let task = TaskStore.sharedInstance.get(indexPath.row)
                    println(indexPath)
                    //(segue.destinationViewController as DetailViewController).detailItem = task
                }
                
                
                if let blogIndex = tableView.indexPathForSelectedRow()?.row {
                    println(blogIndex)
                }
                
                friend = self.sectionData[indexPath.section][indexPath.row]
                println(friend.nom)
                //let destinationTitle = self.candies[indexPath.row].name
                let destinationTitle = friend.nom
                candyDetailViewController.title = destinationTitle
            }
*/
            //println(ami01.nom)
        }
    }
    
    func getRestaurants() {
        //let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        //let path = documentsFolder.stringByAppendingPathComponent("MTL_poutine.sqlite")
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let path = documentsPath.stringByAppendingPathComponent("MTL_poutine.sqlite")
        
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
                
                
                //println("ID = \(itemID); nom = \(nom); chaine = \(Bool(Int(chaine))); note = \(Float(note))")
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
            
            //self.tableView.reloadData()
            print("Tri sur le nom")
        case 1:
            
            
            let prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(SORT_KEY_NOTE, forKey: WB_SORT_KEY)
            
            getRestaurants()
            
            tableView.setContentOffset(CGPointMake(0,  UIApplication.sharedApplication().statusBarFrame.height ), animated: true)
            
            tableView.setContentOffset(CGPointMake(0,  0 - self.tableView.contentInset.top ), animated: true)
            
            //tableView.setContentOffset(CGPointMake(0,  -70 ), animated: true)
            
            tableView.reloadData()
            
            print("Tri sur la note")
        default:
            break;
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text!.isEmpty{
            searchActive = false
            tableView.reloadData()
        } else {
            //print(" search text %@ ",searchBar.text as NSString)
            //println(" search text %@ ",searchBar.text as? String)
            searchActive = true
            filtered.removeAll()
           
            /*
            
*/
            
            
        
            for var index = 0; index < sectionData.count; index++
            {
                for item in self.sectionData[index] {
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
        
            
            
            
            tableView.reloadData()
        }
    }
}
