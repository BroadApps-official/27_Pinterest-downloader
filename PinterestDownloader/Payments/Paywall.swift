import SwiftUI

struct PayWall: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var subscriptionManager = SubscriptionManager.shared
    @State private var selectedPlan: SubscriptionPlan? = .weekly
    @State private var showCloseButton = false
    @State private var isPurchasing = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    
                    ZStack {
                        
                        VStack {
                            Image("paywallImage")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .edgesIgnoringSafeArea(.all)
                            
                            Spacer()
                        }
                        
                        VStack {
                            Spacer()
                            
                            Image("backgroundShadow")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .edgesIgnoringSafeArea(.all)
                        }
                        
                        VStack() {
                            
                            Spacer()
                            
                            VStack {
                                Text("Unlock all!")
                                    .font(.title1Emphasized)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentPrimary)
                                        
                                        Text("Unlimited saving")
                                            .font(.subheadlineRegular)
                                            .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                                    }
                                    .frame(height: 32)
                                    
                                    HStack {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentPrimary)
                                        
                                        Text("Unlimited folders")
                                            .font(.subheadlineRegular)
                                            .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                                    }
                                    .frame(height: 32)
                                    
                                    HStack {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentPrimary)
                                        
                                        Text("Unlimited download")
                                            .font(.subheadlineRegular)
                                            .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.8))
                                    }
                                    .frame(height: 32)
                                }
                            }
                            .frame(height: 154)
                            
                            Spacer()
                                .frame(height: 20)
                            
                            VStack(spacing: 12) {
                                ForEach(SubscriptionPlan.allCases, id: \ .self) { plan in
                                    SubscriptionButton(plan: plan, selectedPlan: $selectedPlan)
                                }
                            }
                            
                            Spacer()
                                .frame(height: 16)
                        }
                    }
                    
                    
                    VStack(spacing: 0) {
                        
                        HStack(alignment: .top) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.caption1Regular)
                                .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.4))
                            
                            Text("Cancel Anytime")
                                .font(.caption1Regular)
                                .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.4))
                        }
                        .frame(height: 32)
                        
                        ButtonFactory.createButton(title: "Continue", size: .full, type: .regular) {
                            purchaseSubscription()
                        }
                        .disabled(isPurchasing)
                       
                        
                        HStack {
                            
                            Button {
                                UIApplication.shared.open(URL(string: "https://docs.google.com/document/d/19JZYNPZLVyIM-J5f3h8fvT7I2U0Cd4Tzo-e8fsgt3kA/edit?usp=sharing")!)
                            } label: {
                                Text("Privacy Policy")
                                    .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.4))
                                    .font(.caption2Regular)
                            }
                            
                            Spacer()
                            
                            Button {
                                restorePurchases()
                            } label: {
                                Text("Restore Purchases")
                                    .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.6))
                                    .font(.caption1Regular)
                            }
                            
                            Spacer()
                            
                            Button {
                                UIApplication.shared.open(URL(string: "https://docs.google.com/document/d/1TWed7Ah3BBvS-YSGgIzgGuMkIk9x3zOPwDjHesYJRSg/edit?usp=sharing")!)
                            } label: {
                                Text("Terms of Use")
                                    .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.4))                                    .font(.caption2Regular)
                            }
                            
                        }
                        .frame(height: 44)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarItems(
                trailing:
                    closeButton
                        .opacity(showCloseButton ? 1 : 0)
                        .animation(.easeIn(duration: 1), value: showCloseButton)
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showCloseButton = true
                }
            }
        }
    }
    
    private var closeButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(Color.gray)
        }
    }
    
    private func purchaseSubscription() {
      guard let plan = selectedPlan else { return }
      isPurchasing = true
      guard let product = subscriptionManager.productsApphud.first(where: { $0.skProduct?.productIdentifier == plan.productId }) else {
        isPurchasing = false
        return
      }
      subscriptionManager.startPurchase(product: product) { success in
        isPurchasing = false
          if success { presentationMode.wrappedValue.dismiss() }
      }
    }
    
    private func restorePurchases() {
      subscriptionManager.restorePurchases { success in
        if success { presentationMode.wrappedValue.dismiss() }
      }
    }
    
}

struct SubscriptionButton: View {

    let plan: SubscriptionPlan
    @Binding var selectedPlan: SubscriptionPlan?
    @ObservedObject var subscriptionManager = SubscriptionManager.shared
    
    var body: some View {
        Button(action: {selectedPlan = plan}) {
            HStack(spacing: 0) {
                Image(systemName: selectedPlan == plan ? "button.programmable" : "circle")
                    .foregroundColor(selectedPlan == plan ? .accentPrimary : Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.28))
                    .frame(width: 32, height: 32)
                    .padding(.horizontal, 8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(plan.title)")
                        .font(.bodyRegular)
                        .foregroundColor(.black)
                    
                    if !plan.subtitle.isEmpty {
                        Text(plan.subtitle)
                            .font(.caption1Regular)
                            .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.6))
                    }
                }
                
                Spacer()
                
                if plan.productId == "yearly_59.99_nottrial" {
                    Text("SAVE 60%")
                        .foregroundColor(.white)
                        .font(.caption1Emphasized)
                        .padding(4)
                        .background(Color.accentPrimary)
                        .cornerRadius(4)
                }
                
                
                Text(subscriptionManager.getProductPrice(for: plan.productId))
                    .font(.bodyEmphasized)
                    .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255))
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color(red: 54/255, green: 84/255, blue: 106/255, opacity: 0.04))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedPlan == plan ? Color.accentPrimary : Color.clear, lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }
}

enum SubscriptionPlan: String, CaseIterable {
    case yearly, weekly
    
    var title: String {
        switch self {
        case .yearly: return "Yearly"
        case .weekly: return "Weekly"
        }
    }
    
    var subtitle: String {
        switch self {
        case .yearly: return "$0.77 per week"
        case .weekly: return ""
        }
    }

    var productId: String {
        switch self {
        case .yearly: return "yearly_59.99_nottrial"
        case .weekly: return "week_6.99_nottrial"
        }
    }
}
