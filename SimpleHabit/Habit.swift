//
//  Habit.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/13/25.
//

import Foundation

struct Habit: Identifiable {
    let id: UUID = UUID()
    var title: String
    var startDate: Date
    
    var isMain: Bool = false
    var recordDays: Int = 1
    
    var daysFree: Int {
        let startOfStartDate = Calendar.current.startOfDay(for: startDate)
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let days = Calendar.current.dateComponents([.day], from: startOfStartDate, to: startOfToday).day ?? 0
        return days + 1
    }
}
