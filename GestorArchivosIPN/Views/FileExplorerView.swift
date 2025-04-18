

//
//  Untitled.swift
//  GestorArchivosIPN
//
//  Created by Giovanni Javier Longoria Bunoust on 17/04/25.
//

import SwiftUI

struct FileExplorerView: View {
    @StateObject private var viewModel = FileManagerViewModel()
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var showingCreateFolderAlert = false
    @State private var newFolderName = ""
    @State private var showingSortOptions = false
    @State private var showingSettingsSheet = false
    @State private var selectedFile: FileModel? = nil
    @State private var showingFileActionSheet = false
    @State private var showingRenameAlert = false
    @State private var newFileName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Barra de búsqueda
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Buscar", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: viewModel.searchText) { _ in
                            viewModel.loadFiles()
                        }
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                            viewModel.loadFiles()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Información de la ruta actual
                HStack {
                    Button(action: viewModel.navigateUp) {
                        Image(systemName: "arrow.up")
                            .foregroundColor(themeManager.currentTheme.primaryColor)
                    }
                    .disabled(viewModel.currentPath.pathComponents.count <= 1)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.currentPath.pathComponents, id: \.self) { component in
                                if component != "/" {
                                    Text(component)
                                        .foregroundColor(themeManager.currentTheme.textColor)
                                } else {
                                    Text("Raíz")
                                        .foregroundColor(themeManager.currentTheme.textColor)
                                }
                                
                                if component != viewModel.currentPath.lastPathComponent {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Lista de archivos
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                } else if viewModel.files.isEmpty {
                    VStack {
                        Image(systemName: "folder.badge.questionmark")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text(viewModel.searchText.isEmpty ? "Carpeta vacía" : "No se encontraron resultados")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.files) { file in
                            FileRowView(file: file)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if file.fileType == .folder {
                                        viewModel.navigateToFolder(at: file.path)
                                    } else {
                                        selectedFile = file
                                        showingFileActionSheet = true
                                    }
                                }
                                .contextMenu {
                                    fileContextMenu(for: file)
                                }
                        }
                        .onDelete(perform: viewModel.deleteFile)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                
                // Barra inferior con acciones
                HStack {
                    Button(action: {
                        showingCreateFolderAlert = true
                    }) {
                        VStack {
                            Image(systemName: "folder.badge.plus")
                                .font(.system(size: 22))
                            Text("Nueva carpeta")
                                .font(.caption)
                        }
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        showingSortOptions = true
                    }) {
                        VStack {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 22))
                            Text("Ordenar")
                                .font(.caption)
                        }
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showFavorites.toggle()
                        if viewModel.showFavorites {
                            // Mostrar solo los favoritos
                            viewModel.files = viewModel.favorites
                        } else {
                            // Recargar todos los archivos
                            viewModel.loadFiles()
                        }
                    }) {
                        VStack {
                            Image(systemName: viewModel.showFavorites ? "star.fill" : "star")
                                .font(.system(size: 22))
                            Text("Favoritos")
                                .font(.caption)
                        }
                        .foregroundColor(viewModel.showFavorites ? .yellow : themeManager.currentTheme.primaryColor)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        showingSettingsSheet = true
                    }) {
                        VStack {
                            Image(systemName: "gear")
                                .font(.system(size: 22))
                            Text("Ajustes")
                                .font(.caption)
                        }
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
                .shadow(radius: 2)
            }
            .navigationTitle("Gestor de Archivos IPN")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.loadFiles()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .alert("Nueva carpeta", isPresented: $showingCreateFolderAlert) {
                TextField("Nombre de la carpeta", text: $newFolderName)
                Button("Cancelar", role: .cancel) {}
                Button("Crear") {
                    if !newFolderName.isEmpty {
                        viewModel.createFolder(named: newFolderName)
                        newFolderName = ""
                    }
                }
            }
            .alert("Renombrar archivo", isPresented: $showingRenameAlert) {
                TextField("Nuevo nombre", text: $newFileName)
                Button("Cancelar", role: .cancel) {}
                Button("Renombrar") {
                    if let file = selectedFile, !newFileName.isEmpty {
                        viewModel.renameFile(file: file, newName: newFileName)
                        newFileName = ""
                    }
                }
            }
            .actionSheet(isPresented: $showingFileActionSheet) {
                ActionSheet(
                    title: Text(selectedFile?.name ?? ""),
                    buttons: [
                        .default(Text("Abrir")) {
                            // Aquí iría la lógica para abrir el archivo
                            print("Abrir archivo: \(selectedFile?.path.absoluteString ?? "")")
                        },
                        .default(Text("Renombrar")) {
                            if let file = selectedFile {
                                newFileName = file.name
                                showingRenameAlert = true
                            }
                        },
                        .default(Text(selectedFile?.isFavorite == true ? "Quitar de favoritos" : "Añadir a favoritos")) {
                            if let file = selectedFile {
                                viewModel.toggleFavorite(file)
                            }
                        },
                        .destructive(Text("Eliminar")) {
                            if let file = selectedFile, let index = viewModel.files.firstIndex(where: { $0.id == file.id }) {
                                viewModel.deleteFile(at: IndexSet(integer: index))
                            }
                        },
                        .cancel()
                    ]
                )
            }
            .actionSheet(isPresented: $showingSortOptions) {
                ActionSheet(
                    title: Text("Ordenar por"),
                    buttons: [
                        .default(Text("Nombre (A-Z)")) {
                            viewModel.sortOption = .nameAscending
                            viewModel.loadFiles()
                        },
                        .default(Text("Nombre (Z-A)")) {
                            viewModel.sortOption = .nameDescending
                            viewModel.loadFiles()
                        },
                        .default(Text("Fecha (más reciente)")) {
                            viewModel.sortOption = .dateDescending
                            viewModel.loadFiles()
                        },
                        .default(Text("Fecha (más antigua)")) {
                            viewModel.sortOption = .dateAscending
                            viewModel.loadFiles()
                        },
                        .default(Text("Tamaño (mayor)")) {
                            viewModel.sortOption = .sizeDescending
                            viewModel.loadFiles()
                        },
                        .default(Text("Tamaño (menor)")) {
                            viewModel.sortOption = .sizeAscending
                            viewModel.loadFiles()
                        },
                        .default(Text("Tipo")) {
                            viewModel.sortOption = .typeAscending
                            viewModel.loadFiles()
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showingSettingsSheet) {
                SettingsView()
            }
            .onAppear {
                // Solicitar permisos cuando se carga la vista
                requestFilePermissions()
            }
            .environmentObject(viewModel)
        }
        .accentColor(themeManager.currentTheme.primaryColor)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
    
    // Función para mostrar el menú contextual de un archivo
    private func fileContextMenu(for file: FileModel) -> some View {
        Group {
            if file.fileType == .folder {
                Button {
                    viewModel.navigateToFolder(at: file.path)
                } label: {
                    Label("Abrir", systemImage: "folder")
                }
            } else {
                Button {
                    // Lógica para abrir el archivo
                    print("Abrir archivo: \(file.path.absoluteString)")
                } label: {
                    Label("Abrir", systemImage: "doc")
                }
            }
            
            Button {
                selectedFile = file
                newFileName = file.name
                showingRenameAlert = true
            } label: {
                Label("Renombrar", systemImage: "pencil")
            }
            
            Button {
                viewModel.toggleFavorite(file)
            } label: {
                Label(file.isFavorite ? "Quitar de favoritos" : "Añadir a favoritos",
                      systemImage: file.isFavorite ? "star.slash" : "star")
            }
            
            Button(role: .destructive) {
                if let index = viewModel.files.firstIndex(where: { $0.id == file.id }) {
                    viewModel.deleteFile(at: IndexSet(integer: index))
                }
            } label: {
                Label("Eliminar", systemImage: "trash")
            }
        }
    }
    
    // Función para solicitar permisos de archivos
    private func requestFilePermissions() {
        // En una app real, aquí iría el código para solicitar los permisos de acceso a los archivos
        // Por ejemplo, para solicitar acceso a documentos, fotos, etc.
    }
}
