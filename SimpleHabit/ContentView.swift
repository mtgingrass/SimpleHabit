//
//  ContentView.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/13/25.
//

import SwiftUI

let darkModeKey = "isDarkModeEnabled"

struct ContentView: View {
    @State private var isDarkMode: Bool = UserDefaults.standard.bool(forKey: darkModeKey)
    
    @StateObject private var viewModel = HabitListViewModel()
    
    @State private var showMainResetConfirmation = false
    @State private var mainTempDate: Date = Date()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                // Top-right toggle and ellipsis icon
                HStack {
                    HStack(spacing: 6) {
                        Toggle("", isOn: $isDarkMode)
                            .labelsHidden()
                            .onChange(of: isDarkMode) { _, newValue in
                                UserDefaults.standard.set(newValue, forKey: darkModeKey)
                            }
                        Label(isDarkMode ? "Light Mode" : "Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading, 12)

                    Spacer()
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                        .padding(12)
                }
                .padding(.top, 0)

                if let main = viewModel.habits.first(where: { $0.isMain }) {
                    VStack(spacing: 4) {
                        Text(main.title)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Day \(main.daysFree)")
                            .font(.system(size: 52, weight: .bold))
                        Text("Record: \(main.daysFree) days")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(uiColor: UIColor.secondarySystemBackground))
                    )
                    .padding(.horizontal)
                    .padding(.top, -8)
                    .onAppear {
                        mainTempDate = main.startDate
                    }

                    // Start Date + Reset Button
                    VStack(spacing: 16) {
                        HStack {
                            Text("Start Date:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            DatePicker(
                                "",
                                selection: Binding(
                                    get: { mainTempDate },
                                    set: { newDate in
                                        mainTempDate = newDate
                                        viewModel.updateStartDate(for: main.id, to: newDate)
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
                        Button(action: {
                            showMainResetConfirmation = true
                        }) {
                            Text("Reset to Today")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                        .alert("Reset \(main.title)?", isPresented: $showMainResetConfirmation) {
                            Button("Reset", role: .destructive) {
                                viewModel.resetStartDate(for: main.id)
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                    }
                    .padding()
                }

                Divider().padding(.vertical, 12)

                // Sub-Habit Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sub-Habits")
                        .font(.headline)
                        .padding(.horizontal)
                    VStack(spacing: 12) {
                        ForEach(viewModel.habits.filter { !$0.isMain }) { habit in
                            HabitView(
                                habit: habit,
                                resetAction: { viewModel.resetStartDate(for: habit.id) },
                                onDateChanged: { newDate in
                                    viewModel.updateStartDate(for: habit.id, to: newDate)
                                },
                                onResetRecord: {
                                    viewModel.resetRecord(for: habit.id)
                                }
                            )
                        }
                    }
                    .padding(.bottom)
                }
                Spacer(minLength: 0)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
