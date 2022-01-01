package com.alerecchi.kmm_todo.model

import kotlinx.datetime.LocalDate

data class Task(
    val id: Long,
    val title: String,
    val completed: Boolean,
    val date: LocalDate
)