//
//  NoteView_Editor.swift
//  BegginerProject
//
//  Created by user251257 on 2/8/24.
//

import SwiftUI
import CoreData

struct NoteView_Editor: View {
    var loadedNoteUUID: UUID? = nil //Display a blank note by default
    
    @State private var noteContent: String = ""
    @State private var noteTitle: String = ""
    
    @State private var showingAlert = false
    @State private var errorMessage = "An error as occured, please try again..."
    
    //Width and height of current screen
    var containerWidth:CGFloat = UIScreen.main.bounds.width - 32.0
    var containerHeight:CGFloat = UIScreen.main.bounds.height - 32.0
    
    @EnvironmentObject var noteViewModel: NoteViewModel
    @EnvironmentObject var mainViewModel: MainViewModel
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            Text("Notes").onAppear {
                noteViewModel.navigateNoteEditor = false
                //Check if there is a note to display in the fields
                if loadedNoteUUID != nil {
                    let loadedNote = noteViewModel.fetchNoteFromUUID(context: context, uuid: loadedNoteUUID ?? UUID())
                                        
                    noteTitle = (loadedNote?.note_title)!
                    noteContent = (loadedNote?.note_content)!
                }
            }
            
            TextField("Note title :", text: $noteTitle)
                .frame(
                    width: containerWidth * 0.8,
                    height: containerHeight * 0.03
                )
                .padding(.all, 15.0)
                .background() {
                    Rectangle()
                        .cornerRadius(15)
                        .foregroundColor(Color("ComponentBackground"))
                }
            
            TextEditor(text: $noteContent)
                .scrollContentBackground(.hidden)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                .frame(
                    width: containerWidth * 0.8,
                    height: containerHeight * 0.65,
                    alignment: .topLeading
                )
                .padding(.all, 15.0)
                .background() {
                    Rectangle()
                        .cornerRadius(15)
                        .foregroundColor(Color("ComponentBackground"))
                }
            Button(
                action: {
                    if loadedNoteUUID != nil { //If note already exists, we try to update it
                        if noteViewModel.updateNote(author: mainViewModel.loggedInUser, title: noteTitle, content: noteContent, uuid: loadedNoteUUID!, context: context) {
                            noteViewModel.navigateNoteEditor = true
                        } else {
                            self.errorMessage = "Note updating failed."
                            self.showingAlert = true
                        }
                    } else {
                        if noteViewModel.addNote(author: mainViewModel.loggedInUser, title: noteTitle, content: noteContent, context: context) {
                            //If it succeed
                            noteViewModel.navigateNoteEditor = true
                        } else {
                            //If the note cannot be created, display an error
                            self.errorMessage = "Note creation failed."
                            self.showingAlert = true
                        }
                    }
                    
                    
                }, label: {
                    Text("Sauvegarder")
                }
            ).background() {
                NavigationLink(
                    "", destination:
                        NoteView()
                        .environmentObject(noteViewModel)
                        .environmentObject(mainViewModel)
                        .environment(\.managedObjectContext, context),
                    isActive:
                        $noteViewModel.navigateNoteEditor
                )
            }.alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        }
        
        Spacer()
    }
}



#Preview {
    NoteView_Editor()
}
