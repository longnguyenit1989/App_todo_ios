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

class TodoManager {
    private let todoTable = "Todo"
    private let idKey = "id"
    private let titleKey = "title"
    private let contentKey = "content"
    private let statusKey = "status"
    private let emailKeyTodo = "email"
    
    private let userTable = "User"
    private let fullNameKey = "fullName"
    private let emailKey = "email"
    private let passwordKey = "password"
    
    @Inject var localStorageRepository: LocalStorageRepository
    
    lazy var managedContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    func saveTodos(_ todos: [Todo]) {
        for todo in todos {
            let entity = NSEntityDescription.entity(forEntityName: todoTable, in: managedContext)!
            let todoEntity = NSManagedObject(entity: entity, insertInto: managedContext)
            
            todoEntity.setValue(todo.id, forKey: idKey)
            todoEntity.setValue(todo.title, forKey: titleKey)
            todoEntity.setValue(todo.content, forKey: contentKey)
            todoEntity.setValue(todo.status.rawValue, forKey: statusKey)
            todoEntity.setValue(todo.email, forKey: emailKeyTodo)
            managedContextSave()
        }
    }
    
    func saveTodo(_ todo: Todo) {
        let entity = NSEntityDescription.entity(forEntityName: todoTable, in: managedContext)!
        let todoEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        todoEntity.setValue(todo.id, forKey: idKey)
        todoEntity.setValue(todo.title, forKey: titleKey)
        todoEntity.setValue(todo.content, forKey: contentKey)
        todoEntity.setValue(todo.status.rawValue, forKey: statusKey)
        todoEntity.setValue(todo.email, forKey: emailKeyTodo)
        managedContextSave()
    }
    
    func saveUser(_ user: User, callbackError: ((String) -> Void)? = nil, callbackSuccess: (() -> Void)? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: userTable)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for data in results as! [NSManagedObject] {
                let emailCoreData = data.value(forKey: emailKey) as! String
                if (user.email.elementsEqual(emailCoreData)) {
                    callbackError?("Your email is exist, change other email !")
                    return
                }
            }
        } catch {
            
        }
        
        let entity = NSEntityDescription.entity(forEntityName: userTable, in: managedContext)!
        let userEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        userEntity.setValue(user.fullName, forKey: fullNameKey)
        userEntity.setValue(user.email, forKey: emailKey)
        userEntity.setValue(user.password, forKey: passwordKey)
        localStorageRepository.setUser(user: user)
        managedContextSave()
        callbackSuccess?()
    }
    
    func updateTodo(_ updatedTodo: Todo) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: todoTable)
        do {
            let results = try managedContext.fetch(fetchRequest)
            for data in results as! [NSManagedObject] {
                let id = data.value(forKey: idKey) as! Int64
                if(updatedTodo.id == id) {
                    data.setValue(updatedTodo.title, forKey: titleKey)
                    data.setValue(updatedTodo.content, forKey: contentKey)
                    data.setValue(updatedTodo.status.rawValue, forKey: statusKey)
                    break
                }
            }
            managedContextSave()
        } catch {
            
        }
    }
    
    func managedContextSave() {
        do {
            try managedContext.save()
        } catch {
            
        }
    }
    
    func fetchTodos(email: String) -> [Todo] {
        var todos: [Todo] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: todoTable)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for data in results as! [NSManagedObject] {
                let emailCoreData = data.value(forKey: emailKeyTodo) as! String
                if (email.elementsEqual(emailCoreData)) {
                    let id = data.value(forKey: idKey) as! Int64
                    let title = data.value(forKey: titleKey) as! String
                    let content = data.value(forKey: contentKey) as! String
                    let statusRawValue = data.value(forKey: statusKey) as! String
                    let status = StatusTodo(rawValue: statusRawValue) ?? StatusTodo.working
                    let todo = Todo(id, title, content, status, email)
                    todos.append(todo)
                }
            }
        } catch {
            
        }
        return todos
    }
    
    func checkLogin(_ email: String,_ password: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: userTable)
        do {
            let results = try managedContext.fetch(fetchRequest)
            for data in results as! [NSManagedObject] {
                let fullNameCoreData = data.value(forKey: fullNameKey) as! String
                let emailCoreData = data.value(forKey: emailKey) as! String
                let passwordCoreData = data.value(forKey: passwordKey) as! String
                if (email.elementsEqual(emailCoreData) == true && password.elementsEqual(passwordCoreData) == true) {
                    let user = User(fullNameCoreData, emailCoreData, passwordCoreData)
                    self.localStorageRepository.setUser(user: user)
                    return true
                }
            }
        } catch {
            
        }
        
        return false
    }
    
}




