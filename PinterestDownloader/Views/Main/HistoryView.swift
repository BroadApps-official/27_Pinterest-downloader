import SwiftUI
import AVKit
import Photos

struct HistoryView: View {
    
    @FetchRequest(sortDescriptors: []) var pins: FetchedResults<Pin>
    @Environment(\.managedObjectContext) var moc
    
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                if pins.isEmpty {
                    
                    Image(systemName: "circle.slash")
                        .font(.system(size: 80))
                        .foregroundColor(.accentPrimary)
                    
                    Text("No recent Media")
                        .font(.title3Emphasized)
                        .foregroundColor(Color(red: 20/255, green: 15/255, blue: 24/255))
                        .padding(.bottom, 2)
                    
                    Text("Enter the link on the home screen at first")
                        .font(.footnoteRegular)
                        .foregroundColor(Color(red: 20/255, green: 15/255, blue: 24/255))
                    
                } else {
                    
                    ScrollView(showsIndicators: false) {
                        HStack(alignment: .top) {
                            LazyVStack(spacing: 10) {
                                ForEach(pins.indices.filter { $0 % 2 == 0 }, id: \.self) { index in
                                    HistoryRow(pin: pins[index])
                                }

                            }
                            
                            LazyVStack(spacing: 10) {
                                ForEach(pins.indices.filter { $0 % 2 != 0 }, id: \.self) { index in
                                    HistoryRow(pin: pins[index])
                                }

                            }
                        }
                    }
                    .padding()
    
                }
           }
            .navigationBarItems(
                leading:
                    Text("History")
                        .font(.title1Emphasized),
                trailing:
                    HStack {
                        ButtonFactory.createButton(type: .pro) { isPresented = true }
                        
                        
                        Button {
                            
                            for item in pins {
                                moc.delete(item)
                            }
                            
                            do {
                                try moc.save()
                            } catch {
                                print("Ошибка при удалении истории: \(error.localizedDescription)")
                            }
                            
                        } label: {
                            Image(systemName: "trash")
                                .frame(width: 32, height: 32)
                                .font(.system(size: 17))
                                .foregroundColor(Color(red: 4/255, green: 16/255, blue: 25/255))
                        }
                        
                    }
            )
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $isPresented) {
                PayWall()
            }
        }
    }
}



struct HistoryRow: View {
    let pin: Pin
    @State private var image: UIImage? = nil
    @State private var player: AVPlayer? = nil
    @Environment(\.managedObjectContext) private var moc

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let player = player {
                VideoPlayer(player: player)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        player.play()
                    }
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
            }

            // Оверлей с меню и размером файла
            VStack {
                HStack {
                    Text(String(format: "%.2f MB", pin.sizeMB))
                        .font(.caption1Regular)
                        .foregroundColor(.white)
                        .frame(height: 32)
                        .padding(.horizontal, 5)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(8)

                    Spacer()

                    Menu {
                        Section {
                            if let image = image {
                                Button {
                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                } label: {
                                    Label("Download", systemImage: "arrow.down.to.line")
                                }
                            } else {
                                Button {
                                    saveVideoToGallery(urlString: pin.url ?? "")
                                } label: {
                                    Label("Download", systemImage: "arrow.down.to.line")
                                }
                            }

                            Button(action: { }) {
                                Label("Albums", systemImage: "folder")
                            }

                            Button {
                                if let image = image {
                                    shareImage(image: image)
                                } else {
                                    shareVideo(urlString: pin.url ?? "")
                                }
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }

                        Section {
                            if #available(iOS 15.0, *) {
                                Button(role: .destructive) {
                                    deletePin()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            } else {
                                Button(action: {
                                    deletePin()
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
        }
        .onAppear {
            loadMedia()
        }
    }

    private func loadMedia() {
        guard let urlString = pin.url, let url = URL(string: urlString) else { return }

        if urlString.hasSuffix(".mp4") || urlString.hasSuffix(".mov") {
            player = AVPlayer(url: url)
        } else {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let loadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = loadedImage
                    }
                }
            }.resume()
        }
    }

    private func shareImage(image: UIImage) {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentActivity(activityController)
    }
    
    private func shareVideo(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        presentActivity(activityController)
    }

    private func presentActivity(_ controller: UIActivityViewController) {
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(controller, animated: true, completion: nil)
        }
    }

    private func saveVideoToGallery(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.downloadTask(with: url) { localURL, _, error in
            guard let localURL = localURL, error == nil else { return }
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: localURL)
            } completionHandler: { success, error in
                if !success {
                    print("Ошибка сохранения видео: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                }
            }
        }.resume()
    }

    private func deletePin() {
        moc.delete(pin)
        do {
            try moc.save()
        } catch {
            print("Ошибка при удалении: \(error.localizedDescription)")
        }
    }
}
