import SwiftUI
import UserNotifications
import StoreKit
import ApphudSDK

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isNotificationEnabled: Bool = false
    
    
    var body: some View {
        
        VStack {
            
            if #available(iOS 16.0, *) {
                List {
                    
                    Section(header:
                                Text("Purchases")
                        .font(.footnoteEmphasized)
                        .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                    ) {
                        SettingsRowView(iconName: "crown", title: "Upgrade plan", value: nil, action: {})
                        SettingsRowView(iconName: "arrow.counterclockwise", title: "Restore purchases", value: nil, action: {restorePurchases()})
                    }
                    
                    Section(header:
                                Text("Actions")
                        .font(.footnoteEmphasized)
                        .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                    ) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .frame(width: 36, alignment: .center)
                                .foregroundColor(.accentPrimary)
                            
                            Text("Notifications")
                                .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255))
                            
                            Spacer()
                            
                            Toggle("", isOn: $isNotificationEnabled)
                                .tint(.accentPrimary)
                        }
                        .listRowBackground(Color(red: 1, green: 229/255, blue: 233/255, opacity: 0.5))
                        
                        SettingsRowView(iconName: "trash", title: "Clear cache", value: "5 MB", action: {})
                    }
                    
                    Section(header:
                                Text("Support us")
                        .font(.footnoteEmphasized)
                        .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                    ) {
                        SettingsRowView(iconName: "star", title: "Rate app", value: nil, action: {showRateAlert()})
                        SettingsRowView(iconName: "square.and.arrow.up", title: "Share with friends", value: nil, action: {shareApp()})
                    }
                    
                    Section(header:
                                Text("Info & legal")
                        .font(.footnoteEmphasized)
                        .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                    ) {
                        SettingsRowView(iconName: "envelope", title: "Contact us", value: nil, action: {sendEmail()})
                        SettingsRowView(iconName: "person.badge.shield.checkmark", title: "Privacy Policy", value: nil, action: {openURL("https://docs.google.com/document/d/19JZYNPZLVyIM-J5f3h8fvT7I2U0Cd4Tzo-e8fsgt3kA/edit?usp=sharing")})
                        SettingsRowView(iconName: "doc.text", title: "Usage Policy", value: nil, action: {openURL("https://docs.google.com/document/d/1TWed7Ah3BBvS-YSGgIzgGuMkIk9x3zOPwDjHesYJRSg/edit?usp=sharing")})
                    }
                    
                    HStack {
                        Spacer()
                        Text("App Version: 1.0.0")
                            .font(.footnoteRegular)
                            .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.6))
                        Spacer()
                    }
                    .padding(.bottom, 100)
                }
                .listStyle(InsetGroupedListStyle())
                .background(Color.white)
                .scrollContentBackground(.hidden)
            } else {
                List {
                    
                    Section(header:
                                Text("Purchases")
                        .font(.footnoteEmphasized)
                        .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                    ) {
                        SettingsRowView(iconName: "crown", title: "Upgrade plan", value: nil, action: {})
                        SettingsRowView(iconName: "arrow.counterclockwise", title: "Restore purchases", value: nil, action: {restorePurchases()})
                    }
                    
                    Section(header:
                                Text("Actions")
                        .font(.footnoteEmphasized)
                        .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                    ) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .frame(width: 36, alignment: .center)
                                .foregroundColor(.accentPrimary)
                            
                            Text("Notifications")
                                .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255))
                            
                            Spacer()
                            
                            Toggle("", isOn: $isNotificationEnabled)
                        }
                        .listRowBackground(Color(red: 1, green: 229/255, blue: 233/255, opacity: 0.5))
                        
                        SettingsRowView(iconName: "trash", title: "Clear cache", value: "5 MB", action: {})
                    }
                    
                    Section(header:
                                Text("Support us")
                        .font(.footnoteEmphasized)
                        .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                    ) {
                        SettingsRowView(iconName: "star", title: "Rate app", value: nil, action: {showRateAlert()})
                        SettingsRowView(iconName: "square.and.arrow.up", title: "Share with friends", value: nil, action: {shareApp()})
                    }
                    
                    Section(header:
                                Text("Info & legal")
                        .font(.footnoteEmphasized)
                        .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                    ) {
                        SettingsRowView(iconName: "envelope", title: "Contact us", value: nil, action: {sendEmail()})
                        SettingsRowView(iconName: "person.badge.shield.checkmark", title: "Privacy Policy", value: nil, action: {openURL("https://docs.google.com/document/d/19JZYNPZLVyIM-J5f3h8fvT7I2U0Cd4Tzo-e8fsgt3kA/edit?usp=sharing")})
                        SettingsRowView(iconName: "doc.text", title: "Usage Policy", value: nil, action: {openURL("https://docs.google.com/document/d/1TWed7Ah3BBvS-YSGgIzgGuMkIk9x3zOPwDjHesYJRSg/edit?usp=sharing")})
                    }
                    
                    HStack {
                        Spacer()
                        Text("App Version: 1.0.0")
                            .font(.footnoteRegular)
                            .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.6))
                        Spacer()
                    }
                    .padding(.bottom, 100)
                }
                .listStyle(InsetGroupedListStyle())
            }
            
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(Text("Settings"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack(spacing: 10) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.accentPrimary)
                        Text("Back")
                            .font(.bodyRegular)
                            .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255))
                    }
                })
        )
    }
    
    private func showRateAlert() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        } else {
            openAppStore()
        }
    }
    
    private func openAppStore() {
        if let url = URL(string: "https://apps.apple.com/us/app/id\(6742832953)?action=write-review") {
            UIApplication.shared.open(url)
        }
    }
    
    private func sendEmail() {
        let email = "blainespartaco@gmail.com"
        let mailtoString = "mailto:\(email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: mailtoString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareApp() {
        let appURL = URL(string: "https://apps.apple.com/us/app/pinterest-downloader/id6743121479")!
        let activityVC = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
    }
    
    private func restorePurchases() {
        Apphud.restorePurchases { subscriptions, nonRenewingPurchases, error in
            if let subscriptions = subscriptions, !subscriptions.isEmpty {
                
            } else if let nonRenewingPurchases = nonRenewingPurchases, !nonRenewingPurchases.isEmpty {
                
            } else {
                print("No active subscriptions found or error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    
}

struct SettingsRowView: View {
    let iconName: String
    let title: String
    let value: String?
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .frame(width: 36, alignment: .center)
                    .foregroundColor(.accentPrimary)
                
                Text(title)
                    .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255))
                
                Spacer()
                
                if let value = value {
                    Text(value)
                        .foregroundColor(.gray)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.4))
            }
            
        }
        .listRowBackground(Color(red: 1, green: 229/255, blue: 233/255, opacity: 0.5))
        
    }
}
