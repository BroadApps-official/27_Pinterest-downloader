import SwiftUI
import ApphudSDK
import AppTrackingTransparency
import AdSupport

@main
struct PinterestDownloaderApp: App {
    
    @StateObject private var dataController = DataController()
    
    init() {
       Apphud.start(apiKey: "app_RDqtprQBGjjvXsg5mADK81BGmL2bH6")
       Apphud.setDeviceIdentifiers(idfa: nil, idfv: UIDevice.current.identifierForVendor?.uuidString)
       fetchIDFA()
     }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
    
    func fetchIDFA() {
      if #available(iOS 14.5, *) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
          ATTrackingManager.requestTrackingAuthorization { status in
            guard status == .authorized else { return }

            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            Apphud.setDeviceIdentifiers(idfa: idfa, idfv: UIDevice.current.identifierForVendor?.uuidString)
          }
        }
      }
    }
}
