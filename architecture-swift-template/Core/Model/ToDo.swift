//
//  ToDo.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 11/09/26.
//

import Foundation

struct SubTask: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var isDone: Bool = false
}

struct Activity: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var icon: String
    var startTime: Date
    var endTime: Date?
    var link: URL?
    var subTasks: [SubTask] = []
    var color: CategoryColor = .dustyRose

    var timeRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let endTime {
            return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
        }
        return formatter.string(from: startTime)
    }

    var timeRange: ClosedRange<Date> {
        startTime...(endTime ?? startTime)
    }

    func overlaps(_ other: Activity) -> Bool {
        timeRange.overlaps(other.timeRange)
    }
}
