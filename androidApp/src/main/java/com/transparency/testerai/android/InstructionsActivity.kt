package com.transparency.testerai.android

import ImageAdapter
import android.content.Context
import android.os.Bundle
import android.view.MenuItem
import android.widget.Button
import android.widget.Toolbar
import androidx.activity.ComponentActivity
import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator

class InstructionsActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_instructions)

        val viewPager = findViewById<ViewPager2>(R.id.viewPager)
        val btnDone = findViewById<Button>(R.id.btn_done)
        val toolbar: Toolbar = findViewById(R.id.toolbar)
        setActionBar(toolbar)
        actionBar.apply { title = "" }
        actionBar?.setDisplayHomeAsUpEnabled(true)

        btnDone.apply {
            setOnClickListener {
                // Write to prefs so tutorial doesnt show again later
//                val sharedPreferences = context.getSharedPreferences("prefs", Context.MODE_PRIVATE)
//                val editor = sharedPreferences.edit()
//                editor.putBoolean("tutorial_viewed", true)
//                editor.apply()

                // Proceed to main activity
                finish()
            }
        }
        val imagePaths = listOf(
            "instructions_1",
            "instructions_2",
            "instructions_3",
            "instructions_4",
            "instructions_5"
        )
        val tabLayout = findViewById<TabLayout>(R.id.tab_layout)

        val adapter = ImageAdapter(this, imagePaths)
        viewPager.adapter = adapter
        TabLayoutMediator(tabLayout, viewPager) { tab, position -> }.attach()
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            // Handle the Up button click
            android.R.id.home -> {
                onBackPressedDispatcher.onBackPressed()
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }
}
