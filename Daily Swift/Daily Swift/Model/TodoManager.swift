import Foundation
import UIKit

class TodoManager {
    static let shared = TodoManager()
    
    private var todoDictionary: [String:[Category:[String]]] = [:]
    private var todos: [Todo] = []
    private var categories: [Category] = [Category.basicCategory]
    
    init() {
        DateFormatter.shared.dateFormat = "YYYY-MM-dd"
    }
    
    // MARK: CATEGORY
    var numberOfCategories: Int {
        categories.count
    }
    
    func saveCategory() {
        Storage.store(categories, to: .documents, as: "category.json")
    }
    
    func retriveCategories() {
        categories = Storage.retrive("category.json", from: .documents, as: [Category].self) ?? []
    }
    
    func addCategory(category: Category) {
        categories.append(category)
        saveCategory()
    }
    
    func removeCategory(index: Int) {
        if index < categories.count {
            categories.remove(at: index)
            saveCategory()
        }
    }
    
    func indexOfCategories(index: Int) -> Category {
        categories[index]
    }

    
    // MARK: TODO
    func addTodo(todo: Todo) {
        todos.append(todo)
        saveTodo()
    }
    
    func saveTodo() {
        Storage.store(todos, to: .documents, as: "todo.json")
    }
    
    func retriveTodos() {
        todos = Storage.retrive("todo.json", from: .documents, as: [Todo].self) ?? []
    }
    
    func removeTodo(willRemoveTodo: Todo) {
        for i in 0..<todos.count {
            if todos[i] == willRemoveTodo {
                if let alarm = willRemoveTodo.alarm {
                    for id in alarm.idStrings {
                        NotificationManager.shared.removeNotification(id: id)
                    }
                }
                todos.remove(at: i)
                for j in 0...willRemoveTodo.endDay - willRemoveTodo.startDay {
                    let dayString = DateFormatter.shared.string(from: willRemoveTodo.startDay.adding(days: j)!)
                    
                    if let categoryDict = todoDictionary[dayString], var strings = categoryDict[willRemoveTodo.category] {
                        for k in 0..<strings.count {
                            if strings[k] == willRemoveTodo.todoTitle {
                                strings.remove(at: k)
                                break
                            }
                        }
                        todoDictionary[dayString]?[willRemoveTodo.category] = strings
                        todoDictionary[dayString] = todoDictionary[dayString]?.filter { $1.count > 0 }
                        todoDictionary = todoDictionary.filter { $1.count > 0 }
                    }
                }
                saveTodo()
                return
            }
        }
    }
    
    
    // MARK: ETC
    func setTodoDictionary() {
        var dict: [String:[Category:[String]]] = [:]
        
        for todo in self.todos {
            for i in 0...todo.endDay - todo.startDay {
                let dayString = DateFormatter.shared.string(from: todo.startDay.adding(days: i)!)
                
                if let dayValue = dict[dayString] {
                    if let _ = dayValue[todo.category] {
                        dict[dayString]?[todo.category]?.append(todo.todoTitle)
                    } else {
                        dict[dayString]?[todo.category] = [todo.todoTitle]
                    }
                } else {
                    dict[dayString] = [todo.category:[todo.todoTitle]]
                }
            }
        }
        self.todoDictionary = dict
    }

    func getCategoryAndArrayOfStringTuple(date: Date) -> [(Category,[String])]? {
        var basicCategoryStrings: [String] = []
        let dateString = DateFormatter.shared.string(from: date)
        var tuples: [(Category, [String])] = []
        
        if let dict = self.todoDictionary[dateString] {
            for (key, value) in dict {
                if key == Category.basicCategory {
                    basicCategoryStrings = value
                } else {
                    tuples.append((key, value))
                }
            }
            
            tuples = tuples.sorted { $0.0.title < $1.0.title }
            if basicCategoryStrings.count > 0 { tuples.insert((Category.basicCategory, basicCategoryStrings), at: 0) }
            
            for i in 0..<tuples.count {
                tuples[i].1 = tuples[i].1.sorted(by: < )
            }
            return tuples
        } else {
            return nil
        }
    }
    
    func getCategoryAndArrayOfTodoTuple() -> [(Category, [Todo])] {
        var dict: [Category:[Todo]] = [:]
        var basicCategoryTodos: [Todo] = []
        
        for todo in self.todos {
            if todo.category == Category.basicCategory {
                basicCategoryTodos.append(todo)
            } else {
                if var todoArray = dict[todo.category] {
                    todoArray.append(todo)
                    dict[todo.category] = todoArray
                } else {
                    dict[todo.category] = [todo]
                }
            }
        }
        var tuple = dict.map {($0, $1)}.sorted { $0.0.title < $1.0.title }
        if basicCategoryTodos.count > 0 { tuple.insert((Category.basicCategory, basicCategoryTodos), at: 0) }
        
        for i in 0..<tuple.count {
            tuple[i].1 = tuple[i].1.sorted { $0.todoTitle < $1.todoTitle }.sorted { $0.startDay.timeIntervalSince1970 < $1.startDay.timeIntervalSince1970 }
        }
        return tuple
    }
    
    func getTodoInCategoryAndArrayOfTodoTuple(indexPath: IndexPath) -> Todo {
        let tuples = getCategoryAndArrayOfTodoTuple()
        return tuples[indexPath.section].1[indexPath.row]
    }
    
    func getCategoryInCategoryAndArrayOfTodoTuple(section: Int) -> Category {
        let tuples = getCategoryAndArrayOfTodoTuple()
        return tuples[section].0
    }
    
    func numberOfRowsInSectionInTodoTable(section: Int) -> Int {
        return getCategoryAndArrayOfTodoTuple()[section].1.count
    }
    
    func numberOfSectionsInTodoTable() -> Int {
        return getCategoryAndArrayOfTodoTuple().count
    }

    func numberOfSectionsInCalendarTable(date: Date) -> Int {
        if let categoryTuples = getCategoryAndArrayOfStringTuple(date: date) {
            print("categoryTuple : ", categoryTuples)
            return categoryTuples.count
        }
        return 0
    }
    
    func numberOfRowsInSectionInCalendarTable(date: Date, sectionIndex: Int) -> Int {
        if let categoryTuples = getCategoryAndArrayOfStringTuple(date: date) {
            return categoryTuples[sectionIndex].1.count
        }
        return 0
    }
    
    func getStringsInCategoryAndArrayOfStringTuple(date: Date, categoryIndex: Int) -> [String] {
        if let categoryTuples = getCategoryAndArrayOfStringTuple(date: date) {
            return categoryTuples[categoryIndex].1
        }
        return []
    }
    
    func getCategoryInCategoryAndArrayOfStringTuple(date: Date, section: Int) -> Category? {
        if let categoryTuples = getCategoryAndArrayOfStringTuple(date: date) {
            return categoryTuples[section].0
        }
        return nil
    }
    
    func getExistedTodoDays(date: Date) -> Bool {
        let dayStrings = getExistedTodoStrings()
        let dateString = DateFormatter.shared.string(from: date)

        return dayStrings.contains(dateString)
    }
    
    func getExistedTodoStrings() -> [String] {
        var dayStrings: Set<String> = Set<String>()
        for key in todoDictionary.keys {
            dayStrings.insert(key)
        }
        return Array(dayStrings).sorted()
    }
}
