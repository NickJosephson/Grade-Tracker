//
//  ContentView.swift
//  Grades
//
//  Created by Nicholas Josephson on 2019-11-08.
//  Copyright © 2019 Nicholas Josephson. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {        
    var body: some View {
        NavigationView {
            CoursesListView()
            Text("No Course Selected")
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
