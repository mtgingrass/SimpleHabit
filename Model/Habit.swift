//
//  Habit.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/13/25.
//

import Foundation

struct Habit: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var startDate: Date
    var goalDays: Int? = nil
    
    var isMain: Bool = false
    var recordDays: Int = 1
    
    var daysFree: Int {
        let startOfStartDate = Calendar.current.startOfDay(for: startDate)
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let days = Calendar.current.dateComponents([.day], from: startOfStartDate, to: startOfToday).day ?? 0
        return days + 1
    }
    var recordDisplayText: String {
        "Record: \(recordDays) day" + (recordDays == 1 ? "" : "s")
    }
    var streakProgress: Double {
        guard recordDays > 0 else { return 0 }
        return min(Double(daysFree) / Double(recordDays), 1.0)
    }
    
    var goalProgress: Double {
        guard let goal = goalDays, goal > 0 else { return 0 }
        return min(Double(daysFree) / Double(goal), 1.0)
    }
}
