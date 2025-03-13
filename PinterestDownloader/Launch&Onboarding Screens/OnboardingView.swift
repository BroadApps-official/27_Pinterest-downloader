import SwiftUI
import UserNotifications

struct itemModel {
    let title: String
    let subtitle: String
    let image: String
}

struct OnboardingView: View {
    
    @State private var currentStep: Int = 0
    @Binding var showTabView: Bool
    
    private let vm: [itemModel] = [
        itemModel(
            title: "Save  Pinterest content",
            subtitle: "Just tab the button",
            image: "onboardingImage01"),
        itemModel(
            title: "All videos in full screen",
            subtitle: "Download it and collect it",
            image: "onboardingImage02"),
        itemModel(
            title: "Organize with Albums",
            subtitle: "Organize with Albums",
            image: "onboardingImage03"),
        itemModel(
            title: "Share your feedback",
            subtitle: "Rate our app in the AppStore",
            image: "onboardingImage04"),
        itemModel(
            title: "",
            subtitle: "",
            image: "onboardingImage05")
    ]
    
    var body: some View {
        ZStack {
            
            TabView(selection: $currentStep) {
                ForEach(0..<vm.count, id: \.self) { index in
                    ZStack {
                        
                        Image(vm[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .edgesIgnoringSafeArea(.all)
                        
 
                        VStack {
                            Spacer()
                            
                            Image("onboardingContentBG")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                        }
                        .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 10) {
                            Spacer()
                                .frame(height: 10)
                            
                            Text(vm[index].title)
                                .font(.largeTitleEmphasized)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                            
                            Text(vm[index].subtitle)
                                .font(.bodyRegular)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                                
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentStep)
            
            VStack {
                Spacer()
                
                ButtonFactory.createButton(
                    title: currentStep == vm.count - 1 ? "Get Started" : "Continue",
                    size: .medium,
                    type: .regular
                ) {
                    if self.currentStep < self.vm.count - 1 {
                                            self.currentStep += 1
                                        } else {
                                            requestNotificationPermission()
                                        }
                }
                
                HStack {
                    ForEach(0 ..< vm.count, id: \.self) { index in
                        if index == currentStep {
                            Rectangle()
                                .frame(width: 20, height: 10)
                                .cornerRadius(10)
                                .foregroundColor(Color.black)
                        }else {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(Color.black.opacity(0.3))
                        }
                    }
                }
                .frame(height: 70)
            }
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func requestNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notification permission granted")
                } else if let error = error {
                    print("Notification permission request failed: \(error.localizedDescription)")
                } else {
                    print("Notification permission denied")
                }
                
                DispatchQueue.main.async {
                    showTabView = true
                }
            }
        }
    
}

#Preview {
    OnboardingView(showTabView: Binding.constant(true))
}
