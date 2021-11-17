import UIKit
import FSCalendar
import UserNotifications

class CalendarViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scheduleAddButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    
    var selectedDate = FSCalendar().today!
    var isMonthly = true
    
    let todoManager = TodoManager.shared
    let notiManager = NotificationManager.shared
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: calendarView, action: #selector(calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retriveTodoData()
        setDateFormat()
        setGesture()
        setCalendarView()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadView()
    }

    
    func retriveTodoData() {
        todoManager.retriveCategories()
        todoManager.retriveTodos()
        todoManager.setTodoDictionary()
    }
    
    func setDateFormat() {
        DateFormatter.shared.dateFormat = "YYYY-MM-dd"
    }
    
    func setGesture() {
        view.addGestureRecognizer(scopeGesture)
        tableView.panGestureRecognizer.require(toFail: scopeGesture)
    }
    
    func reloadView() {
        tableView.reloadData()
        calendarView.reloadData()
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = tableView.contentOffset.y <= -tableView.contentInset.top
        if shouldBegin {
            let velocity = scopeGesture.velocity(in: view)
            switch self.calendarView.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default:
                fatalError()
            }
        }
        return shouldBegin
    }
    
    @IBAction func addSchedule(_ sender: Any) {
        guard let addVC = self.storyboard?.instantiateViewController(identifier: "addVC") as? AddScheduleViewController else { return }
        addVC.modalPresentationStyle = .fullScreen
        addVC.selectedDate = selectedDate
        
        addVC.completionClosure = { todo in
            self.todoManager.addTodo(todo: todo)
            self.todoManager.setTodoDictionary()
            self.reloadView()
        }
        present(addVC, animated: true, completion: nil)
    }
    
    @IBAction func setTodayPage(_ sender: Any) {
        calendarView.setCurrentPage(FSCalendar().today!, animated: true)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func setCalendarView() {
        calendarView.delegate = self
        calendarView.appearance.titleTodayColor = .systemBlue
        calendarView.appearance.todayColor = UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1.0)
        calendarView.appearance.selectionColor = UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1.0)
        
        // header
        calendarView.appearance.headerDateFormat = "YYYY년 M월"
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 24)
        calendarView.headerHeight = 60
        
        // weekday
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.weekdayTextColor = .systemGray
        calendarView.calendarWeekdayView.weekdayLabels[0].textColor = .red
        calendarView.weekdayHeight = 30
        
        // addButton
        calendarView.addSubview(scheduleAddButton)
        calendarView.addSubview(todayButton)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        if date != calendar.today! { calendar.appearance.todayColor = .clear }
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        todoManager.getExistedTodoDays(date: date) ? 1 : 0
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableView() {
        tableView.delegate = self
        tableView.separatorStyle = .none
        let nibName = UINib(nibName: "CalendarTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CalendarCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return todoManager.numberOfSectionsInCalendarTable(date: selectedDate)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.numberOfRowsInSectionInCalendarTable(date: selectedDate, sectionIndex: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
        let strings = todoManager.getStringsInCategoryAndArrayOfStringTuple(date: selectedDate, categoryIndex: indexPath.section)
        cell.updateCell(title: strings[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CalendarTableViewCell else { return }
        cell.todoCheck()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let category = todoManager.getCategoryInCategoryAndArrayOfStringTuple(date: selectedDate, section: section) {
            return sectionView(category: category)
        }
        return nil
    }
}

class sectionView: UIView {
    let sectionCategory: Category
    
    required init(category: Category) {
        sectionCategory = category
        super.init(frame: CGRect.zero)
        setView()
    }
    
    func setView() {
        let sectionLabel = UILabel()
        sectionLabel.textColor = .black
        sectionLabel.textAlignment = .center
        sectionLabel.font = .boldSystemFont(ofSize: 15)
        sectionLabel.text = sectionCategory.title
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false

        let sectionImage = UIImageView(image: UIImage(systemName: "circle.fill"))
        sectionImage.preferredSymbolConfiguration = .init(pointSize: 13)
        sectionImage.tintColor = sectionCategory.color.color
        sectionImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sectionLabel)
        addSubview(sectionImage)
        
        let constraint = [
            sectionImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            sectionImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            sectionLabel.topAnchor.constraint(equalTo: sectionImage.topAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: sectionImage.trailingAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
