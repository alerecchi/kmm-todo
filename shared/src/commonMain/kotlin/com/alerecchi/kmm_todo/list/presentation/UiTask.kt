package com.alerecchi.kmm_todo.list.presentation

import com.alerecchi.kmm_todo.model.Task
import com.alerecchi.kmm_todo.list.domain.TaskListAction
import kotlinx.datetime.Clock
import kotlinx.datetime.TimeZone
import kotlinx.datetime.daysUntil
import kotlinx.datetime.toLocalDateTime

data class UiTask(
    val id: Long,
    val title: String,
    val completed: Boolean,
    val date: String,
    val expired: Boolean,
    val clickAction: TaskListAction,
    val actionOnTask: TaskListAction
)

fun Task.toUiTask(): UiTask {
    return UiTask(
        id = id,
        title = title,
        completed = completed,
        date = date.toString(),
        expired = date.daysUntil(
            Clock.System.now().toLocalDateTime(
                TimeZone.currentSystemDefault()
            ).date
        ) > 0,
        clickAction = TaskListAction.ToggleTask(this),
        actionOnTask = if (completed)
            TaskListAction.DeleteTask(id)
        else
            TaskListAction.ModifyTask(id)
    )
}