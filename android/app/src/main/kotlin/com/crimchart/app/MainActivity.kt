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

class MainActivity : FlutterActivity() {
    private val CHANNEL = "crown.dev/account"
    private val REQUEST_CODE_GET_ACCOUNTS = 9001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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
