//
//  DetailViewController.swift
//  MontrealPoutine
//
//  Created by Jean-Guy Bergeron on 2015-06-02.
//  Copyright (c) 2015 Jean-Guy Bergeron. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, FloatRatingViewDelegate, UITextViewDelegate {

    
    @IBOutlet weak var editBarButton: UIBarButtonItem!

    var itemToEdit: EntiteeItem?
    
    var lienSiteWeb = ""
    
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    
    
    //weak var delegate: DetailViewController?
    
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var poutineLabel: UILabel!
    @IBOutlet weak var adresseLabel: UILabel!
    @IBOutlet weak var villeLabel: UILabel!
    @IBOutlet weak var codePostalLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var horaireDimancheLabel: UILabel!
    @IBOutlet weak var horaireLundiLabel: UILabel!
    @IBOutlet weak var horaireMardiLabel: UILabel!
    @IBOutlet weak var horaireMercrediLabel: UILabel!
    @IBOutlet weak var horaireJeudiLabel: UILabel!
    @IBOutlet weak var horaireVendrediLabel: UILabel!
    @IBOutlet weak var horaireSamediLabel: UILabel!
    
    @IBOutlet weak var chaineSwitch: UISwitch!
    
    @IBOutlet weak var boutonSignet: UIButton!
    @IBOutlet weak var fiveStarRate: FloatRatingView!
    @IBOutlet weak var siteWebButton: UIButton!
    
    
    
    @IBOutlet weak var commentairesTextView: UITextView!
    
    
    
    
    
    
    
    //@IBOutlet weak var nameTF: UITextField! { didSet { nameTF.delegate = self } }
    /*
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
*/

    /*
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                //label.text = detail.description
                label.text = "Allo"
                //label.text = detail.nom
            }
        }
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        detailScrollView.contentSize.height = 1000
        
        
        
        self.fiveStarRate.delegate = self
        self.fiveStarRate.contentMode = UIViewContentMode.ScaleAspectFit
        
        commentairesTextView?.delegate = self
        
        if let unRestaurant = itemToEdit {
            title = "Edit Item"
            
            
            // Optional params
            
            /*
            self.fiveStarRate.maxRating = 5
            self.fiveStarRate.minRating = 1
            self.fiveStarRate.rating = 2.0
            self.fiveStarRate.editable = true
            self.fiveStarRate.halfRatings = false
            self.fiveStarRate.floatRatings = false
*/
            
            
            nomLabel.text = unRestaurant.nom
            
            
            poutineLabel.text = unRestaurant.poutine
            
            
            descriptionTextView.text = unRestaurant.itemDescription
            commentairesTextView.text = unRestaurant.commentaire
            
            fiveStarRate.rating = unRestaurant.note
            
            adresseLabel.text = unRestaurant.adresse
            villeLabel.text = unRestaurant.ville
            codePostalLabel.text = unRestaurant.codePostal
            phoneLabel.text = unRestaurant.phone
            
            horaireDimancheLabel.text = unRestaurant.dimanche
            horaireLundiLabel.text = unRestaurant.lundi
            horaireMardiLabel.text = unRestaurant.mardi
            horaireMercrediLabel.text = unRestaurant.mercredi
            horaireJeudiLabel.text = unRestaurant.jeudi
            horaireVendrediLabel.text = unRestaurant.vendredi
            horaireSamediLabel.text = unRestaurant.samedi
            
            if unRestaurant.chaine {
                chaineSwitch.setOn(true, animated:true)
            } else {
                chaineSwitch.setOn(false, animated:true)
            }
            
            if unRestaurant.BDInitiale {
                editBarButton.enabled = false
            } else {
                editBarButton.enabled = true
            }
            
            if unRestaurant.siteWeb != "" {
                lienSiteWeb = "http://" + unRestaurant.siteWeb
                
                //lienSiteWeb = "www.apple.com"
                
                siteWebButton.setTitle(unRestaurant.siteWeb, forState: UIControlState.Normal)
                
                /*
                var rangeStrToDelete = unRestaurant.siteWeb.rangeOfString("http://")
                
                if rangeStrToDelete == nil {
                    rangeStrToDelete = unRestaurant.siteWeb.rangeOfString("https://")
                }
                
                if rangeStrToDelete != nil {
                    let libelleBouton = unRestaurant.siteWeb[Range(start: rangeStrToDelete!.endIndex, end: unRestaurant.siteWeb.endIndex)]
                    
                    siteWebButton.setTitle(libelleBouton, forState: UIControlState.Normal)
                }
                */
                
                
                
            } else {
                siteWebButton.hidden = true
            }
            
            boutonSignet.selected = unRestaurant.signet
            /*
            if unRestaurant.phone != "" {
                phoneField.text = unRestaurant.phone
            } else {
                phoneField.text = ""
            }
            */
        }
        
        //self.configureView()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
    }
    */
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        commentairesTextView.endEditing(true)
    }
    
    
    @IBAction func boutonSignetChange(sender:UIButton)
    {
        //println(sender.selected)
        sender.selected = !sender.selected;
        if sender.selected {
            print("ON")
            itemToEdit!.signet = true
            //postDidChangeNotification()
        } else {
            print("OFF")
            itemToEdit!.signet = false
        }
        
        var isUpdated = ModelManager.instance.updateRestaurantPersonnalData(itemToEdit!)
        
        //println(sender.selected)
    }
    
    @IBAction func siteWebButtonPress(sender:UIButton)
    {
        if let requestUrl = NSURL(string: lienSiteWeb   ) {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
    
    
    
    
    
    
    /*
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField == phoneField
        {
            var newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            var components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            var decimalString = "".join(components) as NSString
            var length = decimalString.length
            var hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                var newLength = (textField.text as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            var formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                var areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3
            {
                var prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            var remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            println(textField.text)
            return false
        }
        else
        {
            return true
        }
    }
    */
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        //let rate = NSString(format: "%.2f", self.floatRatingView.rating) as String
        //println(NSString(format: "%.2f", self.fiveStarRate.rating))
        //println("Rating change")
        itemToEdit!.note = self.fiveStarRate.rating
        var isUpdated = ModelManager.instance.updateRestaurantPersonnalData(itemToEdit!)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
        //print(commentairesTextView.text); //the textView parameter is the textView where text was changed
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        animateViewMoving(true, moveValue: 200)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        //print("Dans textViewDidEndEditing")
        itemToEdit!.commentaire = commentairesTextView.text
        var isUpdated = ModelManager.instance.updateRestaurantPersonnalData(itemToEdit!)
        animateViewMoving(false, moveValue: 200)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    

}



