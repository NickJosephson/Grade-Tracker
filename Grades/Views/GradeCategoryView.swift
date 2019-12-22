//
//  GradeCategoryView.swift
//  Grades
//
//  Created by Nicholas Josephson on 2019-11-15.
//  Copyright © 2019 Nicholas Josephson. All rights reserved.
//

import SwiftUI

struct GradeCategoryView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var category: GradeCategory
    @State var refresh: Bool = false

    var body: some View {
        Section(
            header: HStack {
                Text("\(category.weight)% \(category.title!)")
                Text(self.refresh ? "" : "")
                Spacer()
                Button(action: {
                    self.category.addGrade(in: self.viewContext)
                    self.refresh.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
            .font(.headline)
        ) {
            ForEach(category.gradeArray, id: \.self) { grade in
                NavigationLink(destination: GradeEditView(grade: grade)) {
                    HStack {
                        Image(systemName: "rosette")
                        Text(grade.title!)
                        Spacer()
                        Text(grade.hasAssessment ? "\(grade.percentage, specifier: "%.0f")%" : "")
                    }
                }
            }
            .onDelete { indices in
                indices.forEach { self.category.removeGrade(in: self.viewContext, grade: self.category.gradeArray[$0])}
                self.refresh.toggle()
            }
        }
    }
}

struct GradeEditView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var grade: Grade
    
    @State private var newGradeTitle = ""
    @State private var newGradePercentage = 0.0
    
    var body: some View {
        Form {
            Section {
                TextField(self.grade.title!, text: self.$newGradeTitle)
                .multilineTextAlignment(.center)
            }
            Section {
                VStack {
                    Text("Percentage: \(newGradePercentage, specifier: "%.0f")")
                    Slider(value: $newGradePercentage, in: 0...100, step: 1.0 )
                }
            }
        }
        .onDisappear(perform: {
            if self.newGradePercentage > 0 {
                self.grade.updatePercentage(in: self.viewContext, percentage: self.newGradePercentage)
            }
            if self.newGradeTitle != "" {
                self.grade.updateTitle(in: self.viewContext, title: self.newGradeTitle)
            }
        })
        .navigationBarTitle(Text(self.grade.title!), displayMode: .inline)
    }
}
