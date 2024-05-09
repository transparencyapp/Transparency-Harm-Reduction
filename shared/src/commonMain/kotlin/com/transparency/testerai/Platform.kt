package com.transparency.testerai

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform
expect fun getImageResource(): String