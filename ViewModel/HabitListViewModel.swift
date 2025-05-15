//
//  HabitListViewModel.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/13/25.
//

import Foundation

class HabitListViewModel: ObservableObject {
    private let habitsKey = "savedHabits"
    @Published var habits: [Habit] = []

    var mainHabit: Habit? {
        habits.first(where: { $0.isMain })
    }
    
    init() {
        // Temporarily clear stored habits to force default list on next launch
        //UserDefaults.standard.removeObject(forKey: habitsKey)
        habits = loadHabits()
    }

    func resetStartDate(for id: UUID) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].startDate = Date()
            let updatedDays = habits[index].daysFree
            if updatedDays > habits[index].recordDays {
                habits[index].recordDays = updatedDays
            }
            saveHabits()
        }
    }

    func setMainHabit(id: UUID) {
        for index in habits.indices {
            habits[index].isMain = (habits[index].id == id)
        }
        saveHabits()
    }

    func updateStartDate(for id: UUID, to newDate: Date) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].startDate = newDate
            let updatedDays = habits[index].daysFree
            if updatedDays > habits[index].recordDays {
                habits[index].recordDays = updatedDays
            }
            saveHabits()
        }
    }

    func updateGoal(for id: UUID, to goal: Int?) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].goalDays = (goal ?? 0) > 0 ? goal : nil
            saveHabits()
        }
    }
    
    func resetRecord(for id: UUID) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].recordDays = max(habits[index].daysFree, 1)
            saveHabits()
        }
    }

    func updateTitle(for id: UUID, to newTitle: String) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].title = newTitle
            saveHabits()
        }
    }

    private func saveHabits() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: habitsKey)
        }
    }

    private func loadHabits() -> [Habit] {
        if let data = UserDefaults.standard.data(forKey: habitsKey),
           let saved = try? JSONDecoder().decode([Habit].self, from: data) {
            return saved
        }
        return [
            Habit(id: UUID(), title: "Days Free", startDate: Date(), isMain: true),
            Habit(id: UUID(), title: "Workout", startDate: Date()),
            Habit(id: UUID(), title: "Reading", startDate: Date()),
            Habit(id: UUID(), title: "Test", startDate: Date())
        ]
    }
}
