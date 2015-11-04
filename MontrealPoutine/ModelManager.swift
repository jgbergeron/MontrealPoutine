//
//  ModelManager.swift
//  DataBaseDemo
//
//  Created by Krupa-iMac on 05/08/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

let sharedInstance = ModelManager()

class ModelManager: NSObject {
    
    
    var database: FMDatabase? = nil
    
    class var instance: ModelManager {
        sharedInstance.database = FMDatabase(path: Util.getPath("MTL_poutine.sqlite"))
        let path = Util.getPath("MTL_poutine.sqlite")
            //54D70B97-F386-4746-9A69-692E339668B8
        print("path : \(path)")
        return sharedInstance
    }
    
    func addRestaurantData(unRestaurant: EntiteeItem) -> Bool {
        
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Restaurant (RestaurantID, Nom, nom_pour_tri, Logo, Adresse, Ville, Province, Code_Postal, Phone, Poutine_vedette, Fichier_carte, latitude, longitude, note, description, commentaire, bd_initiale, site_web, chaine, signet, coup_de_coeur, cell_background, vaut_le_detour, pw_participe, pw_poutine, pw_prix) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [unRestaurant.itemID, unRestaurant.nom, unRestaurant.nomPourTri, unRestaurant.logo, unRestaurant.adresse, unRestaurant.ville, unRestaurant.province, unRestaurant.codePostal, unRestaurant.phone, unRestaurant.poutine, unRestaurant.fichierCarte, unRestaurant.itemLatitude, unRestaurant.itemLongitude, unRestaurant.note, unRestaurant.itemDescription, unRestaurant.commentaire, 0, unRestaurant.siteWeb, 0, 0, 0, unRestaurant.cellBackground, 0, 0, "PW Poutine", "PW Prix"])
        sharedInstance.database!.close()

        return isInserted
        
        //return true
    }
   
    func updateRestaurantData(unRestaurant: EntiteeItem) -> Bool {
        
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Restaurant SET Nom=? WHERE RestaurantID=?", withArgumentsInArray: [unRestaurant.nom, unRestaurant.itemID])
        sharedInstance.database!.close()

        return isUpdated
        
        //return true
    }
    
    func updateRestaurantPersonnalData(unRestaurant: EntiteeItem) -> Bool {
        
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Restaurant SET note=?, commentaire=?, signet=?  WHERE RestaurantID=?", withArgumentsInArray: [unRestaurant.note, unRestaurant.commentaire, unRestaurant.signet, unRestaurant.itemID])
        sharedInstance.database!.close()
        
        return isUpdated
        
        //return true
    }
    
    func deleteRestaurantData(unRestaurant: EntiteeItem) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Restaurant WHERE RestaurantID=?", withArgumentsInArray: [unRestaurant.itemID])
        sharedInstance.database!.close()
        return isDeleted
    }

    func getAllStudentData() {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM StudentInfo", withArgumentsInArray: nil)
        let rollNoColumn: String = "student_rollno"
        let nameColumn: String = "student_name"
        if (resultSet != nil) {
            while resultSet.next() {
                print("roll no : \(resultSet.stringForColumn(rollNoColumn))")
                print("name : \(resultSet.stringForColumn(nameColumn))")
            }
        }
        sharedInstance.database!.close()
    }
    
}
