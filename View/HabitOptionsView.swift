//
//  HabitOptionsView.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/14/25.
//

import SwiftUI

struct HabitOptionsView: View {
    @Environment(\.dismiss) private var dismiss

    var onRename: () -> Void
    var onSetGoal: () -> Void
    var onResetStreak: () -> Void
    var onResetRecord: () -> Void

    var body: some View {
        NavigationView {
            List {
                Section {
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
        onRename: {},
        onSetGoal: {},
        onResetStreak: {},
        onResetRecord: {}
    )
}
