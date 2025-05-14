import SwiftUI

struct PriorityHabitView: View {
    var habit: Habit
    var tempDate: Date
    var onDateChanged: (Date) -> Void
    var onReset: () -> Void
    var onResetRecord: () -> Void
    @State private var showResetConfirmation = false
    @State private var showTipJar = false
    @State private var isEditingDate = false
    @State private var showResetRecordConfirmation = false

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
                Menu {
                    Button("Set Date Manually") {
                        isEditingDate = true
                    }
                    Button(role: .destructive) {
                        showResetRecordConfirmation = true
                    } label: {
                        Label("⚠️ Reset Record", systemImage: "exclamationmark.triangle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .foregroundColor(.primary)
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
                    showTipJar = true
                }) {
                    Label("Tip Jar", systemImage: "heart.fill")
                        .font(.caption)
                        .foregroundColor(.pink)
                }

                Spacer()

                Button(action: {
                    showResetConfirmation = true
                }) {
                    Text("Reset to Day 1")
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
    }
}

#Preview {
    PriorityHabitView(
        habit: Habit(id: UUID(), title: "Priority Habit", startDate: Date(), isMain: true, recordDays: 5),
        tempDate: Date(),
        onDateChanged: { _ in },
        onReset: {},
        onResetRecord: {}
    )
}
