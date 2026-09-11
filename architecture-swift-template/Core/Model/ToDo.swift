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

struct TaskItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var isDone: Bool = false
    var subTasks: [SubTask] = []
}
