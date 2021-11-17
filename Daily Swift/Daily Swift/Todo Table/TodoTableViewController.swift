import UIKit

class TodoTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let todoManager = TodoManager.shared
    private let cellId = "todoTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadView()
    }
}

extension TodoTableViewController: UITableViewDelegate, UITableViewDataSource {
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func reloadView() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.numberOfRowsInSectionInTodoTable(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return todoManager.numberOfSectionsInTodoTable()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TodoTableViewCell else { return UITableViewCell() }
        let todo = todoManager.getTodoInCategoryAndArrayOfTodoTuple(indexPath: indexPath)
        cell.updateCell(todo: todo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = todoManager.getCategoryInCategoryAndArrayOfTodoTuple(section: section)
        return sectionView(category: category)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = todoManager.getTodoInCategoryAndArrayOfTodoTuple(indexPath: indexPath)
            todoManager.removeTodo(willRemoveTodo: todo)
            reloadView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let addVC = self.storyboard?.instantiateViewController(identifier: "addVC") as? AddScheduleViewController else { return }
        addVC.modalPresentationStyle = .fullScreen

        let todo = todoManager.getTodoInCategoryAndArrayOfTodoTuple(indexPath: indexPath)
        
        addVC.storedTodo = todo
        addVC.completionClosureWithStoredTodo = { storedTodo in
            self.todoManager.addTodo(todo: storedTodo)
            self.todoManager.setTodoDictionary()
            self.tableView.reloadData()
        }
        present(addVC, animated: true, completion: nil)
    }
}

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outLineView: UIView!
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var dayStringLabel: UILabel!
    @IBOutlet weak var alarmImageView: UIImageView!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    
    func updateCell(todo: Todo) {
        backgroundColor = .clear
        outLineView.backgroundColor = .white
        outLineView.layer.cornerRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
        
        let startDayString = DateFormatter.shared.string(from: todo.startDay)
        let endDayString = DateFormatter.shared.string(from: todo.endDay)
        
        todoTitleLabel.text = todo.todoTitle
        todoTitleLabel.numberOfLines = 0
        dayStringLabel.text = startDayString + "~" + endDayString
        if let alarm = todo.alarm {
            alarmImageView.isHidden = false
            alarmTimeLabel.isHidden = false
            alarmTimeLabel.text = String(format: "%02d", alarm.hour) + ":" + String(format: "%02d", alarm.minute)
        } else {
            alarmImageView.isHidden = true
            alarmTimeLabel.isHidden = true
        }
    }
}
