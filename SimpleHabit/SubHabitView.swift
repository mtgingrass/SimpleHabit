//
//  SubHabitView.swift
//  SimpleHabit
//
//  Created by Mark Gingrass on 5/13/25.
//

import SwiftUI

struct SubHabitView: View {
    var title: String
    var record: Int
    var day: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text("Record: \(record) days")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("Day \(day)")
                .font(.title)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
