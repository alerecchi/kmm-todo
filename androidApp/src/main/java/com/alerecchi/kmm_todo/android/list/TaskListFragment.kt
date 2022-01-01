package com.alerecchi.kmm_todo.android.list

import android.os.Bundle
import android.view.View
import android.widget.Button
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.alerecchi.kmm_todo.android.R
import com.alerecchi.kmm_todo.android.details.TaskDetailsFragment
import com.alerecchi.kmm_todo.di.DomainModule
import com.alerecchi.kmm_todo.list.domain.TaskListAction
import com.alerecchi.kmm_todo.list.domain.TaskListState
import com.alerecchi.kmm_todo.list.presentation.toUiTask
import com.alerecchi.kmm_todo.utils.Observer

class TaskListFragment : Fragment(R.layout.fragment_task_list), Observer<TaskListState> {

    private val stateMachine = DomainModule.provideStateMachine()

    private lateinit var adapter: TaskListAdapter

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        stateMachine.register(this)
        adapter = TaskListAdapter { action ->
            lifecycleScope.launchWhenStarted {
                stateMachine.handleAction(action)
            }
        }
        val recycler = view.findViewById<RecyclerView>(R.id.taskList)
        recycler.adapter = adapter
        recycler.layoutManager = LinearLayoutManager(context)

        lifecycleScope.launchWhenStarted {
            stateMachine.handleAction(TaskListAction.LoadTasks)
        }
        view.findViewById<Button>(R.id.addTask).setOnClickListener {
            lifecycleScope.launchWhenStarted {
                stateMachine.handleAction(TaskListAction.AddTask)
            }
        }
        super.onViewCreated(view, savedInstanceState)
    }

    override fun onDestroyView() {
        stateMachine.unRegister(this)
        super.onDestroyView()
    }

    override fun updateState(state: TaskListState) {
        when(state) {
            TaskListState.Loading -> {
            //do nothing
            }
            is TaskListState.NavigateToDetails -> {
                val f = TaskDetailsFragment()
                state.id?.let {
                    f.arguments = Bundle().apply {
                        putLong(TaskDetailsFragment.ARGS_ID, it)
                    }
                }
                parentFragmentManager.beginTransaction()
                    .replace(R.id.main_view, f)
                    .addToBackStack(null)
                    .commit()
            }
            is TaskListState.ShowList -> {
                adapter.submitList(state.tasks.map { it.toUiTask() })
            }
        }
    }
}