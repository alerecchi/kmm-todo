package com.alerecchi.kmm_todo.di

import com.squareup.sqldelight.db.SqlDriver

expect class DriverFactory() {
    fun createDriver(): SqlDriver
}
