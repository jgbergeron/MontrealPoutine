//
//  EntiteeItem.swift
//  MontrealPoutine
//
//  Created by Jean-Guy Bergeron on 2015-05-04.
//  Copyright (c) 2015 Jean-Guy Bergeron. All rights reserved.
//

import Foundation

let WhatsitDidChangeNotification = "MyEntiteeDidChange"

class EntiteeItem: NSObject {
    var itemID: Int
    var nom: String
    
    
    var nomPourTri: String
    var logo: String
    var adresse: String
    var ville: String
    var province: String
    var codePostal: String
    var phone: String
    var poutine: String
    var fichierCarte: String
    var itemLatitude: Float
    var itemLongitude: Float
    var note: Float {
        didSet {
            postDidChangeNotification()
        }
    }
    var itemDescription: String
    var commentaire: String
    var BDInitiale: Bool
    var siteWeb: String
    var chaine: Bool
    var signet: Bool {
        didSet {
            postDidChangeNotification()
        }
    }
    var coupDeCoeur: Bool
    var cellBackground: String
    var vautLeDetour: Bool
    var adresseGPS: String
    var dimanche: String
    var lundi: String
    var mardi: String
    var mercredi: String
    var jeudi: String
    var vendredi: String
    var samedi: String
    //var section: Int?

    //var sectionNumber: Int?
    
    
    
    init(
        itemID: Int,
        nom: String,
        
        
        nomPourTri: String,
        logo: String,
        adresse: String,
        ville: String,
        province: String,
        codePostal: String,
        phone: String,
        poutine: String,
        fichierCarte: String,
        itemLatitude: Float,
        itemLongitude: Float,
        note: Float,
        itemDescription: String,
        commentaire: String,
        BDInitiale: Bool,
        siteWeb: String,
        chaine: Bool,
        signet: Bool,
        coupDeCoeur: Bool,
        cellBackground: String,
        vautLeDetour: Bool,
        adresseGPS: String,
        dimanche: String,
        lundi: String,
        mardi: String,
        mercredi: String,
        jeudi: String,
        vendredi: String,
        samedi: String
        
        //sectionNumber: Int?
        ) {
            
        self.itemID = itemID
        self.nom = nom
    
    
        self.nomPourTri = nomPourTri
        self.logo = logo
        self.adresse = adresse
        self.ville = ville
        self.province = province
        self.codePostal = codePostal
        self.phone = phone
        self.poutine = poutine
        self.fichierCarte = fichierCarte
        self.itemLatitude = itemLatitude
        self.itemLongitude = itemLongitude
        self.note = note
        self.itemDescription = itemDescription
        self.commentaire = commentaire
        self.BDInitiale = BDInitiale
        self.siteWeb = siteWeb
        self.chaine = chaine
        self.signet = signet
        self.coupDeCoeur = coupDeCoeur
        self.cellBackground = cellBackground
        self.vautLeDetour = vautLeDetour
        self.adresseGPS = adresseGPS
        self.dimanche = dimanche
        self.lundi = lundi
        self.mardi = mardi
        self.mercredi = mercredi
        self.jeudi = jeudi
        self.vendredi = vendredi
        self.samedi = samedi
        
        

        //self.sectionNumber = sectionNumber
        super.init()
            
            
        /*
            
            var itemID: Int
            var nom: String
            var nomDansLeTexte: String
            var logo: String
            var adresse: String
            var ville: String
            var province: String
            var codePostal: String
            var phone: String
            var poutine: String
            var fichierCarte: String
            var itemLatitude: Float
            var itemLongitude: Float
            var note: Float
            var itemDescription: String
            var commentaire: String
            var BDInitiale: Int
            var siteWeb: String
            var chaine: Int
            var signet: Int
            var coupDeCoeur: Int
            var cellBackground: String
            var vautLeDetour: Int
init(itemID: Int,
nom: String,
nomDansLeTexte: String,
logo: String,
adresse: String,
ville: String,
province: String,
codePostal: String,
phone: String,
poutine: String,
fichierCarte: String,
itemLatitude: Float,
itemLongitude: Float,
note: Float,
itemDescription: String,
commentaire: String,
BDInitiale: Int,
siteWeb: String,
chaine: Int,
signet: Int,
coupDeCoeur: Int,
cellBackground: String,
vautLeDetour: Int) {

self.itemID = itemID
self.nom = nom
self.nomDansLeTexte = nomDansLeTexte
self.logo = logo
self.adresse = adresse
self.ville = ville
self.province = province
self.codePostal = codePostal
self.phone = phone
self.poutine = poutine
self.fichierCarte = fichierCarte
self.itemLatitude = itemLatitude
self.itemLongitude = itemLongitude
self.note = note
self.itemDescription = itemDescription
self.commentaire = commentaire
self.BDInitiale = BDInitiale
self.siteWeb = siteWeb
self.chaine = chaine
self.signet = signet
self.coupDeCoeur = coupDeCoeur
self.cellBackground = cellBackground
self.vautLeDetour = vautLeDetour

*/
    }

    override var description: String {
        //return "\(nom) \(poutine) )"
        return "\(nom) )"
    }
    
    func postDidChangeNotification() {
        let center = NSNotificationCenter.defaultCenter()
        print("Dans postDidChangeNotification")
        center.postNotificationName(WhatsitDidChangeNotification, object: self)
    }
}