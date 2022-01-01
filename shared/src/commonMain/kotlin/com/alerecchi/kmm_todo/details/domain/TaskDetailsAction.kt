package com.alerecchi.kmm_todo.details.domain

sealed class TaskDetailsAction {

    data class LoadTask(val id: Long?) : TaskDetailsAction()

    data class InsertTask(val title: String, val date: String): TaskDetailsAction()

    data class UpdateTask(val id: Long, val title: String, val date: String): TaskDetailsAction()
}