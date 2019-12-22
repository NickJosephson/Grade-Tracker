//
//  GradeRangeView.swift
//  Grades
//
//  Created by Nicholas Josephson on 2019-11-15.
//  Copyright © 2019 Nicholas Josephson. All rights reserved.
//

import SwiftUI

struct GradeRangeView: View {
    @ObservedObject var course: Course
    
    var body: some View {
        HStack {
            if (self.course.max - self.course.min) < 1 {
                Text("\(self.course.max)%")
            } else {
                Text("\(self.course.min)% - \(self.course.max)%")
            }
        }
    }
}

//Button(action: {
//    let newg = GradeCategory(context: self.viewContext)
//    newg.title = "bob"
//    self.course.addToCategories(newg)
//    let test = self.course.categories!.anyObject()!
//    print(type(of: test))
//}, label: {Text("test")})

//TextField("0%", value: self.$grade, formatter: discretePercentageFormatter)
//Text("\(self.course.timestamp!, formatter: dateFormatter)")

//"Assignment \(foo + 1)"

//private let dateFormatter: DateFormatter = {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = .medium
//    dateFormatter.timeStyle = .medium
//    return dateFormatter
//}()
//
//private let discretePercentageFormatter: NumberFormatter = {
//    let discretePercentageFormatter = NumberFormatter()
//    discretePercentageFormatter.allowsFloats = true
//    discretePercentageFormatter.minimum = 0
//    discretePercentageFormatter.maximum = 100
//    discretePercentageFormatter.isLenient = true
//    return discretePercentageFormatter
//}()
