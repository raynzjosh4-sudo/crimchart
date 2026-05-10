package com.crimchart.app

import android.Manifest
import android.accounts.Account
import android.accounts.AccountManager
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry
import android.view.Surface

class MainActivity : FlutterActivity() {
    private val CHANNEL = "crown.dev/account"
    private val VIDEO_CHANNEL = "crown.dev/video_engine"
    private val REQUEST_CODE_GET_ACCOUNTS = 9001

    companion object {
        init {
            System.loadLibrary("crimchart_native")
        }
    }

    private val activeSurfaces = mutableMapOf<Long, Surface>()
    private val activeEntries = mutableMapOf<Long, TextureRegistry.SurfaceTextureEntry>()

    external fun initVideoEngineSurface(textureId: Long, surface: Surface)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VIDEO_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "createTexture") {
                val entry = flutterEngine.renderer.createSurfaceTexture()
                val surface = Surface(entry.surfaceTexture())
                
                // Keep references alive so the JVM garbage collector doesn't destroy the Surface 
                // and abandon the Native C++ BufferQueue!
                activeEntries[entry.id()] = entry
                activeSurfaces[entry.id()] = surface
                
                // Pass the surface directly to our custom C++ Engine via JNI!
                initVideoEngineSurface(entry.id(), surface)
                
                // Return the Flutter Texture ID back to Dart so it can render it
                result.success(entry.id())
            } else if (call.method == "disposeTexture") {
                val textureId = call.argument<Number>("textureId")?.toLong() ?: return@setMethodCallHandler result.success(false)
                activeSurfaces[textureId]?.release()
                activeEntries[textureId]?.release()
                activeSurfaces.remove(textureId)
                activeEntries.remove(textureId)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAccounts" || call.method == "getAccount" || call.method == "getacount") {
                if (ContextCompat.checkSelfPermission(this, Manifest.permission.GET_ACCOUNTS)
                    != PackageManager.PERMISSION_GRANTED
                ) {
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(Manifest.permission.GET_ACCOUNTS),
                        REQUEST_CODE_GET_ACCOUNTS
                    )
                    result.error("PERMISSION_DENIED", "Permission GET_ACCOUNTS required", null)
                } else {
                    result.success(fetchAccounts())
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun fetchAccounts(): List<String> {
        val accountManager = getSystemService(ACCOUNT_SERVICE) as AccountManager
        val accounts: Array<Account> = accountManager.accounts
        return accounts
            .filter { it.name.contains("@") }
            .map { it.name }
            .distinct()
    }
}
