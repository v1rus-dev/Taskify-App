package yegor.cheprasov.taskify.widgets

import android.content.Context
import androidx.glance.GlanceId
import androidx.glance.action.ActionParameters
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.updateAll

internal class ToggleTaskAction : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters,
    ) {
        val taskId = parameters[TaskIdKey] ?: return
        val store = WidgetDataStore(context)
        val snapshot = store.readSnapshot()
        val tasks = snapshot.tasks.toMutableList()

        val index = tasks.indexOfFirst { it.id == taskId }
        if (index == -1) {
            return
        }

        val task = tasks[index]
        val newCompleted = !task.isCompleted
        val updatedTask = task.copy(isCompleted = newCompleted)

        if (newCompleted) {
            tasks.removeAt(index)
        } else {
            tasks[index] = updatedTask
        }

        val updatedActions = snapshot.pendingActions
            .filterNot { it.taskId == taskId }
            .toMutableList()
        updatedActions.add(
            WidgetAction(
                taskId = taskId,
                isCompleted = newCompleted,
                updatedAt = currentIsoTimestamp(),
            ),
        )

        store.writeSnapshot(
            snapshot.copy(
                tasks = tasks,
                pendingActions = updatedActions,
                generatedAt = currentIsoTimestamp(),
            ),
        )

        TodayTasksWidget().updateAll(context)
    }

    companion object {
        val TaskIdKey = ActionParameters.Key<Int>("taskId")
    }
}
