//
//  ContentView.swift
//  Grades
//
//  Created by Nicholas Josephson on 2019-11-08.
//  Copyright © 2019 Nicholas Josephson. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext   
 
    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text("Courses"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation { Course.create(in: self.viewContext) }
                        }
                    ) { 
                        Image(systemName: "plus")
                    }
                )
            Text("Detail view content goes here")
                .navigationBarTitle(Text("Detail"))
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.timestamp, ascending: true)],
        animation: .default)
    var Courses: FetchedResults<Course>

    @Environment(\.managedObjectContext)
    var viewContext

    var body: some View {
        List {
            ForEach(Courses, id: \.self) { Course in
                NavigationLink(
                    destination: DetailView(Course: Course)
                ) {
                    Text("\(Course.timestamp!, formatter: dateFormatter)")
                }
            }.onDelete { indices in
                self.Courses.delete(at: indices, from: self.viewContext)
            }
        }
    }
}

struct DetailView: View {
    @ObservedObject var Course: Course

    var body: some View {
        Text("\(Course.timestamp!, formatter: dateFormatter)")
            .navigationBarTitle(Text("Detail"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
