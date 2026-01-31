package yegor.cheprasov.taskify.widgets

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

internal class WidgetDataStore(private val context: Context) {
    private val file: File
        get() {
            val flutterDir = context.getDir("flutter", Context.MODE_PRIVATE)
            return File(flutterDir, WIDGET_FILE_NAME)
        }

    fun readSnapshot(): WidgetSnapshot {
        if (!file.exists()) {
            return emptySnapshot()
        }
        val contents = file.readText().trim()
        if (contents.isEmpty()) {
            return emptySnapshot()
        }
        return parseSnapshot(JSONObject(contents))
    }

    fun writeSnapshot(snapshot: WidgetSnapshot) {
        val json = JSONObject()
        json.put("version", snapshot.version)
        json.put("date", snapshot.date)
        json.put("generatedAt", snapshot.generatedAt)
        json.put("tasks", JSONArray(snapshot.tasks.map { taskToJson(it) }))
        json.put(
            "pendingActions",
            JSONArray(snapshot.pendingActions.map { actionToJson(it) }),
        )
        file.writeText(json.toString())
    }

    private fun emptySnapshot(): WidgetSnapshot {
        return WidgetSnapshot(
            version = 1,
            date = "",
            generatedAt = currentIsoTimestamp(),
            tasks = emptyList(),
            pendingActions = emptyList(),
        )
    }

    private fun parseSnapshot(json: JSONObject): WidgetSnapshot {
        val tasks = json.optJSONArray("tasks")?.let { array ->
            (0 until array.length()).mapNotNull { index ->
                val item = array.optJSONObject(index) ?: return@mapNotNull null
                parseTask(item)
            }
        } ?: emptyList()

        val pendingActions = json.optJSONArray("pendingActions")?.let { array ->
            (0 until array.length()).mapNotNull { index ->
                val item = array.optJSONObject(index) ?: return@mapNotNull null
                parseAction(item)
            }
        } ?: emptyList()

        return WidgetSnapshot(
            version = json.optInt("version", 1),
            date = json.optString("date", ""),
            generatedAt = json.optString("generatedAt", currentIsoTimestamp()),
            tasks = tasks,
            pendingActions = pendingActions,
        )
    }

    private fun parseTask(json: JSONObject): WidgetTask {
        return WidgetTask(
            id = json.optInt("id"),
            title = json.optString("title"),
            isCompleted = json.optBoolean("isCompleted", false),
            isAllDay = json.optBoolean("isAllDay", true),
            startTime = json.optString("startTime").takeIf { it.isNotBlank() },
            endTime = json.optString("endTime").takeIf { it.isNotBlank() },
        )
    }

    private fun parseAction(json: JSONObject): WidgetAction {
        return WidgetAction(
            taskId = json.optInt("taskId"),
            isCompleted = json.optBoolean("isCompleted", false),
            updatedAt = json.optString("updatedAt", currentIsoTimestamp()),
        )
    }

    private fun taskToJson(task: WidgetTask): JSONObject {
        val json = JSONObject()
        json.put("id", task.id)
        json.put("title", task.title)
        json.put("isCompleted", task.isCompleted)
        json.put("isAllDay", task.isAllDay)
        json.put("startTime", task.startTime)
        json.put("endTime", task.endTime)
        return json
    }

    private fun actionToJson(action: WidgetAction): JSONObject {
        val json = JSONObject()
        json.put("taskId", action.taskId)
        json.put("isCompleted", action.isCompleted)
        json.put("updatedAt", action.updatedAt)
        return json
    }

    companion object {
        private const val WIDGET_FILE_NAME = "widget_tasks.json"
    }
}
