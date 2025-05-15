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
    
    @State private var showAbout = false
    @State private var showTipJar = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top-right toggle and controls
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
                    HStack(spacing: 12) {
                        Button(action: {
                            showTipJar = true
                        }) {
                            Image(systemName: "gift.circle")
                                .imageScale(.large)
                        }
                        Menu {
                            Button("About This App") {
                                showAbout = true
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .imageScale(.large)
                                .padding(12)
                        }
                    }
                    .padding(.trailing, 12)
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
                        },
                        onSetGoal: { goal in
                            viewModel.updateGoal(for: main.id, to: goal)
                        },
                        onResetStreak: {
                            viewModel.resetStartDate(for: main.id)
                        },
                        onTitleChanged: { newTitle in
                            viewModel.updateTitle(for: main.id, to: newTitle)
                        },
                        onSetDate: {
                            mainTempDate = main.startDate
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
                    
                    Text("Because you stopped the habit above, you're making space for the habits below.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }

                Divider()
                    .frame(height: 2)
                    .background(Color.secondary)
                    .padding(.vertical, 16)
                    .padding(.horizontal)

                // Sub-Habit Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Subhabit count: \(viewModel.habits.filter { !$0.isMain }.count)")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding(.leading)
                    List {
                        ForEach(Array(zip(viewModel.habits.indices, $viewModel.habits)).filter { !$0.1.wrappedValue.isMain }, id: \.0) { index, habitBinding in
                            HabitRowView(
                                habit: habitBinding,
                                resetAction: { viewModel.resetStartDate(for: habitBinding.wrappedValue.id) },
                                onDateChanged: { newDate in
                                    viewModel.updateStartDate(for: habitBinding.wrappedValue.id, to: newDate)
                                },
                                onResetRecord: {
                                    viewModel.resetRecord(for: habitBinding.wrappedValue.id)
                                },
                                onSetGoal: { goal in
                                    viewModel.updateGoal(for: habitBinding.wrappedValue.id, to: goal)
                                },
                                onResetStreak: {
                                    viewModel.resetStartDate(for: habitBinding.wrappedValue.id)
                                },
                                onTitleChanged: { newTitle in
                                    viewModel.updateTitle(for: habitBinding.wrappedValue.id, to: newTitle)
                                }
                            )
                        }
                    }
                    .listStyle(.plain)
                    .frame(maxHeight: .infinity)
                }
                Spacer(minLength: 0)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .sheet(isPresented: $showAbout) {
            AboutAppView()
        }
        .sheet(isPresented: $showTipJar) {
            TipJarView()
        }
    }
}

#Preview {
    ContentView()
}
