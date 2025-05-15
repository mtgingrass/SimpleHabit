import SwiftUI

struct PriorityHabitView: View {
    // Sheet enum for clarity
    private enum ActiveSheet: Identifiable {
        case rename, setGoal, options, tipJar, setStartDate
        var id: Int {
            switch self {
            case .rename: return 0
            case .setGoal: return 1
            case .options: return 2
            case .tipJar: return 3
            case .setStartDate: return 4
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
    var onSetDate: () -> Void
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
        onTitleChanged: @escaping (String) -> Void,
        onSetDate: @escaping () -> Void
    ) {
        self.habit = habit
        self.tempDate = tempDate
        self.onDateChanged = onDateChanged
        self.onReset = onReset
        self.onResetRecord = onResetRecord
        self.onSetGoal = onSetGoal
        self.onResetStreak = onResetStreak
        self.onTitleChanged = onTitleChanged
        self.onSetDate = onSetDate
        _habitTitle = State(initialValue: habit.title)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green.opacity(0.2), Color.green.opacity(0.05)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: .green.opacity(0.25), radius: 8, x: 0, y: 4)
            VStack {
                Spacer()
                Button(action: {
                    activeSheet = .tipJar
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.pink)
                        .padding(2)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding(10)
            }
            ZStack {
                HStack(alignment: .center, spacing: 8) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("🔥 \(habit.title)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Text("Day \(habit.daysFree)")
                            .font(.system(size: 52, weight: .bold))
                        if let goal = habit.goalDays {
                            Text("of \(goal) days")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Text("🏆\(habit.recordDisplayText)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow)
                    }

                    Spacer(minLength: 8)

                    if habit.goalDays != nil {
                        ZStack {
                            Circle()
                                .stroke(Color.green.opacity(0.2), lineWidth: 10)
                                .frame(width: 90, height: 90)
                            Circle()
                                .trim(from: 0.0, to: habit.goalProgress)
                                .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 90, height: 90)
                            Text("\(Int(habit.goalProgress * 100))%")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.green)
                        }
                    } else {
                        Text("No goal set")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onTapGesture {
                    activeSheet = .options
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 150)
        .padding(.horizontal)
        .padding(.vertical, 4)
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
                    onSetDate: { activeSheet = .setStartDate },
                    onRename: { activeSheet = .rename },
                    onSetGoal: { activeSheet = .setGoal },
                    onResetStreak: { showResetConfirmation = true },
                    onResetRecord: { showResetRecordConfirmation = true }
                )
            case .tipJar:
                TipJarView()
            case .setStartDate:
                SetStartDateView(currentStartDate: tempDate) { newDate in
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
        habit: Habit(
            id: UUID(),
            title: "Priority Habit",
            startDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            goalDays: 10,
            isMain: true,
            recordDays: 7
        ),
        tempDate: Date(),
        onDateChanged: { _ in },
        onReset: {},
        onResetRecord: {},
        onSetGoal: { _ in },
        onResetStreak: {},
        onTitleChanged: { _ in },
        onSetDate: {}
    )
}
