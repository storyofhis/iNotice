//
//  ScheduleView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 09/09/26.
//

import SwiftUI

struct ScheduleView: View {
    @State private var viewModel: ScheduleViewModel
    @State private var selectedDate: Date = Date()

    @State private var showAddSheet = false
    @State private var newActivity = Activity(title: "", icon: "circle.fill", startTime: .now)

    @State private var editingIndex: EditingIndex?

    @State private var activities: [Activity] = [
        Activity(title: "Wake up", icon: "alarm.fill", startTime: .init(hour: 6), color: .deepAmber),
        Activity(title: "Webinar", icon: "person.2.fill", startTime: .init(hour: 8, minute: 30), endTime: .init(hour: 9), link: URL(string: "https://zoom.com/meetinglink"), color: .slateBlue),
        Activity(title: "Working", icon: "desktopcomputer", startTime: .init(hour: 10), endTime: .init(hour: 12), subTasks: [
            SubTask(title: "Meeting Client"),
            SubTask(title: "Fixing bugs"),
            SubTask(title: "Review Code"),
        ], color: .mutedTeal),
        Activity(title: "Break", icon: "cup.and.saucer.fill", startTime: .init(hour: 12), endTime: .init(hour: 13), color: .dustyRose),
        Activity(title: "Sleep", icon: "moon.fill", startTime: .init(hour: 22), color: .slateBlue),
    ]

    private var weekDays: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: selectedDate)?.start ?? selectedDate

        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }

    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
    }

    private func conflictingActivity(for candidate: Activity, excluding excludedID: Activity.ID? = nil) -> Activity? {
        activities.first { $0.id != excludedID && $0.overlaps(candidate) }
    }

    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 20) {
                Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                    .font(.subheadline)
                    .foregroundStyle(Color.opalTextSecondary)

                WeekStripView(days: weekDays, selectedDate: $selectedDate)

                Text(selectedDate.formatted(.dateTime.weekday(.wide).day().month().year()))
                    .font(.title2.bold())
                    .foregroundStyle(Color.opalTextPrimary)
            }
            .padding()
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            ForEach($activities) { $activity in
                ActivityRowView(activity: $activity, isLast: activity.id == activities.last?.id)
                    .onTapGesture {
                        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
                            editingIndex = EditingIndex(id: index)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteActivity)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.opalBackground.ignoresSafeArea())
        .overlay(alignment: .bottomTrailing) {
            Button {
                newActivity = Activity(title: "", icon: "circle.fill", startTime: .now)
                showAddSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundStyle(Color.opalTextPrimary)
                    .frame(width: 56, height: 56)
                    .background(Color.opalSurface)
                    .clipShape(Circle())
            }
            .padding()
        }
        .sheet(isPresented: $showAddSheet) {
            ActivityFormView(
                activity: $newActivity,
                conflictCheck: { conflictingActivity(for: $0) }
            ) {
                activities.append(newActivity)
                activities.sort { $0.startTime < $1.startTime }
            }
        }
        .sheet(item: $editingIndex, onDismiss: { editingIndex = nil }) { context in
            ActivityFormView(
                activity: $activities[context.id],
                conflictCheck: { conflictingActivity(for: $0, excluding: activities[context.id].id) }
            ) {
                activities.sort { $0.startTime < $1.startTime }
            }
        }
    }
    
    private func deleteActivity(at offsets: IndexSet) {
        activities.remove(atOffsets: offsets)
    }
}

private struct EditingIndex: Identifiable {
    let id: Int
}

private extension Date {
    init(hour: Int, minute: Int = 0) {
        self = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: .now) ?? .now
    }
}
