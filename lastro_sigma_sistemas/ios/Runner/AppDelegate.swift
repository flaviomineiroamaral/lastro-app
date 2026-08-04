import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    private let channelName = "lastro.financas/share_intent"
    private var pendingFilePath: String?
    private var pendingFileName: String?
    private var channel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller = window?.rootViewController as! FlutterViewController
        channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: controller.binaryMessenger
        )

        channel?.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            switch call.method {
            case "getSharedFile":
                if let path = self.pendingFilePath {
                    result(["path": path, "name": self.pendingFileName ?? "arquivo"])
                    self.pendingFilePath = nil
                    self.pendingFileName = nil
                } else {
                    result(nil)
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Chamado quando o app recebe um arquivo via "Abrir com" / "Compartilhar" (iOS)
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        handleIncomingFile(url: url)
        return true
    }

    // Chamado no iOS 13+ para arquivos compartilhados via Share Sheet
    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {
            handleIncomingFile(url: url)
        }
        return true
    }

    private func handleIncomingFile(url: URL) {
        do {
            // Copia o arquivo para o diretório de documentos do app (acesso permanente)
            let fm = FileManager.default
            let destDir = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destURL = destDir.appendingPathComponent("shared_\(url.lastPathComponent)")

            if fm.fileExists(atPath: destURL.path) {
                try fm.removeItem(at: destURL)
            }

            // Requer acesso ao arquivo de segurança (scoped)
            let accessing = url.startAccessingSecurityScopedResource()
            try fm.copyItem(at: url, to: destURL)
            if accessing { url.stopAccessingSecurityScopedResource() }

            pendingFilePath = destURL.path
            pendingFileName = url.lastPathComponent

            // Notifica Flutter imediatamente se o canal estiver pronto
            channel?.invokeMethod("onSharedFile", arguments: [
                "path": destURL.path,
                "name": url.lastPathComponent
            ])
        } catch {
            print("[Lastro] Erro ao copiar arquivo compartilhado: \(error)")
        }
    }
}
