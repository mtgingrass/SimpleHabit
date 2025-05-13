//
//  MainCounterViewModel.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/13/25.
//

import Foundation
import SwiftUI

class MainCounterViewModel: ObservableObject {
    @Published var startDate: Date = UserDefaults.standard.object(forKey: "mainStartDate") as? Date ?? Date()

    var daysFree: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
    }

    var record: Int {
        // Replace with real logic later
        return daysFree // For now, record equals current streak
    }

    func resetToToday() {
        startDate = Date()
        UserDefaults.standard.set(startDate, forKey: "mainStartDate")
    }
}
