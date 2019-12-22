//
//  CoursesListView.swift
//  Grades
//
//  Created by Nicholas Josephson on 2019-11-15.
//  Copyright © 2019 Nicholas Josephson. All rights reserved.
//

import SwiftUI
import CoreData

struct CoursesListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Course.timestamp, ascending: false)]) var courses: FetchedResults<Course>
    
    @State private var showAddCourse = false
    @State private var newCourseTitle = ""

    var body: some View {
        List {
            ForEach(courses, id: \.self) { course in
                NavigationLink(destination: CourseDetailView(course: course)) {
                    Image(systemName: "book.fill")
                    VStack(alignment: .leading) {
                        Text(course.title!)
                        GradeRangeView(course: course)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
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
            trailing: Button(action: { self.showAddCourse = true }) { Text("Add Course") }
            .popover(isPresented: self.$showAddCourse) {
                AddCourseView(viewContext: self.viewContext, showAddCourse: self.$showAddCourse)
            }
        )
    }
}

struct AddCourseView: View {
    var viewContext: NSManagedObjectContext

    @Binding var showAddCourse: Bool
    @State private var newCourseTitle = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Course Title", text: self.$newCourseTitle)
                .multilineTextAlignment(.center)
            }
            .navigationBarTitle(Text("New Course"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: { self.showAddCourse = false }) { Text("Cancel") },
                trailing: Button(
                    action: {
                        self.showAddCourse = false
                        Course.create(in: self.viewContext, title: self.newCourseTitle)
                        self.newCourseTitle = ""
                    }
                ) { Text("Add") }
                .disabled(self.newCourseTitle.count == 0)
            )
        }
    }
}
