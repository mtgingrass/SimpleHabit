import SwiftUI

struct HabitView: View {
    // MARK: - Sheet management
    private enum ActiveSheet: Identifiable {
        case rename, setGoal, options, setStartDate
        var id: Int {
            switch self {
            case .rename: return 0
            case .setGoal: return 1
            case .options: return 2
            case .setStartDate: return 3
            }
        }
    }
    @Binding var habit: Habit
    var resetAction: () -> Void
    var onDateChanged: (Date) -> Void
    var onResetRecord: () -> Void
    var onSetGoal: (Int) -> Void
    var onResetStreak: () -> Void
    @State private var showResetConfirmation = false
    @State private var showResetRecordConfirmation = false
    @State private var tempStartDate: Date
    @State private var habitTitle: String
    @State private var activeSheet: ActiveSheet?
    var onTitleChanged: (String) -> Void

    init(
        habit: Binding<Habit>,
        resetAction: @escaping () -> Void,
        onDateChanged: @escaping (Date) -> Void,
        onResetRecord: @escaping () -> Void,
        onSetGoal: @escaping (Int) -> Void,
        onResetStreak: @escaping () -> Void,
        onTitleChanged: @escaping (String) -> Void
    ) {
        self._habit = habit
        self.resetAction = resetAction
        self.onDateChanged = onDateChanged
        self.onResetRecord = onResetRecord
        self.onSetGoal = onSetGoal
        self.onResetStreak = onResetStreak
        self.onTitleChanged = onTitleChanged
        _tempStartDate = State(initialValue: habit.wrappedValue.startDate)
        _habitTitle = State(initialValue: habit.wrappedValue.title)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(habit.title)
                    .font(.headline)
                Spacer()
            }

            Text("🔥 Streak: \(habit.daysFree) \(habit.daysFree == 1 ? "day" : "days")")
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
            }

            Text("🏆\(habit.recordDisplayText)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
        }
        .onTapGesture {
            activeSheet = .options
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .options:
                HabitOptionsView(
                    onSetDate: { activeSheet = .setStartDate },
                    onRename: { activeSheet = .rename },
                    onSetGoal: { activeSheet = .setGoal },
                    onResetStreak: { showResetConfirmation = true },
                    onResetRecord: { showResetRecordConfirmation = true }
                )
            case .rename:
                RenameHabitView(currentTitle: habitTitle) { newTitle in
                    habitTitle = newTitle
                    onTitleChanged(newTitle)
                }
            case .setGoal:
                SetGoalView { goal in
                    onSetGoal(goal)
                }
            case .setStartDate:
                SetStartDateView(currentStartDate: tempStartDate) { newDate in
                    tempStartDate = newDate
                    onDateChanged(newDate)
                }
            }
        }
        .alert("Reset streak for \(habit.title)?", isPresented: $showResetConfirmation) {
            Button("Reset", role: .destructive) {
                onResetStreak()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will reset your current streak to Day 1.")
        }
        .alert("Reset record for \(habit.title)?", isPresented: $showResetRecordConfirmation) {
            Button("Reset", role: .destructive) {
                onResetRecord()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently reset your highest streak record.")
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
        onResetStreak: {},
        onTitleChanged: { _ in }
    )
}
