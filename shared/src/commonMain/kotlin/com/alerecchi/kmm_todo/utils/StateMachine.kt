package com.alerecchi.kmm_todo.utils

abstract class StateMachine <STATE: Any, ACTION>: Subject<STATE> {

    protected abstract var lastState: STATE

    private val observables = mutableListOf<Observer<STATE>>()

    override fun register(observer: Observer<STATE>) {
        observables.add(observer)
    }

    override fun unRegister(observer: Observer<STATE>) {
        observables.remove(observer)
    }

    override fun updateState(state: STATE) {
        lastState = state
        observables.forEach { it.updateState(state) }
    }

    suspend fun handleAction(action: ACTION) {
        updateState(reducer(lastState, action))
    }

    protected abstract suspend fun reducer(state: STATE, action: ACTION): STATE
}