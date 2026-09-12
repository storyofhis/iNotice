//
//  WeekStripView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 12/09/26.
//

import SwiftUI

struct WeekStripView: View {
    let days: [Date]
    @Binding var selectedDate: Date

    var body: some View {
        HStack(spacing: 8) {
            ForEach(days, id: \.self) { day in
                DayCapsule(day: day, isSelected: Calendar.current.isDate(day, inSameDayAs: selectedDate))
                    .onTapGesture {
                        selectedDate = day
                    }
            }
        }
    }
}


private struct DayCapsule: View {
    let day: Date
    let isSelected: Bool

    private var weekdayLetter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: day)
    }

    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: day)
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(weekdayLetter)
                .font(.caption2)
            Text(dayNumber)
                .font(.headline)
        }
        .foregroundStyle(isSelected ? Color.opalBackground : Color.opalTextPrimary)
        .frame(width: 44, height: 64)
        .background(isSelected ? CategoryColor.deepAmber.color : Color.opalSurface)
        .clipShape(.rect(cornerRadius: 16))
    }
}
