package com.alerecchi.kmm_todo.details.domain

import com.alerecchi.kmm_todo.details.data.TaskDetailsDataSource
import com.alerecchi.kmm_todo.utils.StateMachine
import kotlinx.datetime.LocalDate

class TaskDetailsStateMachine(
    private val detailsDataSource: TaskDetailsDataSource
): StateMachine<TaskDetailsState, TaskDetailsAction>() {

    override var lastState: TaskDetailsState = TaskDetailsState.Loading

    override suspend fun reducer(
        state: TaskDetailsState,
        action: TaskDetailsAction
    ): TaskDetailsState {
        return when(action) {
            is TaskDetailsAction.LoadTask -> {
                if(action.id != null) {
                    val task = detailsDataSource.getTask(action.id)
                    TaskDetailsState.TaskLoaded(
                        task.id,
                        task.title,
                        task.date.toString()
                    ) { id, title, date ->
                        TaskDetailsAction.UpdateTask(id, title, date)
                    }
                } else {
                    TaskDetailsState.PageLoaded { title, date ->
                        TaskDetailsAction.InsertTask(title, date)
                    }
                }
            }
            is TaskDetailsAction.InsertTask -> {
                detailsDataSource.insertTask(action.title, LocalDate.parse(action.date))
                TaskDetailsState.BackNavigation
            }
            is TaskDetailsAction.UpdateTask -> {
                detailsDataSource.updateTask(action.id, action.title,  LocalDate.parse(action.date))
                TaskDetailsState.BackNavigation
            }
        }
    }
}