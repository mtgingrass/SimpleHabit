//
//  HabitView.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/13/25.
//

import SwiftUI

struct HabitView: View {
    var habit: Habit
    var resetAction: () -> Void
    var onDateChanged: (Date) -> Void
    var onResetRecord: () -> Void
    @State private var showResetConfirmation = false
    @State private var isEditingDate = false
    @State private var showResetRecordConfirmation = false
    @State private var tempStartDate: Date

    init(habit: Habit, resetAction: @escaping () -> Void, onDateChanged: @escaping (Date) -> Void, onResetRecord: @escaping () -> Void) {
        self.habit = habit
        self.resetAction = resetAction
        self.onDateChanged = onDateChanged
        self.onResetRecord = onResetRecord
        _tempStartDate = State(initialValue: habit.startDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(habit.title)
                    .font(.headline)
                Spacer()
                Button(action: {
                    showResetConfirmation = true
                }) {
                    Text("Reset to Day 1")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                .alert("Reset \(habit.title)?", isPresented: $showResetConfirmation) {
                    Button("Reset", role: .destructive) {
                        resetAction()
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }

            Text("🔥 Current Streak: \(habit.daysFree) \(habit.daysFree == 1 ? "day" : "days")")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.orange)

            HStack {
                ProgressView(value: habit.streakProgress)
                    .progressViewStyle(.linear)
                    .tint(.green)
                    .scaleEffect(y: 0.6, anchor: .center)

                Spacer()

                Menu {
                    Button(role: .destructive) {
                        showResetRecordConfirmation = true
                    } label: {
                        Label("⚠️ Reset Record", systemImage: "exclamationmark.triangle")
                    }
                    Button("Set Date Manually") {
                        isEditingDate = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .foregroundColor(.primary)
                }
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
    }
}


#Preview {
    HabitView(
        habit: Habit(id: UUID(), title: "Test Habit", startDate: Date(), isMain: false, recordDays: 5),
        resetAction: {},
        onDateChanged: { _ in },
        onResetRecord: {}
    )
}
