import UIKit
import FSCalendar

class StartEndDayPickViewController: UIViewController,FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var todayButton: UIButton!
    
    var completionClosure: ((Date) -> Void)?
    var selectedDate = FSCalendar().today!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCalendarView()
    }
    
    @IBAction func setTodayPage(_ sender: Any) {
        calendarView.setCurrentPage(FSCalendar().today!, animated: true)
    }
    
    func setCalendarView() {
        calendarView.delegate = self
        calendarView.appearance.titleTodayColor = .systemBlue
        calendarView.appearance.todayColor = .clear
        calendarView.appearance.selectionColor = UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1.0)
        
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.headerDateFormat = "YYYY년 M월"
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 24)
        calendarView.headerHeight = 60

        calendarView.select(selectedDate)
        calendarView.addSubview(todayButton)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        completionClosure?(date)
        dismiss(animated: true, completion: nil)
    }
}
