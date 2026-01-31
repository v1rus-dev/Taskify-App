package yegor.cheprasov.taskify.widgets

import java.time.Instant
import java.time.LocalDateTime
import java.time.ZoneId

internal data class WidgetTask(
    val id: Int,
    val title: String,
    val isCompleted: Boolean,
    val isAllDay: Boolean,
    val startTime: String?,
    val endTime: String?,
)

internal data class WidgetAction(
    val taskId: Int,
    val isCompleted: Boolean,
    val updatedAt: String,
)

internal data class WidgetSnapshot(
    val version: Int,
    val date: String,
    val generatedAt: String,
    val tasks: List<WidgetTask>,
    val pendingActions: List<WidgetAction>,
)

internal fun currentIsoTimestamp(): String {
    return Instant.now().toString()
}

internal fun parseIsoDate(value: String?): LocalDateTime? {
    if (value.isNullOrBlank()) {
        return null
    }
    return try {
        LocalDateTime.ofInstant(Instant.parse(value), ZoneId.systemDefault())
    } catch (_: Throwable) {
        null
    }
}
