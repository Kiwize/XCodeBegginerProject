//
//  MainViewModel.swift
//  BegginerProject
//
//  Created by user251257 on 2/8/24.
//

import Foundation
import CoreData

class MainViewModel: ObservableObject {
    
    @Published var navigateToNotesMenu = false
    
    var loggedInUser: AppUser? = nil
    
    func onNotesButtonClick() {
        if loggedInUser != nil {
            navigateToNotesMenu = true
        } else {
            print("User needs to be logged in !")
            //Trigger error popup, user needs to be logged in
        }
    }
    
    func authenticate(name: String, password: String, context: NSManagedObjectContext) -> Bool{
        let fetchRequest: NSFetchRequest<AppUser> = AppUser.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "user_name == %@ AND user_password == %@", name, password)
        
        do {
            //Connect user
            let results = try context.fetch(fetchRequest)
            if results.first != nil {
                loggedInUser = results.first
                return true
            }
            
            return false
        } catch {
            //Trigger error popup to show invalid password or username
            return false
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return loggedInUser != nil
    }
    
    func logout() {
        loggedInUser = nil
    }
    
    func createDummyUser(context: NSManagedObjectContext) {
        let dummy = AppUser(context: context)
        dummy.user_name = "Thomas"
        dummy.user_password = "Thomas"
        
        do {
            try context.save()
        } catch {
            print("Fail to create dummy user")
        }
    }
    
    
    
}
