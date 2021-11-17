import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        cell.setLabelText(section: indexPath.section, row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: 200, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 13)

        if section == 0 {
            label.text = "🗓 캘린더 및 설정(있어보이는 부분)"
        } else {
            label.text = "🧑🏻‍💻 기타(그럴싸 함)"
        }
        sectionView.addSubview(label)
        return sectionView
    }
}

// MARK: Cell
class SettingTableViewCell: UITableViewCell {
    func setLabelText(section: Int, row: Int) {
        self.textLabel?.font = UIFont.systemFont(ofSize: 20)
        self.accessoryType = .disclosureIndicator
        self.detailTextLabel?.text = ""
        
        if section == 0 {
            self.textLabel?.text = (row != 0) ? "폰트 수정" : "시작 요일 수정"
        } else {
            self.textLabel?.text = (row != 0) ? "(버전)있어보이는 부분ㅋㅋ" : "하 드디어 끝났다"
            if row == 1 {
                self.accessoryType = .none
                self.detailTextLabel?.text = "1.0.0"
                self.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            }
        }
    }
}
