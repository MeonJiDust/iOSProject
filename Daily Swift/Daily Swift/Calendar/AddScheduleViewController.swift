import UIKit
import UserNotifications
import FSCalendar

class AddScheduleViewController: UIViewController {
    @IBOutlet weak var todoTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var storedTodo: Todo?
    var currentTodo: Todo = Todo()
    var completionClosure: ((Todo) -> Void)?
    var completionClosureWithStoredTodo: ((Todo) -> Void)?
    var selectedDate = FSCalendar().today!
    var isGoal = false
    
    let notiManager = NotificationManager.shared
    let todoManager = TodoManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setCurrentTodo()
    }
    
    func setCurrentTodo() {
        if let todo = storedTodo {
            todoTF.text = todo.todoTitle
            currentTodo = todo
        } else {
            currentTodo.startDay = selectedDate
            currentTodo.endDay = selectedDate
        }
    }
    
    @IBAction func todoSave(_ sender: Any) {
        if let text = todoTF.text, text != "" {
            currentTodo.todoTitle = text
            let start = currentTodo.startDay.timeIntervalSince1970
            let end = currentTodo.endDay.timeIntervalSince1970
            
            if start <= end  {
                if var alarm = currentTodo.alarm {
                    alarm.idStrings = createId(days: currentTodo.endDay - currentTodo.startDay, hash: currentTodo.hashValue)
                    currentTodo.alarm = alarm
                    notiManager.addAlarm(id: alarm.idStrings, label: text, startDay: currentTodo.startDay, endDay: currentTodo.endDay, hour: alarm.hour, minute: alarm.minute)
                }
            } else {
                print("뭐하세요? 다시 하세요 지금 장난치시나요?")
                return
            }
            
            if let storedTodo = self.storedTodo {
                self.todoManager.removeTodo(willRemoveTodo: storedTodo)
                self.completionClosureWithStoredTodo?(currentTodo)
            } else {
                self.completionClosure?(currentTodo)
            }
        } else {
            print("Todo 생성 불가")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func createId(days: Int, hash: Int) -> [String] {
        var result:[String] = []
        for i in 0...days {
            result.append("\(hash)-\(i)")
        }
        return result
    }
    
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoSettingCell", for: indexPath) as? TodoSettingCell else { return UITableViewCell() }
        cell.updateCell(row: indexPath.row, todo: currentTodo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TodoSettingCell else { return }

        switch indexPath.row {
        case 0:
            guard let categoryVC = self.storyboard?.instantiateViewController(identifier: "CategorySettingViewController") as? CategorySettingViewController else { return }
            categoryVC.completionClosure = { category in
                self.currentTodo.category = category
                cell.setCategoryView(category: category)
            }
            self.present(categoryVC, animated: true, completion: nil)
        
        case 1...2:
            guard let dayPickVC = self.storyboard?.instantiateViewController(identifier: "StartEndDayPickViewController") as? StartEndDayPickViewController else { return }
            dayPickVC.selectedDate = currentTodo.startDay
            
            dayPickVC.completionClosure = { date in
                if indexPath.row == 1 {
                    self.currentTodo.startDay = date
                } else {
                    self.currentTodo.endDay = date
                }
                cell.setDateInfo(date: date)
            }
            self.present(dayPickVC, animated: true, completion: nil)
        
        case 3:
            guard let alarmVC = self.storyboard?.instantiateViewController(identifier: "AlarmViewController") as? AlarmViewController else { return }
            alarmVC.completionClosure = { hour, minute, isOn in
                if isOn {
                    cell.getTimeString(hour: hour, minute: minute)
                    self.currentTodo.alarm = Alarm(isOn: isOn, hour: hour, minute: minute)
                } else {
                    self.currentTodo.alarm = nil
                }
                tableView.reloadData()
            }
            present(alarmVC, animated: true, completion: nil)
        
        case 4:
            isGoal = !isGoal
            cell.accessoryView?.isHidden = !isGoal
        default:
            break
        }
    }
}

class TodoSettingCell: UITableViewCell {
    func updateCell(row: Int, todo: Todo) {
        accessoryType = row == 4 ? .none : .disclosureIndicator
        detailTextLabel?.text = ""
        
        switch row {
        case 0:
            textLabel?.text = "카테고리"
            accessoryView = getCategoryView(category: todo.category)
        case 1:
            textLabel?.text = "시작날짜"
            setDateInfo(date: todo.startDay)
        case 2:
            textLabel?.text = "종료날짜"
            setDateInfo(date: todo.endDay)
        case 3:
            textLabel?.text = "알림"
            setAlarmInfo(todo: todo)
        case 4:
            textLabel?.text = "목표로 설정할래요"
            setGoalInfo()
        default:
            break
        }
    }
    
    func setCategoryView(category: Category) {
        accessoryView = getCategoryView(category: category)
    }
    
    func setDateInfo(date: Date) {
        detailTextLabel?.text = DateFormatter.shared.string(from: date)
    }
    
    func setAlarmInfo(todo: Todo) {
        if let alarm = todo.alarm {
            getTimeString(hour: alarm.hour, minute: alarm.minute)
        } else {
            detailTextLabel?.text = ""
        }
    }
    
    func getTimeString(hour: Int, minute: Int) {
        detailTextLabel?.text = String(format: "%02d", hour) + ":" + String(format: "%02d", minute)
    }
    
    func setGoalInfo() {
        accessoryView = UIImageView(image: UIImage(systemName: "checkmark"))
        accessoryView?.tintColor = .systemPink
        accessoryView?.isHidden = true
    }
    
    func getCategoryView(category: Category) -> UIView {
        let accessoryView = UIView()
        accessoryView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let imageView = UIImageView(image: UIImage(systemName: "circle.fill"))
        let label = UILabel()
        label.text = category.title
        imageView.tintColor = category.color.color
        accessoryView.addSubview(imageView)
        accessoryView.addSubview(label)
        label.font = label.font.withSize(15)
        label.sizeToFit()
        
        imageView.frame = CGRect(x: accessoryView.frame.width - label.frame.width - 20, y: 7, width: 16, height: 16)
        label.frame = CGRect(x: accessoryView.frame.width - label.frame.width, y: 5, width: label.frame.width, height: 20)
        return accessoryView
    }
}
