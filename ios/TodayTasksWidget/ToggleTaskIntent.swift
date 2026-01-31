import AppIntents
import Foundation
import WidgetKit

@available(iOS 17.0, *)
struct ToggleTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task"

    @Parameter(title: "Task ID")
    var taskId: Int

    init() {}

    init(taskId: Int) {
        self.taskId = taskId
    }

    func perform() async throws -> some IntentResult {
        let store = TaskWidgetDataStore()
        var snapshot = store.readSnapshot()
        guard let index = snapshot.tasks.firstIndex(where: { $0.id == taskId }) else {
            return .result()
        }

        let task = snapshot.tasks[index]
        let newCompleted = !task.isCompleted
        let updatedTask = WidgetTask(
            id: task.id,
            title: task.title,
            isCompleted: newCompleted,
            isAllDay: task.isAllDay,
            startTime: task.startTime,
            endTime: task.endTime,
        )

        if newCompleted {
            snapshot.tasks.remove(at: index)
        } else {
            snapshot.tasks[index] = updatedTask
        }

        snapshot.pendingActions.removeAll { $0.taskId == taskId }
        snapshot.pendingActions.append(
            WidgetAction(
                taskId: taskId,
                isCompleted: newCompleted,
                updatedAt: ISO8601DateFormatter().string(from: Date()),
            ),
        )

        snapshot.generatedAt = ISO8601DateFormatter().string(from: Date())
        store.writeSnapshot(snapshot)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
