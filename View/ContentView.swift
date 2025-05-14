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
                    PriorityHabitView(
                        habit: main,
                        tempDate: mainTempDate,
                        onDateChanged: { newDate in
                            mainTempDate = newDate
                            viewModel.updateStartDate(for: main.id, to: newDate)
                        },
                        onReset: {
                            showMainResetConfirmation = true
                        },
                        onResetRecord: {
                            viewModel.resetRecord(for: main.id)
                        }
                    )
                    .onAppear {
                        mainTempDate = main.startDate
                    }
                    .alert("Reset \(main.title)?", isPresented: $showMainResetConfirmation) {
                        Button("Reset", role: .destructive) {
                            viewModel.resetStartDate(for: main.id)
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                }

                Divider()
                    .frame(height: 2)
                    .background(Color.secondary)
                    .padding(.vertical, 16)
                    .padding(.horizontal)

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
