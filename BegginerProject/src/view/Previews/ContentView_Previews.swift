//
//  ContentView_Previews.swift
//  BegginerProject
//
//  Created by user251257 on 2/8/24.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    @StateObject static var mainViewModel = MainViewModel()
    
    static var previews: some View {
        ContentView().environmentObject(mainViewModel)
    }
}
