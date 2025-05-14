//
//  RenameHabitView.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/14/25.
//

import SwiftUI

struct RenameHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var newTitle: String
    var currentTitle: String
    var onSave: (String) -> Void

    init(currentTitle: String, onSave: @escaping (String) -> Void) {
        self.currentTitle = currentTitle
        self.onSave = onSave
        _newTitle = State(initialValue: currentTitle)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Habit Title", text: $newTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)

                    Spacer()

                    Button("Save") {
                        onSave(newTitle)
                        dismiss()
                    }
                    .disabled(newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Rename Habit")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

#Preview {
    RenameHabitView(currentTitle: "Sample Habit") { newName in
        print("Renamed to: \(newName)")
    }
}
