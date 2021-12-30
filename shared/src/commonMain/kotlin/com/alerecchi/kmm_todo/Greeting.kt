package com.alerecchi.kmm_todo

class Greeting {
    fun greeting(): String {
        return "Hello, ${Platform().platform}!"
    }
}