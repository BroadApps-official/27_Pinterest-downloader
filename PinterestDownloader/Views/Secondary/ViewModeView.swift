import SwiftUI
import AVKit
import Photos

struct ViewModeView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var pins: FetchedResults<Pin>
    
    @State private var isPresented = false
    
    let imageURL: String
    let image: UIImage?
    let imageSizeMB: Double?
    let videoData: Data?
    let videoSizeMB: Double?
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var isLoading = true
    @State private var videoSize: CGSize = .zero
    
    var body: some View {
        ZStack {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                } else {
                    ZStack {
                        if let player = player {
                            VideoPlayer(player: player)
                                .frame(height: videoSize.height)
                                .background(Color.black.opacity(0.5))
                        }
                        
                        Button(action: togglePlayPause) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 76, height: 76)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .accentPrimary))
                                .scaleEffect(2)
                        }
                    }
                    .onAppear {
                        setupPlayer()
                        calculateVideoSize()
                    }
                }
                
                Spacer()
            }
            
            VStack {
                HStack {
                    if let size = imageSizeMB {
                        Text(String(format: "%.2f MB", size))
                            .font(.caption1Regular)
                            .foregroundColor(.white)
                            .frame(height: 32)
                            .padding(.horizontal, 5)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(8)
                    } else if let size = videoSizeMB {
                        Text(String(format: "%.2f MB", size))
                            .font(.caption1Regular)
                            .foregroundColor(.white)
                            .frame(height: 32)
                            .padding(.horizontal, 5)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(8)
                    }
                    Spacer()
                    
                    Menu {
                        Section {
                            Button(action: {
                                if let validImage = image {
                                    UIImageWriteToSavedPhotosAlbum(validImage, nil, nil, nil)
                                } else {
                                    saveVideoToGallery(urlString: imageURL)
                                }
                            }) {
                                Label("Download", systemImage: "arrow.down.to.line")
                            }
                            Button(action: {
                                // Альбомы
                            }) {
                                Label("Albums", systemImage: "folder")
                            }
                            Button(action: {
                                if let image = image {
                                    shareImage(image: image)
                                } else if let videoData = videoData {
                                    shareVideo(videoData: videoData)
                                }
                            }) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }
                        
                        Section {
                            if #available(iOS 15.0, *) {
                                Button(role: .destructive) {
                                    if let pinToDelete = pins.first(where: { $0.url == imageURL }) {
                                        moc.delete(pinToDelete)
                                        
                                        do {
                                            try moc.save()
                                        } catch {
                                            print("Ошибка при удалении: \(error.localizedDescription)")
                                        }
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            } else {
                                Button(action: {
                                    if let pinToDelete = pins.first(where: { $0.url == imageURL }) {
                                        moc.delete(pinToDelete)
                                        
                                        do {
                                            try moc.save()
                                        } catch {
                                            print("Ошибка при удалении: \(error.localizedDescription)")
                                        }
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }

                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.accentPrimary)
                            .cornerRadius(8)
                    }
                }
                .padding()
                Spacer()
            }
            .padding(.top)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(Text("View mode"))
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
                }),
            trailing:
                ButtonFactory.createButton(type: .pro, action: {
                    isPresented = true 
                })
        )
        .sheet(isPresented: $isPresented) {
            PayWall()
        }
    }
    
    func shareImage(image: UIImage?) {
        guard let image = image else { return }
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        if let controller = UIApplication.shared.windows.first?.rootViewController {
            controller.present(activityController, animated: true, completion: nil)
        }
    }
    
    func shareVideo(videoData: Data) {
        // Создаём временный файл для видео
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mp4")
        
        // Пишем данные видео во временный файл
        try? videoData.write(to: tempURL)
        
        // Подготовка UIActivityViewController для шаринга
        let activityController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        
        if let controller = UIApplication.shared.windows.first?.rootViewController {
            controller.present(activityController, animated: true, completion: nil)
        }
    }
    
    private func setupPlayer() {
        // Проверяем, что строка URL корректна
        guard let url = URL(string: imageURL) else {
            print("Invalid URL string: \(imageURL)")
            return
        }
        
        // Создаем AVPlayer с полученным URL
        let newPlayer = AVPlayer(url: url)
        newPlayer.isMuted = true
        newPlayer.actionAtItemEnd = .none
        
        // Уведомление об окончании воспроизведения видео
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: newPlayer.currentItem,
                                               queue: .main) { _ in
            newPlayer.seek(to: .zero)
            newPlayer.play()
        }
        
        player = newPlayer
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            player?.play()
            isPlaying = true
        }
    }
    
    private func calculateVideoSize() {
        // Мы используем AVAsset для получения размера видео
        guard let url = URL(string: imageURL) else {
            return
        }
        
        let asset = AVAsset(url: url)
        
        DispatchQueue.global().async {
            if let track = asset.tracks(withMediaType: .video).first {
                let size = track.naturalSize.applying(track.preferredTransform)
                let screenWidth = UIScreen.main.bounds.width
                let aspectRatio = size.height / size.width
                let adjustedHeight = screenWidth * aspectRatio
                
                DispatchQueue.main.async {
                    self.videoSize = CGSize(width: screenWidth, height: abs(adjustedHeight))
                }
            }
        }
    }
    
    private func togglePlayPause() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        
        isPlaying.toggle()
    }
    
    func saveVideoToGallery(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("❌ Invalid video URL")
            return
        }
        
        guard url.isFileURL else {
            print("❌ Remote URLs require download first")
            downloadAndSaveToGallery(remoteURL: url)
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("✅ Video saved to gallery")
                } else {
                    print("❌ Save error: \(error?.localizedDescription ?? "Unknown error")")
                    self.requestPhotoLibraryAccess()
                }
            }
        }
    }
    
    private func downloadAndSaveToGallery(remoteURL: URL) {
        let task = URLSession.shared.downloadTask(with: remoteURL) { tempURL, _, error in
            guard let tempURL = tempURL, error == nil else {
                print("❌ Download failed: \(error?.localizedDescription ?? "")")
                return
            }
            
            let fileManager = FileManager.default
            let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let permanentURL = docsURL.appendingPathComponent(remoteURL.lastPathComponent)
            
            do {
                if fileManager.fileExists(atPath: permanentURL.path) {
                    try fileManager.removeItem(at: permanentURL)
                }
                try fileManager.copyItem(at: tempURL, to: permanentURL)
                
                self.saveVideoToGallery(urlString: permanentURL.absoluteString)
            } catch {
                print("❌ File move error: \(error)")
            }
        }
        task.resume()
    }
    
    private func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .denied {
                DispatchQueue.main.async {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
            }
        }
    }
}
