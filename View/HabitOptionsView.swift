//
//  HabitOptionsView.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/14/25.
//

import SwiftUI

struct HabitOptionsView: View {
    @Environment(\.dismiss) private var dismiss

    var onSetDate: () -> Void
    var onRename: () -> Void
    var onSetGoal: () -> Void
    var onResetStreak: () -> Void
    var onResetRecord: () -> Void

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        onSetDate()
                    } label: {
                        Label("Set Start Date", systemImage: "calendar")
                    }

                    Button {
                        onRename()
                    } label: {
                        Label("Rename Habit", systemImage: "pencil")
                    }

                    Button {
                        onSetGoal()
                    } label: {
                        Label("Set Goal", systemImage: "target")
                    }

                    Button {
                        onResetStreak()
                    } label: {
                        Label("Reset Streak", systemImage: "arrow.counterclockwise")
                    }

                    Button(role: .destructive) {
                        onResetRecord()
                    } label: {
                        Label("Reset Record", systemImage: "exclamationmark.triangle")
                    }
                }
            }
            .navigationTitle("Habit Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    HabitOptionsView(
        onSetDate: {},
        onRename: {},
        onSetGoal: {},
        onResetStreak: {},
        onResetRecord: {}
    )
}
