import Foundation

final class TaskWidgetDataStore {
    private let appGroupId = "group.yegor.cheprasov.taskify"
    private let fileName = "widget_tasks.json"

    private var fileURL: URL? {
        return FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupId)?
            .appendingPathComponent(fileName)
    }

    func readSnapshot() -> WidgetSnapshot {
        guard let url = fileURL else {
            return emptySnapshot()
        }
        guard let data = try? Data(contentsOf: url) else {
            return emptySnapshot()
        }
        guard let snapshot = try? JSONDecoder().decode(WidgetSnapshot.self, from: data) else {
            return emptySnapshot()
        }
        return snapshot
    }

    func writeSnapshot(_ snapshot: WidgetSnapshot) {
        guard let url = fileURL else {
            return
        }
        guard let data = try? JSONEncoder().encode(snapshot) else {
            return
        }
        try? data.write(to: url)
    }

    private func emptySnapshot() -> WidgetSnapshot {
        return WidgetSnapshot(
            version: 1,
            date: TaskWidgetDateFormatter.shared.string(from: Date()),
            generatedAt: ISO8601DateFormatter().string(from: Date()),
            tasks: [],
            pendingActions: [],
        )
    }
}

final class TaskWidgetDateFormatter {
    static let shared = TaskWidgetDateFormatter()

    private let formatter: DateFormatter

    private init() {
        formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
    }

    func string(from date: Date) -> String {
        return formatter.string(from: date)
    }
}
