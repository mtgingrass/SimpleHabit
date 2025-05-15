import SwiftUI

struct HabitRowView: View {
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
                Text(habit.title.uppercased())
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .kerning(1.0)
                    .foregroundColor(.accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.1))
                    .clipShape(Capsule())
                Spacer()
            }

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .imageScale(.medium)
                    Text("\(habit.daysFree)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.orange)
                }

                VStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)
                        .imageScale(.medium)
                    Text("\(habit.recordDays)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)

                if habit.goalDays != nil {
                    VStack(spacing: 2) {
                        ZStack {
                            Circle()
                                .stroke(Color.green.opacity(0.2), lineWidth: 6)
                                .frame(width: 50, height: 50)
                            Circle()
                                .trim(from: 0.0, to: habit.goalProgress)
                                .stroke(Color.green, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 50, height: 50)
                            VStack(spacing: 2) {
                                Text("\(Int(habit.goalProgress * 100))%")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(.green)
                                
                                if let goal = habit.goalDays {
                                    Text("\(goal)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(width: 50)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .onTapGesture {
            activeSheet = .options
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                onResetStreak()
            } label: {
                Label {
                    Text("Reset\nStreak")
                } icon: {
                    Image(systemName: "arrow.uturn.backward")
                }
            }

            Button(role: .destructive) {
                showResetRecordConfirmation = true
            } label: {
                Label {
                    Text("Reset\nRecord")
                } icon: {
                    Image(systemName: "trash")
                }
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                activeSheet = .setGoal
            } label: {
                Label("Set Goal", systemImage: "target")
            }

            Button {
                activeSheet = .setStartDate
            } label: {
                Label("Set Date", systemImage: "calendar")
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .options:
                HabitOptionsView(
                    onSetDate: { activeSheet = .setStartDate },
                    onRename: { activeSheet = .rename },
                    onSetGoal: {
                        activeSheet = .setGoal
                    },
                    onResetStreak: { onResetStreak() },
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
    VStack(spacing: 12) {
        HabitRowView(
            habit: .constant(Habit(id: UUID(), title: "Workout", startDate: Date().addingTimeInterval(-86400 * 3), goalDays: 10, isMain: false, recordDays: 6)),
            resetAction: {},
            onDateChanged: { _ in },
            onResetRecord: {},
            onSetGoal: { _ in },
            onResetStreak: {},
            onTitleChanged: { _ in }
        )

        HabitRowView(
            habit: .constant(Habit(id: UUID(), title: "Reading", startDate: Date().addingTimeInterval(-86400 * 1), goalDays: 5, isMain: false, recordDays: 3)),
            resetAction: {},
            onDateChanged: { _ in },
            onResetRecord: {},
            onSetGoal: { _ in },
            onResetStreak: {},
            onTitleChanged: { _ in }
        )

        HabitRowView(
            habit: .constant(Habit(id: UUID(), title: "Journaling", startDate: Date().addingTimeInterval(-86400 * 2), goalDays: 7, isMain: false, recordDays: 4)),
            resetAction: {},
            onDateChanged: { _ in },
            onResetRecord: {},
            onSetGoal: { _ in },
            onResetStreak: {},
            onTitleChanged: { _ in }
        )
    }
    .padding()
    .background(Color(.systemBackground))
}
