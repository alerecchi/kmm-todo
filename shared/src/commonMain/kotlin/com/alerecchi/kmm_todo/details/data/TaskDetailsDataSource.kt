package com.alerecchi.kmm_todo.details.data

import com.alerecchi.kmm_todo.list.data.toLong
import com.alerecchi.kmm_todo.model.Task
import com.alerecchi.todo.db.TodoDb
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.datetime.LocalDate

interface TaskDetailsDataSource {
    suspend fun getTask(id: Long): Task
    suspend fun updateTask(id: Long, title: String, date: LocalDate)
    suspend fun insertTask(title: String, date: LocalDate)
}

class TaskDetailsDataSourceImpl(
    private val db: TodoDb
) : TaskDetailsDataSource {
    override suspend fun getTask(id: Long): Task {
        return withContext(Dispatchers.Default) {
            db.tododbQueries.selectTask(id) { id, title, date, completed ->
                Task(id, title, completed == 1L, LocalDate.parse(date))
            }.executeAsOne()
        }
    }

    override suspend fun updateTask(id: Long, title: String, date: LocalDate) {
        withContext(Dispatchers.Default) {
            db.tododbQueries.updateTask(title, date.toString(), id)
        }
    }

    override suspend fun insertTask(title: String, date: LocalDate) {
        withContext(Dispatchers.Default) {
            db.tododbQueries.insertTask(title, date.toString())
        }
    }
}