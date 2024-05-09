package com.transparency.testerai

class AndroidPlatform : Platform {
    override val name: String = "Android ${android.os.Build.VERSION.SDK_INT}"
}

actual fun getPlatform(): Platform = AndroidPlatform()
actual fun getImageResource(): String {
    TODO("Not yet implemented")
}