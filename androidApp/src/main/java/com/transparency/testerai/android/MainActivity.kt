package com.transparency.testerai.android

import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.webkit.WebResourceError
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.ProgressBar
import android.widget.TextView
import androidx.activity.ComponentActivity
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

//        val swipeRefreshLayout: SwipeRefreshLayout = findViewById(R.id.swipeRefreshLayout)
        val webView: WebView = findViewById(R.id.webView)
        val progressBar: ProgressBar = findViewById(R.id.progressBar)
        val errorMessage: TextView = findViewById(R.id.errorMessage)
        val retry: TextView = findViewById(R.id.retry)
        retry.setOnClickListener {
            webView.loadUrl("https://mediafiles.botpress.cloud/697af148-5a35-46d1-b017-c1be5192d0d2/webchat/bot.html")
        }
        webView.apply {
            settings.domStorageEnabled = true
            settings.javaScriptCanOpenWindowsAutomatically = true
            settings.allowUniversalAccessFromFileURLs = true
            settings.allowFileAccessFromFileURLs = true
            settings.javaScriptEnabled = true
            settings.databaseEnabled = true
        }

        // Set up refresh listener
//        swipeRefreshLayout.setOnRefreshListener {
//            webView.reload()
//        }

//        swipeRefreshLayout.apply {
//        webView.setOnScrollChangeListener { _, _, scrollY, _, _ ->
//            swipeRefreshLayout.isEnabled = scrollY == 0
//        }

        webView.webViewClient = object : WebViewClient() {

            override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
                // Always open the URL externally
                if (!url.isNullOrEmpty() && Uri.parse(url).scheme != null) {
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                    startActivity(intent)
                    return true
                }
                return false
            }

            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)
                progressBar.visibility = ProgressBar.VISIBLE
                errorMessage.visibility = TextView.GONE
                retry.visibility = TextView.GONE
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                progressBar.visibility = ProgressBar.GONE
                retry.visibility = TextView.GONE
                // Configure WebView to stop refreshing when the page is finished loading
//                swipeRefreshLayout.isRefreshing = false
            }

            override fun onReceivedError(
                view: WebView?,
                request: WebResourceRequest?,
                error: WebResourceError?
            ) {
                super.onReceivedError(view, request, error)
                progressBar.visibility = ProgressBar.GONE
                errorMessage.visibility = TextView.VISIBLE
                retry.visibility = TextView.VISIBLE
            }
        }

        webView.loadUrl("https://mediafiles.botpress.cloud/697af148-5a35-46d1-b017-c1be5192d0d2/webchat/bot.html")
    }
}

@Composable
fun GreetingView(text: String) {
    Text(text = text)
}

@Preview
@Composable
fun DefaultPreview() {
    MyApplicationTheme {
        GreetingView("Hello, Android!")
    }
}
