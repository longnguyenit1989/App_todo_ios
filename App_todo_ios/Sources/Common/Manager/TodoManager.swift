//
//  TodoManager.swift
//  App_todo_ios
//
//  Created by OPN-Macbook on 08/12/2023.
//

import Foundation
import UIKit
import CoreData
import MPInjector

final class TodoManager {
    @Inject
    private var localStorageRepository: LocalStorageRepository
    
    private lazy var managedContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        
        return appDelegate.persistentContainer.viewContext
    }()
    
    private enum Entity {
        static let todo = "Todo"
        static let user = "User"
    }
    
    private enum TodoKey {
        static let id = "id"
        static let title = "title"
        static let content = "content"
        static let status = "status"
        static let email = "email"
    }
    
    private enum UserKey {
        static let fullName = "fullName"
        static let email = "email"
        static let password = "password"
    }
}

extension TodoManager {
    func saveTodos(_ todos: [Todo]) {
        todos.forEach { saveTodoObject($0) }
        saveContext()
    }
    
    func saveTodo(_ todo: Todo) {
        if isTodoExist(id: todo.id) {
            updateTodo(todo)
            return
        }
        saveTodoObject(todo)
        saveContext()
    }
    
    func fetchTodos(email: String) -> [Todo] {
        let request = NSFetchRequest<NSManagedObject>(
            entityName: Entity.todo
        )
        
        request.predicate = NSPredicate(
            format: "%K == %@",
            TodoKey.email,
            email
        )
        
        do {
            let results = try managedContext.fetch(request)
            return results.compactMap { object in guard
                    let id = object.value(forKey: TodoKey.id) as? Int64,
                    let title = object.value(forKey: TodoKey.title) as? String,
                    let content = object.value(forKey: TodoKey.content) as? String,
                    let statusRawValue = object.value(forKey: TodoKey.status) as? String
                else {
                    return nil
                }
                
                let status = StatusTodo(rawValue: statusRawValue) ?? .working
                
                return Todo(
                    id,
                    title,
                    content,
                    status,
                    email
                )
            }
        } catch {
            print("Fetch Todos Error: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateTodo(_ updatedTodo: Todo) {
        let request = NSFetchRequest<NSManagedObject>(
            entityName: Entity.todo
        )
        
        request.predicate = NSPredicate(
            format: "%K == %lld",
            TodoKey.id,
            updatedTodo.id
        )
        
        do {
            guard let object = try managedContext.fetch(request).first else {
                return
            }
            object.setValue(updatedTodo.title, forKey: TodoKey.title)
            object.setValue(updatedTodo.content, forKey: TodoKey.content)
            object.setValue(updatedTodo.status.rawValue, forKey: TodoKey.status)
            saveContext()
        } catch {
            print("Update Todo Error: \(error.localizedDescription)")
        }
    }
    
    func deleteTodo(id: Int64) {
        let request = NSFetchRequest<NSManagedObject>(
            entityName: Entity.todo
        )
        request.predicate = NSPredicate(
            format: "%K == %lld",
            TodoKey.id,
            id
        )
        
        do {
            guard let object = try managedContext.fetch(request).first else {
                return
            }
            managedContext.delete(object)
            saveContext()
        } catch {
            print("Delete Todo Error: \(error.localizedDescription)")
        }
    }
}

extension TodoManager {
    func saveUser(
        _ user: User,
        callbackError: ((String) -> Void)? = nil,
        callbackSuccess: (() -> Void)? = nil
    ) {
        if isUserExist(email: user.email) {
            callbackError?("Email already exists")
            return
        }
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: Entity.user,
            in: managedContext
        ) else {
            callbackError?("Create entity failed")
            return
        }
        
        let userObject = NSManagedObject(
            entity: entity,
            insertInto: managedContext
        )
        userObject.setValue(user.fullName, forKey: UserKey.fullName)
        userObject.setValue(user.email, forKey: UserKey.email)
        userObject.setValue(user.password, forKey: UserKey.password)
        
        localStorageRepository.setUser(user: user)
        saveContext()
        callbackSuccess?()
    }
    
    func checkLogin(
        _ email: String,
        _ password: String
    ) -> Bool {
        let request = NSFetchRequest<NSManagedObject>(
            entityName: Entity.user
        )
        
        request.predicate = NSPredicate(
            format: "%K == %@ AND %K == %@",
            UserKey.email,
            email,
            UserKey.password,
            password
        )
        
        do {
            guard let object = try managedContext.fetch(request).first else {
                return false
            }
            guard
                let fullName = object.value(forKey: UserKey.fullName) as? String,
                let email = object.value(forKey: UserKey.email) as? String,
                let password = object.value(forKey: UserKey.password) as? String
            else {
                return false
            }
            let user = User(
                fullName,
                email,
                password
            )
            localStorageRepository.setUser(user: user)
            return true
        } catch {
            print("Check Login Error: \(error.localizedDescription)")
            return false
        }
    }
}

private extension TodoManager {
    func saveTodoObject(_ todo: Todo) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: Entity.todo,
            in: managedContext
        ) else {
            return
        }
        let object = NSManagedObject(
            entity: entity,
            insertInto: managedContext
        )
        
        object.setValue(todo.id, forKey: TodoKey.id)
        object.setValue(todo.title, forKey: TodoKey.title)
        object.setValue(todo.content, forKey: TodoKey.content)
        object.setValue(todo.status.rawValue, forKey: TodoKey.status)
        object.setValue(todo.email, forKey: TodoKey.email)
    }
    
    func isUserExist(email: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: Entity.user
        )
        request.predicate = NSPredicate(
            format: "%K == %@",
            UserKey.email,
            email
        )
        
        do {
            let count = try managedContext.count(for: request)
            return count > 0
        } catch {
            print("Check User Exist Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func isTodoExist(id: Int64) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: Entity.todo
        )
        request.predicate = NSPredicate(
            format: "%K == %lld",
            TodoKey.id,
            id
        )
        
        do {
            let count = try managedContext.count(for: request)
            return count > 0
        } catch {
            print("Check Todo Exist Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func saveContext() {
        guard managedContext.hasChanges else {
            return
        }
        do {
            try managedContext.save()
        } catch {
            print("Save Context Error: \(error.localizedDescription)")
        }
    }
}
