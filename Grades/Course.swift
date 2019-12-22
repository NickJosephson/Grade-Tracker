//
//  Course.swift
//  Grades
//
//  Created by Nicholas Josephson on 2019-11-08.
//  Copyright © 2019 Nicholas Josephson. All rights reserved.
//

import SwiftUI
import CoreData

extension Course {
    var categoryArray: [GradeCategory] {
        return (self.categories as! Set<GradeCategory>).sorted{ $0.timestamp!.compare($1.timestamp!) == .orderedAscending }
    }
    
    func updateRange(in managedObjectContext: NSManagedObjectContext) {
        var min = 0.0
        var max = 100.0
        
        for category in self.categoryArray {
            let grades = category.gradeArray
            let gradeWeight: Double = Double(category.weight) / Double(grades.count)
            
            for grade in grades {
                if grade.hasAssessment {
                    let pointsGained = gradeWeight * (grade.percentage / 100)
                    let pointsLost = gradeWeight - pointsGained
                    min += pointsGained
                    max -= pointsLost
                }
            }
            
            self.min = Int32(min)
            self.max = Int32(max)

            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func create(in managedObjectContext: NSManagedObjectContext, title: String) {
        let newCourse = self.init(context: managedObjectContext)
        newCourse.id = UUID()
        newCourse.timestamp = Date()
        newCourse.title = title
        newCourse.min = 0
        newCourse.max = 100
        
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }   

    func addGradeCategory(in managedObjectContext: NSManagedObjectContext, title: String, weight: Int32) {
        let newGradeCategory = GradeCategory(context: managedObjectContext)
        newGradeCategory.timestamp = Date()
        newGradeCategory.title = title
        newGradeCategory.weight = weight
        self.addToCategories(newGradeCategory)
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

extension Collection where Element == Course, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach { managedObjectContext.delete(self[$0]) }       
 
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
