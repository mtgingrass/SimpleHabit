//
//  HabitListViewModel.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/13/25.
//

import Foundation

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = [
        Habit(title: "Days Free", startDate: Date(), isMain: true),
        Habit(title: "Workout", startDate: Date()),
        Habit(title: "Reading", startDate: Date())
    ]

    var mainHabit: Habit? {
        habits.first(where: { $0.isMain })
    }

    func resetStartDate(for id: UUID) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].startDate = Date()
            let updatedDays = habits[index].daysFree
            if updatedDays > habits[index].recordDays {
                habits[index].recordDays = updatedDays
            }
        }
    }

    func setMainHabit(id: UUID) {
        for index in habits.indices {
            habits[index].isMain = (habits[index].id == id)
        }
    }

    func updateStartDate(for id: UUID, to newDate: Date) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].startDate = newDate
            let updatedDays = habits[index].daysFree
            if updatedDays > habits[index].recordDays {
                habits[index].recordDays = updatedDays
            }
        }
    }
    
    func resetRecord(for id: UUID) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].recordDays = 1
        }
    }
}
