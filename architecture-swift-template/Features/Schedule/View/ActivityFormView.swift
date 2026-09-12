//
//  ActivityFormView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 12/09/26.
//

import SwiftUI

struct ActivityFormView: View {
    @Binding var activity: Activity
    var conflictCheck: (Activity) -> Activity?
    var onSave: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var newSubtaskTitle = ""
    @State private var conflict: Activity?

    private let icons = [
        "alarm.fill", "person.2.fill", "desktopcomputer", "cup.and.saucer.fill",
        "moon.fill", "book.fill", "figure.run", "fork.knife", "circle.fill",
    ]

    private var isValid: Bool {
        activity.title.trimmingCharacters(in: .whitespaces).count >= 3
    }

    private var hasEndTime: Binding<Bool> {
        Binding(
            get: { activity.endTime != nil },
            set: { activity.endTime = $0 ? activity.startTime.addingTimeInterval(3600) : nil }
        )
    }

    private var endTime: Binding<Date> {
        Binding(
            get: { activity.endTime ?? activity.startTime.addingTimeInterval(3600) },
            set: { activity.endTime = $0 }
        )
    }

    private var linkText: Binding<String> {
        Binding(
            get: { activity.link?.absoluteString ?? "" },
            set: { activity.link = $0.isEmpty ? nil : URL(string: $0) }
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("At least 3 characters", text: $activity.title)
                }

                Section("Icon") {
                    IconGrid(icons: icons, selection: $activity.icon)
                }

                Section("Color") {
                    ColorSwatchRow(selection: $activity.color)
                }

                Section("Time") {
                    DatePicker("Start", selection: $activity.startTime, displayedComponents: .hourAndMinute)
                    Toggle("End time", isOn: hasEndTime)
                    if activity.endTime != nil {
                        DatePicker("End", selection: endTime, displayedComponents: .hourAndMinute)
                    }
                }

                Section("Link") {
                    TextField("https://...", text: linkText)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section("Subtasks") {
                    ForEach($activity.subTasks) { $subTask in
                        TextField("Subtask", text: $subTask.title)
                    }
                    .onDelete { activity.subTasks.remove(atOffsets: $0) }

                    HStack {
                        TextField("New subtask", text: $newSubtaskTitle)
                            .onSubmit(addSubtask)
                        Button("Add", action: addSubtask)
                            .disabled(newSubtaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: save)
                        .disabled(!isValid)
                }
            }
            .alert(item: $conflict) { conflicting in
                Alert(
                    title: Text("Time Conflict"),
                    message: Text("Overlaps with \"\(conflicting.title)\" (\(conflicting.timeRangeText))"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func addSubtask() {
        let trimmed = newSubtaskTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        activity.subTasks.append(SubTask(title: trimmed))
        newSubtaskTitle = ""
    }

    private func save() {
        if let conflicting = conflictCheck(activity) {
            conflict = conflicting
            return
        }
        onSave()
        dismiss()
    }
}

private struct IconGrid: View {
    let icons: [String]
    @Binding var selection: String

    private let columns = Array(repeating: GridItem(.flexible()), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(icons, id: \.self) { icon in
                Button {
                    selection = icon
                } label: {
                    Image(systemName: icon)
                        .frame(width: 36, height: 36)
                        .background(selection == icon ? Color.opalTextPrimary.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ColorSwatchRow: View {
    @Binding var selection: CategoryColor

    var body: some View {
        HStack(spacing: 12) {
            ForEach(CategoryColor.allCases, id: \.self) { category in
                Button {
                    selection = category
                } label: {
                    Circle()
                        .fill(category.color)
                        .frame(width: 32, height: 32)
                        .overlay {
                            if selection == category {
                                Circle().strokeBorder(Color.opalTextPrimary, lineWidth: 2)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }
}
