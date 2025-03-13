import SwiftUI

struct CustomTabView: View {
    
    @State private var selectedIndex = 0
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            
            ZStack {
                switch selectedIndex {
                case 0:
                    HomeView(isLoading: $isLoading)
                case 1:
                    AlbumsView()
                case 2:
                    HistoryView()
                default:
                    Text("First tab")
                }
            }
            
            VStack {
                Spacer()
                    
                HStack {
                    Spacer()
                        .frame(width: 50)
                    TabBarItem(iconName: "house", title: "Home", isSelected: selectedIndex == 0, needSpacer: true)
                        .onTapGesture {
                            selectedIndex = 0
                        }
                    Spacer()
                    TabBarItem(iconName: "folder", title: "Albums", isSelected: selectedIndex == 1, needSpacer: false)
                        .onTapGesture {
                            selectedIndex = 1
                        }
                    Spacer()
                    TabBarItem(iconName: "clock", title: "History", isSelected: selectedIndex == 2, needSpacer: true)
                        .onTapGesture {
                            selectedIndex = 2
                        }
                    Spacer()
                        .frame(width: 50)
                }
                .frame(height: 80)
                .background(BlurView(style: .systemUltraThinMaterial))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white),
                    alignment: .top
                )
            }
            
            if isLoading {
                
                ZStack {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentPrimary))
                        .frame(width: 64, height: 64)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .frame(width: 64, height: 64)
                        )
                }
                
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarItem: View {
    let iconName: String
    let title: String
    let isSelected: Bool
    let needSpacer: Bool
    
    var body: some View {
        VStack(spacing: -4) {
            Image(systemName: iconName)
                .font(.system(size: 17))
                .frame(width: 32, height: 32, alignment: .center)
                .foregroundColor(isSelected ? Color.accentPrimary : Color.black.opacity(0.4))
            if needSpacer {
                Spacer()
                    .frame(height: 8)
            }
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(isSelected ? Color.accentPrimary : Color.black.opacity(0.4))
                .padding(.bottom, 20)
            if !needSpacer {
                Spacer()
            }
        }
        .frame(width: 40, height: 60)
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return blurView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

