package com.alerecchi.kmm_todo.di

import com.alerecchi.todo.db.TodoDb
import com.squareup.sqldelight.db.SqlDriver
import com.squareup.sqldelight.drivers.native.NativeSqliteDriver

actual class DriverFactory {
    actual fun createDriver(): SqlDriver {
        return NativeSqliteDriver(TodoDb.Schema, "todo.db")
    }
}