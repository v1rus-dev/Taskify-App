package yegor.cheprasov.taskify.widgets

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.glance.Button
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.ImageProvider
import androidx.glance.LocalContext
import androidx.glance.LocalSize
import androidx.glance.action.actionParametersOf
import androidx.glance.appwidget.CheckBox
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.updateAll
import androidx.glance.background
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import kotlinx.coroutines.runBlocking
import yegor.cheprasov.taskify.MainActivity
import yegor.cheprasov.taskify.R

internal class TodayTasksWidget : GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            TodayTasksWidgetContent()
        }
    }

    @Composable
    private fun TodayTasksWidgetContent() {
        val context = LocalContext.current
        val snapshot = WidgetDataStore(context).readSnapshot()
        val size = LocalSize.current
        val maxItems = if (size.height < 140.dp) 3 else 6
        val tasks = snapshot.tasks.take(maxItems)

        Column(
            modifier = GlanceModifier
                .fillMaxSize()
                .padding(12.dp)
                .background(ImageProvider(R.drawable.widget_card_background))
                .padding(12.dp),
        ) {
            Text(
                text = "Today",
                style = androidx.glance.text.TextStyle(
                    fontWeight = FontWeight.Medium,
                ),
            )
            Spacer(modifier = GlanceModifier.size(8.dp))

            if (tasks.isEmpty()) {
                Text(
                    text = "You have no tasks today",
                )
                Spacer(modifier = GlanceModifier.size(8.dp))
                Button(
                    text = "Add task",
                    onClick = actionStartActivity(
                        MainActivity.buildIntent(context, "/home?openEdit=true"),
                    ),
                )
            } else {
                tasks.forEach { task ->
                    Row(modifier = GlanceModifier.fillMaxWidth()) {
                        CheckBox(
                            checked = task.isCompleted,
                            onCheckedChange = actionRunCallback<ToggleTaskAction>(
                                actionParametersOf(
                                    ToggleTaskAction.TaskIdKey to task.id,
                                ),
                            ),
                        )
                        Text(
                            text = task.title,
                            modifier = GlanceModifier.padding(start = 8.dp),
                        )
                    }
                    Spacer(modifier = GlanceModifier.size(4.dp))
                }
                Spacer(modifier = GlanceModifier.size(8.dp))
                Button(
                    text = "Add task",
                    onClick = actionStartActivity(
                        MainActivity.buildIntent(context, "/home?openEdit=true"),
                    ),
                )
            }
        }
    }

    companion object {
        fun refresh(context: Context) {
            runBlocking {
                TodayTasksWidget().updateAll(context)
            }
        }
    }
}
