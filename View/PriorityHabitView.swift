import SwiftUI

struct PriorityHabitView: View {
    var habit: Habit
    var tempDate: Date
    var onDateChanged: (Date) -> Void
    var onReset: () -> Void
    var onResetRecord: () -> Void
    var onSetGoal: (Int) -> Void
    var onResetStreak: () -> Void
    @State private var showResetConfirmation = false
    @State private var showTipJar = false
    @State private var isEditingDate = false
    @State private var showResetRecordConfirmation = false
    @State private var showGoalSheet = false

    var body: some View {
        VStack(spacing: 4) {
            Text(habit.title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Day \(habit.daysFree)")
                .font(.system(size: 52, weight: .bold))
            if let goal = habit.goalDays {
                Text("of \(goal) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Text("🏆 \(habit.recordDisplayText)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
            ProgressView(value: habit.goalProgress, total: 1)
                .progressViewStyle(.linear)
                .tint(.green)
                .padding(.top, 4)

            HStack {
                Spacer()
                EllipsisMenu(
                    onSetDate: { isEditingDate = true },
                    onSetGoal: { showGoalSheet = true },
                    onResetStreak: { showResetConfirmation = true },
                    onResetRecord: { showResetRecordConfirmation = true }
                )
            }
            if isEditingDate {
                DatePicker(
                    "Start Date",
                    selection: Binding(
                        get: { tempDate },
                        set: { newDate in
                            onDateChanged(newDate)
                            isEditingDate = false
                        }
                    ),
                    in: ...Date(),
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding(.top, 8)
            }

            HStack {
                Button(action: {
                    showTipJar = true
                }) {
                    Label("Tip Jar", systemImage: "heart.fill")
                        .font(.caption)
                        .foregroundColor(.pink)
                }

                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: UIColor.secondarySystemBackground))
        )
        .padding(.horizontal)
        .padding(.top, -8)
        .sheet(isPresented: $showTipJar) {
            TipJarView()
        }
        .alert("Reset record for \(habit.title)?", isPresented: $showResetRecordConfirmation) {
            Button("Reset", role: .destructive) {
                onResetRecord()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will reset your record to your current streak of \(habit.daysFree) day\(habit.daysFree == 1 ? "" : "s").")
        }
        .sheet(isPresented: $showGoalSheet) {
            SetGoalView { goal in
                onSetGoal(goal)
            }
        }
    }
}

#Preview {
    PriorityHabitView(
        habit: Habit(id: UUID(), title: "Priority Habit", startDate: Date(), isMain: true, recordDays: 5),
        tempDate: Date(),
        onDateChanged: { _ in },
        onReset: {},
        onResetRecord: {},
        onSetGoal: { _ in },
        onResetStreak: {}
    )
}
