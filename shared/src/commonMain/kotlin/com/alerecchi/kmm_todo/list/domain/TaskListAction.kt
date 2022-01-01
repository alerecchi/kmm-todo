package com.alerecchi.kmm_todo.list.domain

import com.alerecchi.kmm_todo.model.Task

sealed class TaskListAction {

    object LoadTasks : TaskListAction()

    data class ToggleTask(val task: Task) : TaskListAction()

    data class ModifyTask(val id: Long) : TaskListAction()

    data class DeleteTask(val id: Long) : TaskListAction()

    object AddTask: TaskListAction()
}