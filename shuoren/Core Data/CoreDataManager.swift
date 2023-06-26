//
//  CoreDataManager.swift
//  shuoren
//
//  Created by littledogboy on 2023/6/25.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "shuoren")
        persistentContainer.loadPersistentStores { NSEntityDescription, error in
            if let error = error {
                fatalError("加载 Core Data 出错 \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func getAllItems() throws -> [ItemEntity] {
        let request = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ItemEntity.timeStamp, ascending: false)]
        return try viewContext.fetch(request)
    }
    
    func saveNewItem(item: HomeItem) throws {
        let itemEntity = ItemEntity(context: viewContext)
        itemEntity.id = item.id
        itemEntity.href = item.href
        itemEntity.img = item.img
        itemEntity.model = item.model
        itemEntity.title = item.title
        itemEntity.time = item.time
        itemEntity.timeStamp = Date()
        itemEntity.isFavorite = item.isFavorite
        try viewContext.save()
    }
    
    func deleteItem(item: ItemEntity) throws {
        
    }
}

