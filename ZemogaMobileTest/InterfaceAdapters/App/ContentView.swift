//
//  ContentView.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 11/05/22.
//

import SwiftUI

struct ContentView: View {
    
    let view: AnyView?
    
    var body: some View {
        NavigationView {
            self.view
        }
    }
    
    init(view: AnyView? = nil) {
        self.view = view
    }
}
