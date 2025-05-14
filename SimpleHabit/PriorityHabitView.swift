
import SwiftUI

struct PriorityHabitView: View {
    var habit: Habit
    var tempDate: Date
    var onDateChanged: (Date) -> Void
    var onReset: () -> Void
    @State private var showResetConfirmation = false

    var body: some View {
        VStack(spacing: 4) {
            Text(habit.title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Day \(habit.daysFree)")
                .font(.system(size: 52, weight: .bold))
            Text("🏆 \(habit.recordDisplayText)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
            ProgressView(value: habit.streakProgress)
                .progressViewStyle(.linear)
                .tint(.green)
                .padding(.top, 4)

            HStack {
                Spacer()
                DatePicker(
                    "",
                    selection: Binding(
                        get: { tempDate },
                        set: { newDate in
                            onDateChanged(newDate)
                        }
                    ),
                    in: ...Date(),
                    displayedComponents: [.date]
                )
                .labelsHidden()
                .datePickerStyle(.compact)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color(uiColor: UIColor.secondarySystemBackground))
                .cornerRadius(6)
            }

            HStack {
                Spacer()
                Button(action: {
                    showResetConfirmation = true
                }) {
                    Text("Reset to Today")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                .alert("Reset \(habit.title)?", isPresented: $showResetConfirmation) {
                    Button("Reset", role: .destructive) {
                        onReset()
                    }
                    Button("Cancel", role: .cancel) { }
                }
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
    }
}

#Preview {
    PriorityHabitView(
        habit: Habit(id: UUID(), title: "Priority Habit", startDate: Date(), isMain: true, recordDays: 5),
        tempDate: Date(),
        onDateChanged: { _ in },
        onReset: {}
    )
}
