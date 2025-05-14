//
//  HabitView.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/13/25.
//

import SwiftUI

struct HabitView: View {
    @Binding var habit: Habit
    var resetAction: () -> Void
    var onDateChanged: (Date) -> Void
    var onResetRecord: () -> Void
    var onSetGoal: (Int) -> Void
    var onResetStreak: () -> Void
    @State private var showResetConfirmation = false
    @State private var isEditingDate = false
    @State private var showResetRecordConfirmation = false
    @State private var tempStartDate: Date
    @State private var showGoalSheet = false

    init(
        habit: Binding<Habit>,
        resetAction: @escaping () -> Void,
        onDateChanged: @escaping (Date) -> Void,
        onResetRecord: @escaping () -> Void,
        onSetGoal: @escaping (Int) -> Void,
        onResetStreak: @escaping () -> Void
    ) {
        self._habit = habit
        self.resetAction = resetAction
        self.onDateChanged = onDateChanged
        self.onResetRecord = onResetRecord
        self.onSetGoal = onSetGoal
        self.onResetStreak = onResetStreak
        _tempStartDate = State(initialValue: habit.wrappedValue.startDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(habit.title)
                    .font(.headline)
                Spacer()
            }

            Text("🔥 Current Streak: \(habit.daysFree) \(habit.daysFree == 1 ? "day" : "days")")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.orange)

            if let goal = habit.goalDays {
                Text("🎯 Goal: \(goal) day\(goal == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack {
                ProgressView(value: habit.goalProgress)
                    .progressViewStyle(.linear)
                    .tint(.green)
                    .scaleEffect(y: 0.6, anchor: .center)

                Spacer()

                EllipsisMenu(
                    onSetDate: { isEditingDate = true },
                    onSetGoal: { showGoalSheet = true },
                    onResetStreak: onResetStreak,
                    onResetRecord: { showResetRecordConfirmation = true }
                )
                .alert("Reset record for \(habit.title)?", isPresented: $showResetRecordConfirmation) {
                    Button("Reset", role: .destructive) {
                        onResetRecord()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("This will reset your record to your current streak of \(habit.daysFree) day\(habit.daysFree == 1 ? "" : "s").")
                }
            }
            if isEditingDate {
                DatePicker(
                    "Start Date",
                    selection: $tempStartDate,
                    in: ...Date(),
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding(.top, 8)
                .onChange(of: tempStartDate) { _, newValue in
                    onDateChanged(newValue)
                    isEditingDate = false
                }
            }

            Text("🏆 \(habit.recordDisplayText)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .sheet(isPresented: $showGoalSheet) {
            SetGoalView { goal in
                onSetGoal(goal)
            }
        }
    }
}


#Preview {
    HabitView(
        habit: .constant(Habit(id: UUID(), title: "Test Habit", startDate: Date(), isMain: false, recordDays: 5)),
        resetAction: {},
        onDateChanged: { _ in },
        onResetRecord: {},
        onSetGoal: { _ in },
        onResetStreak: {}
    )
}
