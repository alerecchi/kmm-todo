package com.alerecchi.kmm_todo.android

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.alerecchi.kmm_todo.Greeting
import android.widget.TextView
import com.alerecchi.kmm_todo.android.list.TaskListFragment

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        supportFragmentManager.beginTransaction()
            .replace(R.id.main_view, TaskListFragment())
            .commit()
    }
}
