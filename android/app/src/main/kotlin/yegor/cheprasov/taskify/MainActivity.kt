package yegor.cheprasov.taskify

import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import yegor.cheprasov.taskify.widgets.TodayTasksWidget

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_NAME,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "refreshWidgets" -> {
                    TodayTasksWidget.refresh(applicationContext)
                    result.success(null)
                }
                "getSharedContainerPath" -> {
                    val flutterDir = applicationContext.getDir("flutter", Context.MODE_PRIVATE)
                    result.success(flutterDir.path)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun getInitialRoute(): String? {
        val initialRoute = intent?.getStringExtra(INITIAL_ROUTE_EXTRA)
        return initialRoute ?: "/"
    }

    companion object {
        private const val CHANNEL_NAME = "taskify/widget_bridge"
        private const val INITIAL_ROUTE_EXTRA = "initial_route"

        fun buildIntent(context: Context, route: String): Intent {
            val normalizedRoute = if (route.startsWith("/")) route else "/$route"
            val routeUri = Uri.parse("taskify://widget$normalizedRoute")
            return Intent(context, MainActivity::class.java).apply {
                data = routeUri
                putExtra(INITIAL_ROUTE_EXTRA, normalizedRoute)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
        }
    }
}
