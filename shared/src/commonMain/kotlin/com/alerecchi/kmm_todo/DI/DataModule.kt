package com.alerecchi.kmm_todo.di

import com.alerecchi.kmm_todo.details.data.TaskDetailsDataSource
import com.alerecchi.kmm_todo.details.data.TaskDetailsDataSourceImpl
import com.alerecchi.kmm_todo.list.data.TaskListDataSource
import com.alerecchi.kmm_todo.list.data.TaskDataSourceImpl
import com.alerecchi.kmm_todo.list.domain.TaskListStateMachine
import com.alerecchi.todo.db.TodoDb

object DataModule {

    private fun provideDb(): TodoDb = TodoDb(DriverFactory().createDriver())

    fun provideListDataSource(): TaskListDataSource = TaskDataSourceImpl(provideDb())

    fun provideDetailsDataSource(): TaskDetailsDataSource = TaskDetailsDataSourceImpl(provideDb())
}