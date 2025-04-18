import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "GestorArchivosIPN")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error al cargar Core Data: \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error al guardar contexto: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
