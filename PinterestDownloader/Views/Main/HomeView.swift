import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var searchText = ""
    @State private var urlString: String = ""
    @State private var navigateToResult = false
    
    @State private var validationAlertTitle = ""
    @State private var validationAlertMessage = ""
    @Binding var isLoading: Bool
    
    @State private var image: UIImage? = nil
    @State private var imageSizeMB: Double? = nil
    
    @State private var videoData: Data? = nil
    @State private var videoSizeMB: Double? = nil
    
    @State private var isPresented = false
    
    enum ActiveAlert {
        case none
        case validation
        case emptyURL
    }
    
    @State private var activeAlert: ActiveAlert = .none
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 90)
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Enter link")
                            .font(.largeTitleEmphasized)
                            .foregroundColor(Color(red: 20/255, green: 15/255, blue: 24/255))
                        
                        Text("Copy the link, paste it, and click the button")
                            .font(.footnoteRegular)
                            .foregroundColor(Color(red: 20/255, green: 15/255, blue: 24/255, opacity: 0.8))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                    .frame(height: 70)
                
                SearchView(searchText: $searchText)
                
                ButtonFactory.createButton(title: "Find", size: .medium, type: .regular) {
                    if searchText.isEmpty {
                        activeAlert = .emptyURL
                    } else {
                        isLoading = true
                        sendPostRequest()
                    }
                }
                .opacity(searchText.isEmpty ? 0.5 : 1)
                
                NavigationLink("", destination: ViewModeView(imageURL: urlString, image: image, imageSizeMB: imageSizeMB, videoData: videoData, videoSizeMB: videoSizeMB), isActive: $navigateToResult)
                    .hidden()
                
                Spacer()
            }
            .navigationBarItems(
                leading:
                    Text("Home")
                    .font(.title1Emphasized),
                trailing:
                    HStack {
                        ButtonFactory.createButton(type: .pro) { isPresented = true }
                        
                        NavigationLink(destination: {
                            SettingsView()
                        }, label: {
                            Image(systemName: "gearshape")
                                .frame(width: 32, height: 32)
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                        })
                    }
            )
            .alert(isPresented: .constant(activeAlert != .none)) {
                switch activeAlert {
                case .validation:
                    return Alert(
                        title: Text(validationAlertTitle),
                        message: Text(validationAlertMessage),
                        dismissButton: .default(Text("Close"), action: {
                            activeAlert = .none
                        })
                    )
                case .emptyURL:
                    return Alert(
                        title: Text("Please enter URL here"),
                        dismissButton: .default(Text("OK"), action: {
                            activeAlert = .none
                        })
                    )
                case .none:
                    return Alert(title: Text(""))
                }
            }
            .alertButtonTint(color: .accentPrimary)
            .sheet(isPresented: $isPresented) {
                PayWall()
            }

        }
    }
    
    private func validateAndNavigate() {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            isLoading = false
            validationAlertTitle = "Wrong link pasted"
            validationAlertMessage = "This link does not fit, enter another one or read our instructions"
            activeAlert = .validation
            return
        }
        
        isLoading = true
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                let sizeInMB = Double(data.count) / (1024 * 1024)
                
                DispatchQueue.main.async {
                    if url.absoluteString.hasSuffix(".mp4") || url.absoluteString.hasSuffix(".mov") {
                        self.videoSizeMB = sizeInMB
                        self.videoData = data
                    } else if let loadedImage = UIImage(data: data) {
                        self.image = loadedImage
                        self.imageSizeMB = sizeInMB
                    }
                    
                    let newPin = Pin(context: moc)
                    newPin.id = UUID()
                    newPin.url = urlString
                    newPin.sizeMB = sizeInMB
                    newPin.time = Date()
                    
                    try? moc.save()
                    
                    navigateToResult = true
                    isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    isLoading = false
                    validationAlertTitle = "Loading error"
                    validationAlertMessage = "Paste a different link or try again later"
                    activeAlert = .validation
                }
            }
        }

    }
    
    func sendPostRequest() {
            guard !searchText.isEmpty else { return }
            isLoading = true
            
            NetworkManager.shared.postTask(urls: [searchText]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("Task ID: \(response.id)")
                        fetchTaskDetails(taskID: response.id)
                        
                    case .failure(let error):
                        isLoading = false
                        print("Ошибка: \(error.localizedDescription)")
                    }
                }
            }
        }
    
    func fetchTaskDetails(taskID: String, attempt: Int = 1) {
        guard attempt <= 10 else { // Увеличиваем до 10 попыток
            print("Превышено максимальное количество попыток")
            isLoading = false
            validationAlertTitle = "Wrong link pasted"
            validationAlertMessage = "This link does not fit, enter another one or read our instructions"
            activeAlert = .validation
            return
        }
        
        print("Attempt \(attempt)...")
        
        NetworkManager.shared.getTask(taskID: taskID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if !response.items.isEmpty {
                        print("Успешно получены данные: \(response.items)")
                        urlString = response.items[0].url
                        validateAndNavigate()
                        self.isLoading = false
                    
                        // Показать данные в UI
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.fetchTaskDetails(taskID: taskID, attempt: attempt + 1)
                        }
                    }
                    
                case .failure(let error):
                    print("Ошибка: \(error.localizedDescription)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.fetchTaskDetails(taskID: taskID, attempt: attempt + 1)
                    }
                }
            }
        }
    }
}

struct SearchView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                    .frame(width: 32, height: 32)
                    .padding(.leading, 10)
                
                TextField("Enter or Paste URL", text: $searchText)
                    .font(.bodyRegular)
                
                if searchText.isEmpty {
                    Button {
                        if let pasteboardText = UIPasteboard.general.string {
                            searchText = pasteboardText
                        }
                    } label: {
                        HStack(spacing: 0) {
                            Spacer()
                            Text("Paste")
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                            
                            Image(systemName: "doc.on.clipboard")
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                                .frame(width: 24, height: 24)
                            Spacer()
                        }
                        .frame(width: 74, height: 32)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.trailing, 10)
                    }
                } else {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                            .frame(width: 32, height: 32)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.trailing, 10)
                    }
                    
                }
            }
            .frame(height: 52)
            .background(Color(red: 54/255, green: 84/255, blue: 106/255, opacity: 0.04))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 4/255, green: 16/255, blue: 25/255, opacity: 0.24), lineWidth: 0.33)
            )
            .padding()
        }
    }
}
