//
//  Grade.swift
//  Grades
//
//  Created by Nicholas Josephson on 2019-11-15.
//  Copyright © 2019 Nicholas Josephson. All rights reserved.
//

import SwiftUI
import CoreData

extension Grade {
    func updatePercentage(in managedObjectContext: NSManagedObjectContext, percentage: Double) {
        self.hasAssessment = true
        self.percentage = percentage
        self.category!.course!.updateRange(in: managedObjectContext)

        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func updateTitle(in managedObjectContext: NSManagedObjectContext, title: String) {
        self.title = title
        
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    static func create(in managedObjectContext: NSManagedObjectContext, title: String, percentage: Double) {
        let newGrade = self.init(context: managedObjectContext)
        newGrade.id = UUID()
        newGrade.timestamp = Date()
        newGrade.title = title
        newGrade.percentage = percentage

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

extension Collection where Element == Grade, Index == Int {
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
