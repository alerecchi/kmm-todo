package com.alerecchi.kmm_todo.utils

interface Observer<STATE> {

    fun updateState(state: STATE)
}

interface  Subject<STATE> {

    fun register(observer: Observer<STATE>)

    fun unRegister(observer: Observer<STATE>)

    fun updateState(state: STATE)
}