//
//  CourseDetailView.swift
//  Grades
//
//  Created by Nicholas Josephson on 2019-11-15.
//  Copyright © 2019 Nicholas Josephson. All rights reserved.
//

import SwiftUI
import CoreData

struct CourseDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var course: Course
    
    @State private var showAddCategory = false
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                HStack {
                    Spacer()
                    GradeRangeView(course: course).font(.title).padding()
                    Spacer()
                }
                ForEach(course.categoryArray, id: \.self ) { category in
                    GradeCategoryView(category: category)
                }
            }
        }
        .navigationBarTitle(Text(course.title!), displayMode: .inline)
        .navigationBarItems(
            trailing: Button(action: { self.showAddCategory = true }) { Text("Add Category") }
            .popover(isPresented: self.$showAddCategory) {
                AddCategoryView(viewContext: self.viewContext, course: self.course, showAddCategory: self.$showAddCategory)
            }
        )
    }
}

struct AddCategoryView: View {
    var viewContext: NSManagedObjectContext
    @ObservedObject var course: Course

    @Binding var showAddCategory: Bool
    @State private var newCategoryTitle = ""
    @State private var newCategoryWeight: Double = 0.0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Category Title", text: self.$newCategoryTitle)
                }
                Section {
                    VStack {
                        Text("Weight: \(newCategoryWeight, specifier: "%.0f")")
                        Slider(value: $newCategoryWeight, in: 0...100, step: 1.0 )
                    }
                }
            }
            .multilineTextAlignment(.center)
            .navigationBarTitle(Text("New Category"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: { self.showAddCategory = false }) { Text("Cancel") },
                trailing: Button(
                    action: {
                        self.showAddCategory = false
                        self.course.addGradeCategory(in: self.viewContext, title: self.newCategoryTitle, weight: Int32(self.newCategoryWeight))
                        self.newCategoryTitle = ""
                    }
                ) { Text("Add") }
                    .disabled(self.newCategoryTitle.count == 0 || self.newCategoryWeight == 0)
            )
        }
    }
}
