package com.alerecchi.kmm_todo.di

import com.alerecchi.kmm_todo.details.domain.TaskDetailsStateMachine
import com.alerecchi.kmm_todo.list.domain.TaskListStateMachine

object DomainModule {
    fun provideStateMachine() = TaskListStateMachine(DataModule.provideListDataSource())

    fun provideDetailsStateMachine() = TaskDetailsStateMachine(DataModule.provideDetailsDataSource())
}