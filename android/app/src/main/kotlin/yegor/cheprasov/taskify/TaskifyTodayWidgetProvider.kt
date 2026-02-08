package yegor.cheprasov.taskify

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray

class TaskifyTodayWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { appWidgetId ->
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        updateAppWidget(context, appWidgetManager, appWidgetId)
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.widget_today_tasks)
        val prefs = HomeWidgetPlugin.getData(context)
        val tasksJson = prefs.getString(TASKS_JSON_KEY, "[]") ?: "[]"
        val tasks = parseTasks(tasksJson)

        val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
        val maxItems = resolveMaxItems(options)
        val visibleTasks = tasks.take(maxItems)

        val hasTasks = visibleTasks.isNotEmpty()
        views.setViewVisibility(R.id.widget_empty_container, if (hasTasks) View.GONE else View.VISIBLE)
        views.setViewVisibility(R.id.widget_tasks_container, if (hasTasks) View.VISIBLE else View.GONE)
        views.setViewVisibility(R.id.widget_create_button_header, if (hasTasks) View.VISIBLE else View.GONE)

        views.removeAllViews(R.id.widget_tasks_container)
        visibleTasks.forEach { task ->
            val taskView = RemoteViews(context.packageName, R.layout.widget_today_task_item)
            taskView.setTextViewText(R.id.widget_task_title, task.title)

            val taskUri = Uri.parse("taskify://task/${task.id}")
            val taskIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                taskUri,
            )
            taskView.setOnClickPendingIntent(R.id.widget_task_item_container, taskIntent)

            views.addView(R.id.widget_tasks_container, taskView)
        }

        val createIntent = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            Uri.parse("taskify://create"),
        )
        views.setOnClickPendingIntent(R.id.widget_create_button, createIntent)
        views.setOnClickPendingIntent(R.id.widget_create_button_header, createIntent)

        val remainingCount = tasks.size - visibleTasks.size
        if (hasTasks && remainingCount > 0) {
            views.setViewVisibility(R.id.widget_more_tasks, View.VISIBLE)
            views.setTextViewText(
                R.id.widget_more_tasks,
                context.getString(R.string.more_tasks, remainingCount),
            )
        } else {
            views.setViewVisibility(R.id.widget_more_tasks, View.GONE)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun parseTasks(rawJson: String): List<WidgetTaskItem> {
        val result = mutableListOf<WidgetTaskItem>()

        try {
            val jsonArray = JSONArray(rawJson)
            for (index in 0 until jsonArray.length()) {
                val item = jsonArray.optJSONObject(index) ?: continue
                val id = item.optInt("id", -1)
                val title = item.optString("title", "").trim()
                if (id <= 0 || title.isEmpty()) {
                    continue
                }

                result.add(WidgetTaskItem(id = id, title = title))
            }
        } catch (_: Throwable) {
            return emptyList()
        }

        return result
    }

    private fun resolveMaxItems(options: Bundle): Int {
        val minHeightDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)
        val minWidthDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)

        if (minHeightDp <= 110 || minWidthDp <= 110) {
            return 3
        }

        if (minHeightDp <= 180) {
            return 5
        }

        if (minHeightDp <= 260) {
            return 8
        }

        return 12
    }

    private data class WidgetTaskItem(
        val id: Int,
        val title: String,
    )

    private companion object {
        const val TASKS_JSON_KEY = "today_tasks_json"
    }
}
