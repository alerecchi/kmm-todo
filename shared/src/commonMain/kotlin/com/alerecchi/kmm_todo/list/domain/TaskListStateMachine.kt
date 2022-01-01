package com.alerecchi.kmm_todo.list.domain

import com.alerecchi.kmm_todo.list.data.TaskListDataSource
import com.alerecchi.kmm_todo.utils.StateMachine

class TaskListStateMachine(
    private val dataSource: TaskListDataSource
) : StateMachine<TaskListState, TaskListAction>() {

    override var lastState: TaskListState = TaskListState.Loading

    override suspend fun reducer(
        state: TaskListState,
        action: TaskListAction
    ): TaskListState {
        println()
        return when (action) {
            TaskListAction.LoadTasks -> {
                getListState()
            }
            is TaskListAction.DeleteTask -> {
                dataSource.deleteTask(action.id)
                getListState()
            }
            is TaskListAction.ModifyTask -> {
                TaskListState.NavigateToDetails(action.id)
            }
            is TaskListAction.ToggleTask -> {
                action.task.run {
                    dataSource.toggleTask(id, !completed)
                }
                getListState()
            }
            TaskListAction.AddTask -> {
                TaskListState.NavigateToDetails(null)
            }
        }
    }

    private suspend fun getListState(): TaskListState.ShowList {
        return TaskListState.ShowList(dataSource.getAllTasks().sortedBy { it.completed })
    }
}