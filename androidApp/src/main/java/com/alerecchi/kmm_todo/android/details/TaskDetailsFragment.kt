package com.alerecchi.kmm_todo.android.details

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import com.alerecchi.kmm_todo.android.R
import com.alerecchi.kmm_todo.details.domain.TaskDetailsAction
import com.alerecchi.kmm_todo.details.domain.TaskDetailsState
import com.alerecchi.kmm_todo.di.DomainModule
import com.alerecchi.kmm_todo.utils.Observer

class TaskDetailsFragment : Fragment(R.layout.fragment_task_details), Observer<TaskDetailsState> {

    private val stateMachine = DomainModule.provideDetailsStateMachine()

    companion object {
        const val ARGS_ID = "id"
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        stateMachine.register(this)
        val id: Long? = arguments?.getLong(ARGS_ID)
        lifecycleScope.launchWhenStarted {
            stateMachine.handleAction(TaskDetailsAction.LoadTask(id))
        }
    }

    override fun onDestroyView() {
        stateMachine.unRegister(this)
        super.onDestroyView()
    }

    @SuppressLint("SetTextI18n")
    override fun updateState(state: TaskDetailsState) {
        val title = requireView().findViewById<EditText>(R.id.titleEdit)
        val date = requireView().findViewById<EditText>(R.id.dateEdit)
        when (state) {
            TaskDetailsState.BackNavigation -> {
                parentFragmentManager.popBackStack()
            }
            TaskDetailsState.Loading -> {
                //do nothing
            }
            is TaskDetailsState.PageLoaded -> {
                view?.findViewById<TextView>(R.id.PageTitle)?.text = "Add task"
                view?.findViewById<Button>(R.id.saveTask)?.setOnClickListener {
                    lifecycleScope.launchWhenStarted {
                        stateMachine.handleAction(
                            state.ctaAction(
                                title.text.toString(),
                                date.text.toString()
                            )
                        )

                    }
                }
            }
            is TaskDetailsState.TaskLoaded -> {
                view?.findViewById<TextView>(R.id.PageTitle)?.text = "Edit task"
                title.setText(state.title)
                date.setText(state.date)
                view?.findViewById<Button>(R.id.saveTask)?.setOnClickListener {
                    lifecycleScope.launchWhenStarted {
                        stateMachine.handleAction(
                            state.ctaAction(
                                state.id,
                                title.text.toString(),
                                date.text.toString()
                            )
                        )
                    }
                }
            }
        }
    }


}