package com.jboycode.home_widget_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class MyAppWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.my_widget_layout)

            val prefs = HomeWidgetPlugin.getData(context)
            val counter = prefs.getInt("counter", 0)
            val message = prefs.getString("message", "Widget") ?: "Widget"

            views.setTextViewText(R.id.widget_counter, counter.toString())
            views.setTextViewText(R.id.widget_message, message)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
