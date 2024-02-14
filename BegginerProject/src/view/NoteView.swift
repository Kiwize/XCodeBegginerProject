//
//  NoteView.swift
//  BegginerProject
//
//  Created by user251257 on 2/7/24.
//

import SwiftUI

struct NoteView: View {
    let persistenceController = PersistenceController.shared
    
    @State var selectedNoteUUID: UUID = UUID()
    @State var notes: [UserNote] = []
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var noteViewModel: NoteViewModel
    
    var body: some View {
        HStack {
            Text("Notes").onAppear(){
                notes = noteViewModel.fetchNotes(author: mainViewModel.loggedInUser, context: persistenceController.container.viewContext)
                noteViewModel.navigateNoteEditor = false
                noteViewModel.navigationNoteEditor_ListSelect = false
                mainViewModel.navigateToNotesMenu = false
            }
            Spacer()
            Button(action: {
                noteViewModel.onNoteAddButtonClick()
            }, label: {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.primary)
            }).background() {
                NavigationLink(
                    "", destination:
                        NoteView_Editor()
                        .environmentObject(noteViewModel)
                        .environmentObject(mainViewModel)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext),
                    isActive:
                        $noteViewModel.navigateNoteEditor
                )
            }
        }
        Spacer()
        VStack {
            //Show list of saved notes
            List {
                ForEach(notes, id: \.self) { note in
                    HStack {
                        Text(note.note_title ?? "Unnamed note")
                            .onTapGesture {
                                selectedNoteUUID = note.id!
                                noteViewModel.navigationNoteEditor_ListSelect = true
                                //print("Selected note : \(note.id)")
                            }
                        
                        Spacer()
                        
                        Button(action: {
                            //Delete selected note
                        }, label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                        }).onTapGesture {
                            if(noteViewModel.deleteNote(uuid: note.id!, context: persistenceController.container.viewContext)) {
                                notes = noteViewModel.fetchNotes(author: mainViewModel.loggedInUser, context: persistenceController.container.viewContext)
                            }
                        }
                    }
                    
                }
            }.background() {
                    NavigationLink(
                        "", destination:
                            NoteView_Editor(loadedNoteUUID: selectedNoteUUID)
                            .environmentObject(noteViewModel)
                            .environmentObject(mainViewModel)
                            .environment(\.managedObjectContext, persistenceController.container.viewContext),
                        isActive:
                            $noteViewModel.navigationNoteEditor_ListSelect
                    )
                
            }
            
        }
        Spacer()
    }
}

