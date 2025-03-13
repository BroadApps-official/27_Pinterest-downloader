import SwiftUI

enum ButtonType {
    case regular, pro
}

struct CustomButton: View {
    var title: String?
    var action: () -> Void
    var size: ButtonSize?
    var type: ButtonType
    
    @State private var isPressed = false
    
    enum ButtonSize {
        case medium, full
    }
    
    var body: some View {
        Button(action: action) {
            if type == .pro {
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 172/255, green: 0, blue: 26/255))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 236/255, green: 64/255, blue: 90/255))
                            .frame(width: 80, height: 20)
                            .offset(x: 0, y: -12)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentPrimary)
                            .frame(width: 80, height: 24)
                            .offset(x: 0, y: -1)
                    )
                    .overlay(
                        HStack(spacing: 2) {
                            Spacer()
                            
                            Image(systemName: "crown.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .padding(.bottom, 2)
                            
                            Text("PRO")
                                .font(.subheadlineEmphasized)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: 80, height: 32)
                
                
            } else {
                // Стиль обычной кнопки
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.accentPrimary)
                    .overlay(
                        Text(title ?? "") // Здесь можем использовать title
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 3)
                            .frame(width: 67, height: 67)
                            .offset(x: 33, y: -33),
                        alignment: .topTrailing
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 3)
                            .frame(width: 67, height: 67)
                            .offset(x: -33, y: 33),
                        alignment: .bottomLeading
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 3)
                            .frame(width: 67, height: 67)
                            .offset(x: -43, y: 43),
                        alignment: .bottomLeading
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                    .frame(width: size == .medium ? 190 : nil, height: 52)
                    .frame(maxWidth: size == .full ? .infinity : nil)
                    .padding(.horizontal, size == .full ? 16 : 0) 
            }
        }
    }
}

struct ButtonFactory {
    static func createButton(title: String? = nil, size: CustomButton.ButtonSize? = nil, type: ButtonType, action: @escaping () -> Void) -> some View {
        return CustomButton(title: title, action: action, size: size, type: type)
    }
}
