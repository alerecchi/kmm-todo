package com.alerecchi.kmm_todo.list.domain

import com.alerecchi.kmm_todo.model.Task

sealed class TaskListState {

    object Loading: TaskListState()

    data class ShowList(val tasks: List<Task>): TaskListState()

    data class NavigateToDetails(val id: Long?): TaskListState()
}