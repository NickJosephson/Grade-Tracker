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
    var body: some View {
        NavigationView {
            MasterView()
            Text("No Courses Selected")
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Course.timestamp, ascending: false)])
    var courses: FetchedResults<Course>
    @Environment(\.managedObjectContext) var viewContext
    @State private var showAddCourse = false
    @State private var newTitle = ""

    var body: some View {
        List {
            ForEach(courses, id: \.self) { course in
                NavigationLink(destination: DetailView(course: course)) {
                    
                    Image(systemName: "book.fill")
                    VStack(alignment: .leading) {
                        Text(course.title!)
                        Text("0% – 100%").font(.subheadline).foregroundColor(.secondary)
                    }.multilineTextAlignment(.leading)
                }
            }
            .onDelete { indices in
                self.courses.delete(at: indices, from: self.viewContext)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Courses"))
        .navigationBarItems(
            leading: EditButton(),
            trailing: Button(action: { self.showAddCourse = true }) {
                Image(systemName: "plus")
            }
            .padding()
            .popover(isPresented: self.$showAddCourse) {
                NavigationView {
                    Form {
                        TextField("Course Title", text: self.$newTitle)
                        .multilineTextAlignment(.center)
                    }
                    .navigationBarTitle(Text("New Course"), displayMode: .inline)
                    .navigationBarItems(
                        leading: Button(action: { self.showAddCourse = false }) { Text("Cancel") },
                        trailing: Button(
                            action: {
                                self.showAddCourse = false
                                Course.create(in: self.viewContext, title: self.newTitle)
                            }
                        ) { Text("Add") }
                        .disabled(self.newTitle.count == 0)
                    )
                }
            }
        )
    }
}

struct DetailView: View {
    @ObservedObject var course: Course
    @State private var steps = 10
    
    var body: some View {
        VStack(spacing: 0) {
            Text("0% – 100%").font(.title).padding()
            List {
                ForEach(0..<5) { bar in
                    Section(header: Stepper("Assignments", value: self.$steps)) {
                        ForEach(0..<5) { foo in
                            HStack {
                                Text("Assignment 1")
                                Spacer(minLength: 0)
                                Text("100%")
                                //Text("\(self.course.timestamp!, formatter: dateFormatter)")
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(course.title!), displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
