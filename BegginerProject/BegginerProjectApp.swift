//
//  BegginerProjectApp.swift
//  BegginerProject
//
//  Created by user251257 on 1/29/24.
//

import SwiftUI

@main
struct BegginerProjectApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ContentView().environmentObject(MainViewModel()).environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            } else {
                NavigationView {
                    ContentView().environmentObject(MainViewModel()).environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
        }
    }
}
