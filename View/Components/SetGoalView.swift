//
//  SetGoalView.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/14/25.
//

import SwiftUI

struct SetGoalView: View {
    var onSelect: (Int) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var customGoalText = ""

var body: some View {
    VStack(spacing: 16) {
        HStack {
            Spacer()
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
                    .imageScale(.large)
                    .padding(.top)
            }
        }

        Text("Set Goal")
            .font(.title2)
            .fontWeight(.bold)
            .padding()

        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        LazyVGrid(columns: columns, spacing: 12) {
            ForEach([5, 7, 10, 21, 30, 60, 90, 100, 365], id: \.self) { goal in
                Button("\(goal)") {
                    onSelect(goal)
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }

        Button("Just for Today") {
            onSelect(1)
            dismiss()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)

        VStack(alignment: .leading, spacing: 8) {
            Text("Or enter your own goal:")
                .font(.subheadline)

            TextField("Number of days", text: $customGoalText)
                .keyboardType(.numberPad)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)

            Button("Set Goal") {
                if let customGoal = Int(customGoalText), customGoal >= 1 {
                    onSelect(customGoal)
                    dismiss()
                }
            }
            .disabled(Int(customGoalText) == nil || Int(customGoalText)! < 1)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }

        Divider()
        Spacer()
    }
    .padding()
}
}

#Preview {
    SetGoalView { selectedGoal in
        print("Selected goal: \(selectedGoal) days")
    }
}
