//
//  GradeCategory.swift
//  Grades
//
//  Created by Nicholas Josephson on 2019-11-15.
//  Copyright © 2019 Nicholas Josephson. All rights reserved.
//

import SwiftUI
import CoreData

extension GradeCategory {
    var gradeArray: [Grade] {
        return (self.grades as! Set<Grade>).sorted{ $0.timestamp!.compare($1.timestamp!) == .orderedAscending }
    }
    
    func createGradeTitle() -> String {
        var result = String(self.title!)
        
        if result.last == "s" {
            result.remove(at: result.index(before: result.endIndex))
        }
        
        result += " \(self.grades!.count + 1)"
        
        return result
    }
    
    func addGrade(in managedObjectContext: NSManagedObjectContext) {
        let newGrade = Grade(context: managedObjectContext)
        newGrade.id = UUID()
        newGrade.timestamp = Date()
        newGrade.title = createGradeTitle()
        newGrade.hasAssessment = false
        newGrade.percentage = 0
        self.addToGrades(newGrade)
        self.course!.updateRange(in: managedObjectContext)
        
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func removeGrade(in managedObjectContext: NSManagedObjectContext, grade: Grade) {
        self.removeFromGrades(grade)
        self.course!.updateRange(in: managedObjectContext)

        do {
            try managedObjectContext.save()
            managedObjectContext.refreshAllObjects()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}

extension Collection where Element == GradeCategory, Index == Int {
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
