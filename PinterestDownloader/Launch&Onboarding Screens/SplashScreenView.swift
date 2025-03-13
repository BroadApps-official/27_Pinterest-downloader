import SwiftUI

struct SplashScreenView: View {
    
    @State private var isLoading = false
    @State private var isFirstLaunch: Bool = UserDefaults.standard.bool(forKey: "isFirstLaunch") == false
    @State private var showTabView = false
    
    var body: some View {
        
        if isLoading {
            if isFirstLaunch && !showTabView {
                OnboardingView(showTabView: $showTabView)
                    .onDisappear {
                        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                    }
            } else {
            CustomTabView()
            }
        } else {
            
            ZStack {
                Image("LaunchSplashBG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                
                Image("AppIcon")
                    .resizable()
                    .frame(width: 160, height: 160, alignment: .center)
                    .cornerRadius(40)
                
                VStack {
                    Spacer()
                    
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.4)
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            .onAppear() { startFakeLoading() }
            .edgesIgnoringSafeArea(.all)
            
        }
    }
    
    func startFakeLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.isLoading = true
            }
        }
    }
    
}


