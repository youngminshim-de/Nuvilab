//
//  PersistenceManager.swift
//  Nuvilab
//
//  Created by 심영민 on 12/4/24.
//

import Foundation
import CoreData

final class PersistenceManager {
    static let shared = PersistenceManager()
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "BookInformation")
        
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                print(error)
            }
        }
    }
    
    func fetchCoreData(fetchLimit: Int = 30, fetchOffset: Int) -> [BookInformationModel] {
        let request = BookInformation.fetchRequest()
        
        request.fetchLimit = fetchLimit
        request.fetchOffset = fetchOffset
        
        do {
            let bookInformation = try context.fetch(request)
            return bookInformation.map { book in
                BookInformationModel(entity: book)
            }
        } catch {
            return []
        }
    }
    
    func saveBooks(_ books: [BookInformationModel]) {
        
        let request = BookInformation.fetchRequest()
        books.forEach { book in
            request.predicate = NSPredicate(format: "id == %d", book.id)
            do {
                let results = try context.fetch(request)
                ///  CoreData에 동일한 Data가 없는경우에만 저장한다.
                if results.first == nil {
                    let bookEntity = BookInformation(context: context)
                    bookEntity.id = Int64(book.id)
                    bookEntity.genre = book.genre
                    bookEntity.bookName = book.bookName
                    bookEntity.authorName = book.authorName
                    bookEntity.publisher = book.publisher
                    bookEntity.publicationYear = book.publicationYear
                    bookEntity.isLoaned = book.isLoaned
                    bookEntity.descriptions = book.descriptions
                }
            } catch {
                
            }
        }
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch(let error) {
                let nsError = error as NSError
                print(nsError)
            }
        }
    }
}
