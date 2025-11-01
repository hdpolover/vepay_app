package id.vepay.vepay

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Enable edge-to-edge display for all Android versions
        WindowCompat.setDecorFitsSystemWindows(window, false)
        
        // Configure system bars appearance
        val windowInsetsController = WindowCompat.getInsetsController(window, window.decorView)
        windowInsetsController.systemBarsBehavior = WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        
        // For Android 15+ compatibility - explicitly enable edge-to-edge
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
            // Call enableEdgeToEdge() for explicit compatibility
            try {
                val edgeToEdgeClass = Class.forName("androidx.activity.EdgeToEdge")
                val enableMethod = edgeToEdgeClass.getMethod("enable", android.app.Activity::class.java)
                enableMethod.invoke(null, this)
            } catch (e: Exception) {
                // Fallback if EdgeToEdge is not available
                WindowCompat.setDecorFitsSystemWindows(window, false)
            }
        }
    }
}
