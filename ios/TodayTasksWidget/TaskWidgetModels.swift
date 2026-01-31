import Foundation

struct WidgetTask: Codable {
    let id: Int
    let title: String
    let isCompleted: Bool
    let isAllDay: Bool
    let startTime: String?
    let endTime: String?
}

struct WidgetAction: Codable {
    let taskId: Int
    let isCompleted: Bool
    let updatedAt: String
}

struct WidgetSnapshot: Codable {
    let version: Int
    let date: String
    var generatedAt: String
    var tasks: [WidgetTask]
    var pendingActions: [WidgetAction]
}
