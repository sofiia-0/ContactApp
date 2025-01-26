//
//  Persistence.swift
//  ContactApp
//
//  Created by User-UAM on 1/25/25.
//

import CoreData

// Controlador de persistencia para CoreData
struct PersistenceController {
    // Instancia compartida para acceso global
    static let shared = PersistenceController()

    // Vista previa para pruebas sin datos reales
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)  // Controlador en memoria
        let viewContext = result.container.viewContext  // Contexto de vista de CoreData
        
        // Crear 10 elementos de ejemplo
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.name = "Nombre de ejemplo"
            newItem.phoneNumber = "123-456-7890"
        }
        
        // Guardar en el contexto de vista
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")  // Error fatal
        }
        
        return result  // Controlador con datos de prueba en memoria
    }()

    // Contenedor de la base de datos persistente
    let container: NSPersistentContainer

    // Inicializador
    init(inMemory: Bool = false) {
        // Configurar el contenedor con el nombre del modelo
        container = NSPersistentContainer(name: "ContactApp")
        
        // Usar base de datos en memoria si es necesario
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Fusionar cambios automáticamente
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Cargar las tiendas persistentes
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")  // Error fatal
            }
        })
    }
}
