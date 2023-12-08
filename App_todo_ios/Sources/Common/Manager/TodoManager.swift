//
//  TodoManager.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 08/12/2023.
//

import Foundation

import UIKit
import CoreData

import Foundation
import UIKit
import CoreData

class TodoManager {
    lazy var managedContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    func saveTodos(_ todos: [Todo]) {
        for todo in todos {
            let entity = NSEntityDescription.entity(forEntityName: "Todo", in: managedContext)!
            let todoEntity = NSManagedObject(entity: entity, insertInto: managedContext)
            
            todoEntity.setValue(todo.id, forKey: "id")
            todoEntity.setValue(todo.title, forKey: "title")
            todoEntity.setValue(todo.content, forKey: "content")
            todoEntity.setValue(todo.status.rawValue, forKey: "status")
            managedContextSave()
        }
    }
    
    func saveTodo(_ todo: Todo) {
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: managedContext)!
        let todoEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        todoEntity.setValue(todo.id, forKey: "id")
        todoEntity.setValue(todo.title, forKey: "title")
        todoEntity.setValue(todo.content, forKey: "content")
        todoEntity.setValue(todo.status.rawValue, forKey: "status")
        managedContextSave()
    }
    
    func updateTodo(_ updatedTodo: Todo) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        do {
            let results = try managedContext.fetch(fetchRequest)
            for todo in results as! [NSManagedObject] {
                let id = todo.value(forKey: "id") as! Int64
                if(updatedTodo.id == id) {
                    todo.setValue(updatedTodo.title, forKey: "title")
                    todo.setValue(updatedTodo.content, forKey: "content")
                    todo.setValue(updatedTodo.status.rawValue, forKey: "status")
                    break
                }
            }
            managedContextSave()
        } catch {
            print("Error updating Todo: \(error)")
        }
    }
    
    func managedContextSave() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchTodos() -> [Todo] {
        var todos: [Todo] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for data in results as! [NSManagedObject] {
                let id = data.value(forKey: "id") as! Int64
                let title = data.value(forKey: "title") as! String
                let content = data.value(forKey: "content") as! String
                let statusRawValue = data.value(forKey: "status") as! String
                let status = StatusTodo(rawValue: statusRawValue) ?? StatusTodo.working
                
                let todo = Todo(id, title, content, status)
                todos.append(todo)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return todos
    }
}




