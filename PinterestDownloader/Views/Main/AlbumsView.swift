import SwiftUI

struct AlbumsView: View {
    
    var historyItems = ""
    @State private var isPresented = false
        @State private var inputText = ""
    @State private var isPresentedPaywall = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                if historyItems.isEmpty {
                    
                    Image(systemName: "folder")
                        .font(.largeTitleRegular)
                        .foregroundColor(Color(red: 20/255, green: 15/255, blue: 24/255, opacity: 0.4))
                        .padding(.bottom, 10)
                    
                    Text("No Folders")
                        .font(.title3Emphasized)
                        .foregroundColor(Color(red: 20/255, green: 15/255, blue: 24/255))
                        .padding(.bottom, 2)
                    
                    Text("create a folders in an album")
                        .font(.footnoteRegular)
                        .foregroundColor(.black)
                    
                    if #available(iOS 15.0, *) {
                        ButtonFactory.createButton(title: "+ New folder", size: .medium, type: .regular) {
                            isPresented = true
                        }
                        .padding(.top)
                        .alert("New folder", isPresented: $isPresented) {
                            TextField("Placeholder", text: $inputText)
                            Button("OK") { print("User entered: \(inputText)") }
                            Button("Cancel", role: .cancel) { }
                        }
                    }
                    
                } else {

    
                }
           }
            .navigationBarItems(
                leading:
                    Text("Albums")
                        .font(.title1Emphasized),
                trailing:
                    HStack {
                        ButtonFactory.createButton(type: .pro) { isPresentedPaywall = true }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "plus.rectangle.on.folder")
                                .frame(width: 32, height: 32)
                                .font(.system(size: 17))
                                .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255))
                        }
                        
                    }
            )
            .sheet(isPresented: $isPresentedPaywall) {
                PayWall()
            }
            
        }
    }
}

#Preview {
    AlbumsView()
}
