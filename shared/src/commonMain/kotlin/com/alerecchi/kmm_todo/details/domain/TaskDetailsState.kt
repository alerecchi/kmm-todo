package com.alerecchi.kmm_todo.details.domain

sealed class TaskDetailsState {

    object Loading : TaskDetailsState()

    object BackNavigation: TaskDetailsState()

    data class PageLoaded(
        val ctaAction: (String, String) -> TaskDetailsAction
    ): TaskDetailsState()

    data class TaskLoaded(
        val id: Long,
        val title: String,
        val date: String,
        val ctaAction: (Long, String, String) -> TaskDetailsAction
    ): TaskDetailsState()
}