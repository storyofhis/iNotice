//
//  TaskDetailView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 11/09/26.
//

import SwiftUI
import Observation

struct TaskDetailView: View {
    @Binding var task: TaskItem
    @State private var newSubtaskTitle: String = ""
    
    var body: some View {
        List {
            Section("Subtasks") {
                ForEach($task.subTasks) { $subTask in
                    Button {
                        subTask.isDone.toggle()
                    } label: {
                        Label {
                            Text(subTask.title)
                                .strikethrough(subTask.isDone)
                                .foregroundStyle(subTask.isDone ? .secondary : .primary)
                        } icon: {
                            Image(systemName: subTask.isDone ? "checkamrk.circle.fill" : "circle")
                                .foregroundStyle(subTask.isDone ? .green : .secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .onDelete { indexSet in
                    task.subTasks.remove(atOffsets: indexSet)
                }
            }
            
            Section {
                HStack {
                    TextField("New subtask", text: $newSubtaskTitle)
                        .onSubmit(addSubTask)
                    
                    Button("Add", action: addSubTask)
                        .disabled(newSubtaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addSubTask() {
        let trimmed = newSubtaskTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        task.subTasks.append(SubTask(title: trimmed))
        newSubtaskTitle = ""
    }
}
