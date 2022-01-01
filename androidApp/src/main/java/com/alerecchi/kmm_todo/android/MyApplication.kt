package com.alerecchi.kmm_todo.android

import android.app.Application
import com.alerecchi.kmm_todo.di.appContext

class MyApplication: Application() {

    override fun onCreate() {
        appContext = applicationContext
        super.onCreate()
    }
}