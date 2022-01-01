package com.alerecchi.kmm_todo.list.data

import com.alerecchi.kmm_todo.model.Task
import com.alerecchi.todo.db.TodoDb
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.datetime.LocalDate

interface TaskListDataSource {
    suspend fun getAllTasks(): List<Task>
    suspend fun deleteTask(id: Long)
    suspend fun toggleTask(id: Long, completed: Boolean)
}

class TaskDataSourceImpl(
    private val db: TodoDb
) : TaskListDataSource {

    override suspend fun getAllTasks(): List<Task> {
        return withContext(Dispatchers.Default) {
            db.tododbQueries.selectAll { id, title, date, completed ->
                Task(
                    id,
                    title,
                    date = LocalDate.parse(date),
                    completed = completed == 1L
                )
            }.executeAsList()
        }
    }

    override suspend fun deleteTask(id: Long) {
        withContext(Dispatchers.Default) {
            db.tododbQueries.deleteTask(id)
        }
    }

    override suspend fun toggleTask(id: Long, completed: Boolean) {
        withContext(Dispatchers.Default) {
            db.tododbQueries.toggleTask(completed.toLong(), id)
        }
    }
}

fun Boolean.toLong(): Long = if (this) 1 else 0