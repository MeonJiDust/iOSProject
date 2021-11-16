import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var outLineView: UIView!
    @IBOutlet weak var strikeThroughView: UIView!
    @IBOutlet weak var strikeThroughtWidth: NSLayoutConstraint!
    
    var isDone = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(title: String) {
        todoLabel.text = title
    }
    
    func reset() {
        outLineView.layer.cornerRadius = 10
        todoLabel.alpha = 1
        strikeThroughtWidth.constant = 0
    }
    
    func todoCheck() {
        isDone = !isDone
        if isDone {
            checkButton.isSelected = true
            todoLabel.alpha = 0.2
            strikeThroughtWidth.constant = todoLabel.bounds.width
        } else {
            checkButton.isSelected = false
            todoLabel.alpha = 1
            strikeThroughtWidth.constant = 0
        }
    }
}
