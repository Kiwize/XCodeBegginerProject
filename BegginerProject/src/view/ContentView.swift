//
//  ContentView.swift
//  BegginerProject
//
//  Created by user251257 on 1/29/24.
//

import SwiftUI

struct ContentView: View {
    let persistenceController = PersistenceController.shared
    
    //Width and height of current screen
    var containerWidth:CGFloat = UIScreen.main.bounds.width - 32.0
    var containerHeight:CGFloat = UIScreen.main.bounds.height - 32.0
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject private var noteViewModel = NoteViewModel()
    
    @State var showingLoginPopup: Bool = false
    @State var loggedUser: AppUser? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(.init(srgbRed: 0.2, green: 0, blue: 0.6, alpha: 1.0))]), startPoint: /*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.bottomTrailing/*@END_MENU_TOKEN@*/).edgesIgnoringSafeArea(.all).blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
            VStack {
                Text(mainViewModel.isUserLoggedIn() ? "Welcome " + (mainViewModel.loggedInUser?.user_name)! : "Welcome")
                    .fontWeight(.bold)
                    .dynamicTypeSize(.xxxLarge)
                    .foregroundColor(.primary)
                
                HStack {
                    if !mainViewModel.isUserLoggedIn() {
                        Button(action: {
                            //mainViewModel.createDummyUser(context: persistenceController.container.viewContext)
                            showingLoginPopup = true
                            
                        }, label : {
                            Text("Login")
                        })
                    } else {
                        Button(action: {
                            showingLoginPopup.toggle()
                            mainViewModel.logout()
                            loggedUser = nil
                        }, label : {
                            Text("Logout")
                        })
                    }
                }
                
                
                Spacer()
                    .frame(height: 20)
                
                Button(action: {
                    
                    mainViewModel.onNotesButtonClick()
                }, label: {
                    HStack {
                        Text("Notes")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(Color(.white))
                        Image(systemName: "note.text")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }).disabled(!mainViewModel.isUserLoggedIn())
                .background(Rectangle()
                    .foregroundColor(mainViewModel.isUserLoggedIn() ? Color("ComponentBackground") : Color("ComponentBackgroundDisabled"))
                    .cornerRadius(15)
                    .frame(width: 300, height: 40)
                    .background(
                        NavigationLink(
                            "", destination:
                                NoteView()
                                .environmentObject(NoteViewModel())
                                .environmentObject(mainViewModel)
                                .environment(\.managedObjectContext, persistenceController.container.viewContext),
                            isActive:
                                $mainViewModel.navigateToNotesMenu
                        )
                    )
                )
                Spacer()
            }
            
            
            if showingLoginPopup {
                UserLoginView(isPresented: $showingLoginPopup, loggedUser: $loggedUser)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(mainViewModel)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
