import SwiftUI

struct PriorityHabitView: View {
    // Sheet enum for clarity
    private enum ActiveSheet: Identifiable {
        case rename, setGoal, options, tipJar
        var id: Int {
            switch self {
            case .rename: return 0
            case .setGoal: return 1
            case .options: return 2
            case .tipJar: return 3
            }
        }
    }
    var habit: Habit
    var tempDate: Date
    var onDateChanged: (Date) -> Void
    var onReset: () -> Void
    var onResetRecord: () -> Void
    var onSetGoal: (Int) -> Void
    var onResetStreak: () -> Void
    var onTitleChanged: (String) -> Void
    @State private var showResetConfirmation = false
    @State private var isEditingDate = false
    @State private var showResetRecordConfirmation = false
    @State private var habitTitle: String
    @State private var activeSheet: ActiveSheet?

    init(
        habit: Habit,
        tempDate: Date,
        onDateChanged: @escaping (Date) -> Void,
        onReset: @escaping () -> Void,
        onResetRecord: @escaping () -> Void,
        onSetGoal: @escaping (Int) -> Void,
        onResetStreak: @escaping () -> Void,
        onTitleChanged: @escaping (String) -> Void
    ) {
        self.habit = habit
        self.tempDate = tempDate
        self.onDateChanged = onDateChanged
        self.onReset = onReset
        self.onResetRecord = onResetRecord
        self.onSetGoal = onSetGoal
        self.onResetStreak = onResetStreak
        self.onTitleChanged = onTitleChanged
        _habitTitle = State(initialValue: habit.title)
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(habit.title)
                .font(.headline)
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
                Button(action: {
                    activeSheet = .options
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 8)
                }
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
                    activeSheet = .tipJar
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
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .rename:
                RenameHabitView(currentTitle: habitTitle) { newTitle in
                    habitTitle = newTitle
                    onTitleChanged(newTitle)
                }
            case .setGoal:
                SetGoalView { goal in
                    onSetGoal(goal)
                }
            case .options:
                HabitOptionsView(
                    onRename: { activeSheet = .rename },
                    onSetGoal: { activeSheet = .setGoal },
                    onResetStreak: { showResetConfirmation = true },
                    onResetRecord: { showResetRecordConfirmation = true }
                )
            case .tipJar:
                TipJarView()
            }
        }
        .alert("Reset record for \(habit.title)?", isPresented: $showResetRecordConfirmation) {
            Button("Reset", role: .destructive) {
                onResetRecord()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will reset your record to your current streak of \(habit.daysFree) day\(habit.daysFree == 1 ? "" : "s").")
        }
        .alert("Reset streak for \(habit.title)?", isPresented: $showResetConfirmation) {
            Button("Reset", role: .destructive) {
                onResetStreak()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will reset your current streak to Day 1.")
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
        onResetStreak: {},
        onTitleChanged: { _ in }
    )
}
