//
//  NoteViewModel.swift
//  BegginerProject
//
//  Created by user251257 on 2/7/24.
//

import Foundation
import CoreData

class NoteViewModel: ObservableObject {
    
    @Published var navigateNoteEditor: Bool = false
    @Published var navigationNoteEditor_ListSelect: Bool = false
    
    func onNoteAddButtonClick() {
        //Switch to add note view
        
        
        navigateNoteEditor = true
    }
    
    func fetchNoteFromUUID(context: NSManagedObjectContext, uuid: UUID) -> UserNote? {
        let fetchRequest: NSFetchRequest<UserNote> = UserNote.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let notes = try context.fetch(fetchRequest)
            return notes.first
        } catch {
            print("Error while retrieving note with uuid \(uuid), please try again...")
            return nil
        }
        
    }
    
    func fetchNotes(author: AppUser?, context: NSManagedObjectContext) -> [UserNote] {
        let fetchRequest: NSFetchRequest<UserNote> = UserNote.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "author == %@", author!)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Task failed successfully ! \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteNote(uuid: UUID, context: NSManagedObjectContext) -> Bool {
        context.delete(fetchNoteFromUUID(context: context, uuid: uuid)!)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func updateNote(author: AppUser?, title: String, content: String, uuid: UUID, context: NSManagedObjectContext) -> Bool{
        let note = fetchNoteFromUUID(context: context, uuid: uuid)
        
        note?.note_title = title
        note?.note_content = content
        note?.note_last_modification_date = Date() //Current date
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func addNote(author: AppUser?, title: String, content: String, context: NSManagedObjectContext) -> Bool {
        //Add note in database
        let newNote = UserNote(context: context)
        newNote.id = UUID()
        newNote.note_content = content
        newNote.note_title = title
        newNote.note_creation_date = Date()
        newNote.note_last_modification_date = Date()
        newNote.author = author
        
        do {
            try context.save()
            print("Note \(title) has been saved successfully !")
            return true
        } catch {
            print("An error as occured : \(error.localizedDescription)")
            return false
        }
    }
}



