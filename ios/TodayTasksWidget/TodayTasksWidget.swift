import SwiftUI
import WidgetKit

struct TodayTasksEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetSnapshot
}

struct TodayTasksProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayTasksEntry {
        TodayTasksEntry(date: Date(), snapshot: TaskWidgetDataStore().readSnapshot())
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayTasksEntry) -> Void) {
        completion(TodayTasksEntry(date: Date(), snapshot: TaskWidgetDataStore().readSnapshot()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayTasksEntry>) -> Void) {
        let snapshot = TaskWidgetDataStore().readSnapshot()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
        completion(Timeline(entries: [TodayTasksEntry(date: Date(), snapshot: snapshot)], policy: .after(nextUpdate)))
    }
}

struct TodayTasksWidgetView: View {
    let entry: TodayTasksEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today").font(.headline)

            if entry.snapshot.tasks.isEmpty {
                Text("You have no tasks today")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Link("Add task", destination: URL(string: "taskify:///edit_task")!)
            } else {
                ForEach(entry.snapshot.tasks.prefix(maxItems), id: \.id) { task in
                    HStack(spacing: 8) {
                        if #available(iOS 17.0, *) {
                            Button(intent: ToggleTaskIntent(taskId: task.id)) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            }
                            .buttonStyle(.plain)
                        } else {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        }
                        Text(task.title)
                            .lineLimit(1)
                        Spacer()
                    }
                }
                Link("Add task", destination: URL(string: "taskify:///edit_task")!)
            }
        }
        .padding()
    }

    private var maxItems: Int {
        switch family {
        case .systemSmall:
            return 3
        default:
            return 6
        }
    }
}

struct TodayTasksWidget: Widget {
    let kind = "TodayTasksWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayTasksProvider()) { entry in
            TodayTasksWidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Today Tasks")
        .description("Shows your tasks for today")
    }
}
