//
//  ScheduleView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 09/09/26.
//

import SwiftUI

struct ScheduleView: View {
    @State private var viewModel: ScheduleViewModel
    @State private var showMediumSheet: Bool = false
    @State private var title: String =  ""
    
    @State private var tasks: [TaskItem] = [
        TaskItem(title: "Wake Up"),
        TaskItem(title: "Sleep")
    ]
    
    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section {
                ForEach($tasks) { $task in
                    NavigationLink {
                        TaskDetailView(task: $task)
                    } label: {
                        HStack {
                            Button {
                                task.isDone.toggle()
                            } label: {
                                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(task.isDone ? .green: .secondary)
                            }
                            .buttonStyle(.plain)
                            
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough(task.isDone)
                                if !task.subTasks.isEmpty {
                                    Text("\(task.subTasks.filter(\.isDone).count)/\(task.subTasks.count) subtasks")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    tasks.remove(atOffsets: indexSet)
                }
            }
        }
        .navigationTitle("Schedule")
        .navigationBarTitleDisplayMode( .inline )
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Add", systemImage: "plus") {
                    title = ""
                    showMediumSheet = true
                }
            }
        }
        
        .sheet(isPresented: $showMediumSheet) {
            SheetContentView(title: "New Activity", titleText: $title, onSave: addTask)
                .presentationDetents([.large])
                .interactiveDismissDisabled()
        }
    }
    
    private func addTask() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        tasks.append(TaskItem(title: trimmed))
    }
}
