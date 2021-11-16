import UIKit

class CategorySettingViewController: UIViewController {
    
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var redColorButton: UIButton!
    @IBOutlet weak var orangeColorButton: UIButton!
    @IBOutlet weak var yellowColorButton: UIButton!
    @IBOutlet weak var greenColorButton: UIButton!
    @IBOutlet weak var blueColorButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let colorPicks: [UIColor] = [.systemPink, .systemOrange, .systemYellow, .systemGreen, .systemBlue]
    var tagColor: UIColor = .systemBlue
    var colorButtons: [UIButton] = []
    var checkedIndex: Int = 0
    var completionClosure: ((Category) -> Void)?
    let todoManager = TodoManager.shared
    private let cellId = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        completionClosure?(todoManager.indexOfCategories(index: checkedIndex))
    }
    
    func setButtons() {
        colorButtons = [redColorButton, orangeColorButton, yellowColorButton, greenColorButton, blueColorButton]
        blueColorButton.isSelected = true
    }
    
    @IBAction func colorPick(_ sender: UIButton) {
        for button in colorButtons {
            button.isSelected = sender.tag == button.tag
            tagColor = colorPicks[sender.tag]
        }
    }
    
    @IBAction func categoryAddButton(_ sender: Any) {
        if let text = categoryTF.text, text != "" {
            categoryTF.text = ""
            let category: Category = Category(color: .init(color: tagColor), title: text)
            todoManager.addCategory(category: category)
            tableView.reloadData()
        }
    }
}

extension CategorySettingViewController: UITableViewDelegate, UITableViewDataSource {
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CategoryCell else { return UITableViewCell() }
        let category = todoManager.indexOfCategories(index: indexPath.row)
        
        cell.updateCell(category: category)
        cell.checkMark.isHidden = indexPath.row != checkedIndex
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lastCheckedCell = tableView.cellForRow(at: [0,self.checkedIndex]) as? CategoryCell else { return }
        lastCheckedCell.checkMark.isHidden = true
        
        guard let currentCheckedCell = tableView.cellForRow(at: [0,indexPath.row]) as? CategoryCell else { return }
        currentCheckedCell.checkMark.isHidden = false
        checkedIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.row == 0 ? .none : .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            checkedIndex = checkedIndex == indexPath.row ? checkedIndex - 1 : checkedIndex
            todoManager.removeCategory(index: indexPath.row)
            tableView.reloadData()
        }
    }
}

class CategoryCell: UITableViewCell {
    @IBOutlet weak var categoryColor: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    
    func updateCell(category: Category) {
        categoryColor.tintColor = category.color.color
        categoryLabel.text = category.title
    }
}
