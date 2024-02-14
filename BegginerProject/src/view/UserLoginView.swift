//
//  UserLoginView.swift
//  BegginerProject
//
//  Created by user251257 on 2/12/24.
//

import SwiftUI

struct UserLoginView: View {
    let persistenceController = PersistenceController.shared
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    @Binding var isPresented: Bool
    @Binding var loggedUser: AppUser?
    
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .padding()
            
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .padding()
            
            Button(action: {
                if mainViewModel.authenticate(name: username, password: password, context: persistenceController.container.viewContext) {
                   //If authentication is successful
                    print("Logged as \(username)")
                    
                    loggedUser = mainViewModel.loggedInUser
                    isPresented = false
                } else {
                    //If logins are incorrect
                    print("Incorrect credentials")
                }
            }, label: {
                Text("Submit")
            })
            
            Button(action: {
                isPresented = false
            }, label: {
                Text("Cancel")
            })
        }
        .padding()
        .background(Color("ComponentBackground"))
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(width: 300, height: 200)
    }
}
