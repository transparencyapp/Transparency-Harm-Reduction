package com.transparency.testerai.android

import ImageAdapter
import android.content.Context
import android.os.Bundle
import android.view.MenuItem
import android.widget.Button
import android.widget.ImageView
import android.widget.Toolbar
import androidx.activity.ComponentActivity
import androidx.appcompat.content.res.AppCompatResources
import androidx.core.content.res.ResourcesCompat
import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator

class SpotKitActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_spot_kit)

        val imageView: ImageView = findViewById(R.id.imageView)
        val btnDone = findViewById<Button>(R.id.btn_done)
        val toolbar: Toolbar = findViewById(R.id.toolbar)
        setActionBar(toolbar)
        actionBar.apply { title = "" }
        actionBar?.setDisplayHomeAsUpEnabled(true)

        imageView.setImageDrawable(AppCompatResources.getDrawable(this, R.drawable.how_do_spot_kits_work))
        btnDone.apply {
            setOnClickListener {
                finish()
            }
        }
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
