//
//  SetStartDateView.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/14/25.
//

import SwiftUI

struct SetStartDateView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate: Date
    var currentStartDate: Date
    var onSave: (Date) -> Void

    init(currentStartDate: Date, onSave: @escaping (Date) -> Void) {
        self.currentStartDate = currentStartDate
        self.onSave = onSave
        _selectedDate = State(initialValue: currentStartDate)
    }

    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Start Date", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                Spacer()
            }
            .navigationTitle("Set Start Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(selectedDate)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SetStartDateView(currentStartDate: Date()) { _ in }
}
