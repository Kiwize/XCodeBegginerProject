//
//  NoteView_Previews.swift
//  BegginerProject
//
//  Created by user251257 on 2/8/24.
//

import SwiftUI

struct NoteView_Previews: PreviewProvider {
    @StateObject static var noteViewModel = NoteViewModel()
    
    static var previews: some View {
        NoteView().environmentObject(noteViewModel)
    }
}
