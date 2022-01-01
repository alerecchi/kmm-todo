package com.alerecchi.kmm_todo.android.list

import android.graphics.Color
import android.text.SpannableString
import android.text.style.ForegroundColorSpan
import android.text.style.StrikethroughSpan
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.alerecchi.kmm_todo.android.R
import com.alerecchi.kmm_todo.list.domain.TaskListAction
import com.alerecchi.kmm_todo.list.presentation.UiTask

class TaskListAdapter(
    private val handleAction: (TaskListAction) -> Unit
) : ListAdapter<UiTask, TaskViewHolder>(TaskDiffCallBack) {

    object TaskDiffCallBack : DiffUtil.ItemCallback<UiTask>() {
        override fun areItemsTheSame(oldItem: UiTask, newItem: UiTask): Boolean {
            return oldItem.id == newItem.id
        }

        override fun areContentsTheSame(oldItem: UiTask, newItem: UiTask): Boolean {
            return oldItem == newItem
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TaskViewHolder {
        return TaskViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.view_task, parent, false),
            handleAction
        )
    }

    override fun onBindViewHolder(holder: TaskViewHolder, position: Int) {
        holder.bindTo(getItem(position))
    }
}

class TaskViewHolder(
    view: View,
    private val handleAction: (TaskListAction) -> Unit
) : RecyclerView.ViewHolder(view) {

    fun bindTo(task: UiTask) {
        val actionImg = itemView.findViewById<ImageView>(R.id.actionOnTask)
        val completedImg = itemView.findViewById<ImageView>(R.id.completedIcon)
        val spannableTitle = SpannableString(task.title)
        val spannableDate = SpannableString(task.date)
        if(task.completed) {
            spannableDate.addStrikethrough()
            spannableTitle.addStrikethrough()
            completedImg.setImageDrawable(ContextCompat.getDrawable(itemView.context, R.drawable.ic_check))
            actionImg.setImageDrawable(ContextCompat.getDrawable(itemView.context, R.drawable.ic_delete))
        } else {
            if(task.expired) {
                spannableDate.addRedColor()
            }
            completedImg.setImageDrawable(ContextCompat.getDrawable(itemView.context, R.drawable.ic_unchecked))
            actionImg.setImageDrawable(ContextCompat.getDrawable(itemView.context, R.drawable.ic_modify))
        }

        itemView.findViewById<TextView>(R.id.title).text = spannableTitle
        itemView.findViewById<TextView>(R.id.date).text = spannableDate

        actionImg.setOnClickListener { handleAction(task.actionOnTask)}
        itemView.setOnClickListener { handleAction(task.clickAction) }
    }
}

private fun SpannableString.addStrikethrough() {
    setSpan(
        StrikethroughSpan(),
        0,
        length,
        SpannableString.SPAN_INCLUSIVE_INCLUSIVE
    )
}

private fun SpannableString.addRedColor() {
    setSpan(
        ForegroundColorSpan(Color.RED),
        0,
        length,
        SpannableString.SPAN_INCLUSIVE_INCLUSIVE
    )
}