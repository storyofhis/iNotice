//
//  ActivityRowView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 12/09/26.
//

import SwiftUI

struct ActivityRowView: View {
    @Binding var activity: Activity
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            TimelineRail(color: activity.color.color, showLine: !isLast)
            ActivityCard(activity: $activity)
        }
    }
}

private struct TimelineRail: View {
    let color: Color
    let showLine: Bool

    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
                .padding(.top, 6)

            if showLine {
                Rectangle()
                    .fill(Color.opalSurface)
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
        }
        .frame(width: 10)
    }
}

private struct ActivityCard: View {
    @Binding var activity: Activity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                IconBadge(systemName: activity.icon, tint: activity.color.color)

                VStack(alignment: .leading, spacing: 2) {
                    Text(activity.title)
                        .font(.headline)
                        .foregroundStyle(Color.opalTextPrimary)
                    Text(activity.timeRangeText)
                        .font(.subheadline)
                        .foregroundStyle(Color.opalTextSecondary)
                }

                Spacer()
            }

            if let link = activity.link {
                LinkChip(url: link)
            }

            if !activity.subTasks.isEmpty {
                SubTaskChecklist(subTasks: $activity.subTasks, tint: activity.color.color)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.opalSurface)
        .clipShape(.rect(cornerRadius: 16))
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 2)
                .fill(activity.color.color)
                .frame(width: 4)
                .padding(.vertical, 8)
        }
        .contentShape(.rect)
    }
}

private struct IconBadge: View {
    let systemName: String
    let tint: Color

    var body: some View {
        Image(systemName: systemName)
            .foregroundStyle(tint)
            .frame(width: 40, height: 40)
            .background(tint.opacity(0.15))
            .clipShape(Circle())
    }
}

private struct LinkChip: View {
    let url: URL

    var body: some View {
        Link(destination: url) {
            HStack(spacing: 4) {
                Image(systemName: "link")
                Text(url.absoluteString)
            }
        }
        .font(.caption)
        .foregroundStyle(Color.opalTextSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.opalBackground)
        .clipShape(.rect(cornerRadius: 12))
    }
}

private struct SubTaskChecklist: View {
    @Binding var subTasks: [SubTask]
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach($subTasks) { $subTask in
                Button {
                    subTask.isDone.toggle()
                } label: {
                    Label {
                        Text(subTask.title)
                            .strikethrough(subTask.isDone)
                            .foregroundStyle(subTask.isDone ? Color.opalTextSecondary : Color.opalTextPrimary)
                    } icon: {
                        Image(systemName: subTask.isDone ? "checkmark.square.fill" : "square")
                            .foregroundStyle(subTask.isDone ? tint : Color.opalTextSecondary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(Color.opalBackground)
        .clipShape(.rect(cornerRadius: 12))
    }
}
