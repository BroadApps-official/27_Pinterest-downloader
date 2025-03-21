import SwiftUI

struct AlbumsView: View {
    
    @FetchRequest(sortDescriptors: []) var folders: FetchedResults<Folder>
    @Environment(\.managedObjectContext) var moc
    
    var historyItems = ""
    @State private var isPresented = false
    @State private var inputText = ""
    @State private var isPresentedPaywall = false
    
    var body: some View {
        if #available(iOS 15.0, *) {
            NavigationView {
                VStack {
                    
                    if folders.isEmpty {
                        
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
                        
                        ButtonFactory.createButton(title: "+ New folder", size: .medium, type: .regular) {
                            isPresented = true
                        }
                        .padding(.top)
                        
                        
                        
                    } else {
                        //List {
                        //    ForEach(folders, id: \.self) { folder in
                        //        HStack {
                        //            ZStack {
                        //                RoundedRectangle(cornerRadius: 8)
                        //                    .stroke(Color.yellow, lineWidth: 2) // Жёлтая обводка
                        //                    .frame(width: 36, height: 36)
                        //
                        //                Image(systemName: "folder.fill")
                        //                    .foregroundColor(.yellow)
                        //            }
                        //
                        //            Text(folder.name ?? "Unnamed Folder") // Имя папки
                        //                .font(.body)
                        //                .foregroundColor(.primary)
                        //
                        //            Spacer()
                        //
                        //            Image(systemName: "chevron.right") // Стрелка вправо
                        //                .foregroundColor(.gray)
                        //        }
                        //        .padding(.vertical, 8)
                        //        .swipeActions {
                        //            Button(role: .destructive) {
                        //                moc.delete(folder)
                        //                do {
                        //                    try moc.save()
                        //                } catch {
                        //                    print("Ошибка при удалении: \(error.localizedDescription)")
                        //                }
                        //            } label: {
                        //                Label("Delete", systemImage: "trash")
                        //            }
                        //        }
                        //    }
                        //}
                        
                        
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
                                isPresented = true
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
                .alert("New folder", isPresented: $isPresented, presenting: inputText) { _ in
                    TextField("Placeholder", text: $inputText)
                    Button("Save") {
                        let newFolder = Folder(context: moc)
                        newFolder.id = UUID()
                        newFolder.name = inputText
                        
                        try? moc.save()
                        
                    }
                    .alertButtonTint(color: .red)
                    Button("Cancel", role: .cancel) { }
                } message: { _ in
                    Text("Enter a name for your folder for the new video collection")
                }
                
            }
        }
    }
}

