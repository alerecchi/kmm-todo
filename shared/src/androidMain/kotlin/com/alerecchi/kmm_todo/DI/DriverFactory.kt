package com.alerecchi.kmm_todo.di

import android.content.Context
import com.alerecchi.todo.db.TodoDb
import com.squareup.sqldelight.android.AndroidSqliteDriver
import com.squareup.sqldelight.db.SqlDriver

lateinit var appContext: Context

actual class DriverFactory {
    actual fun createDriver(): SqlDriver {
        return AndroidSqliteDriver(TodoDb.Schema, appContext, "todo.db")
    }
}