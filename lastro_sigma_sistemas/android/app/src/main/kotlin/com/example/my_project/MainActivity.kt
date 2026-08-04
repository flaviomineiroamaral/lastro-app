package lastro.financas

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "lastro.financas/share_intent"
    }

    private var pendingSharedFilePath: String? = null
    private var pendingSharedFileName: String? = null
    private var channel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Captura arquivo recebido na abertura (cold start)
        handleIncomingIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Captura arquivo recebido com app já aberto (foreground)
        handleIncomingIntent(intent)
        // Notifica o Flutter imediatamente se o canal já estiver pronto
        sendPendingFileToFlutter()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getSharedFile" -> {
                    if (pendingSharedFilePath != null) {
                        result.success(mapOf(
                            "path" to pendingSharedFilePath,
                            "name" to pendingSharedFileName
                        ))
                        // Limpa para não reprocessar
                        pendingSharedFilePath = null
                        pendingSharedFileName = null
                    } else {
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }
        // Envia arquivo pendente assim que o canal estiver pronto
        sendPendingFileToFlutter()
    }

    private fun handleIncomingIntent(intent: Intent?) {
        if (intent?.action == Intent.ACTION_SEND) {
            val uri: Uri? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
            } else {
                @Suppress("DEPRECATION")
                intent.getParcelableExtra(Intent.EXTRA_STREAM)
            }
            if (uri != null) {
                val copiedFile = copyUriToCache(uri)
                if (copiedFile != null) {
                    pendingSharedFilePath = copiedFile.absolutePath
                    pendingSharedFileName = getFileNameFromUri(uri) ?: copiedFile.name
                }
            }
        }
    }

    private fun copyUriToCache(uri: Uri): File? {
        return try {
            val fileName = getFileNameFromUri(uri) ?: "arquivo_compartilhado"
            val cacheFile = File(cacheDir, "shared_$fileName")
            contentResolver.openInputStream(uri)?.use { input ->
                FileOutputStream(cacheFile).use { output ->
                    input.copyTo(output)
                }
            }
            cacheFile
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun getFileNameFromUri(uri: Uri): String? {
        return try {
            contentResolver.query(uri, null, null, null, null)?.use { cursor ->
                val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                cursor.moveToFirst()
                cursor.getString(nameIndex)
            } ?: uri.lastPathSegment
        } catch (e: Exception) {
            uri.lastPathSegment
        }
    }

    private fun sendPendingFileToFlutter() {
        val path = pendingSharedFilePath ?: return
        val name = pendingSharedFileName
        channel?.invokeMethod("onSharedFile", mapOf("path" to path, "name" to name))
        pendingSharedFilePath = null
        pendingSharedFileName = null
    }
}
