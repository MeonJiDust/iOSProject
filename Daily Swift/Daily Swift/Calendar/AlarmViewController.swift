
import UIKit

class AlarmViewController: UIViewController {
    @IBOutlet weak var halfModalView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var controlSwitch: UISwitch!
    
    var completionClosure: ((Int, Int, Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    func setView() {
        self.view.backgroundColor = .clear
        self.halfModalView.layer.cornerRadius = 10
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_: )))
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func alarmSave(_ sender: Any) {
        let time = getTime()
        completionClosure?(time[0], time[1], controlSwitch.isOn)
        dismiss(animated: true, completion: nil)
    }
    
    func getTime() -> [Int] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let dateString = dateFormatter.string(from: datePicker.date)
        guard let hour = Int(dateString.split(separator: ":")[0]), let minute = Int(dateString.split(separator: ":")[1]) else { return [00,00] }
        return [hour, minute]
    }
    
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        let dismissArea = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
        let point = gesture.location(in: self.view)
        if dismissArea.contains(point) {
            dismiss(animated: true, completion: nil)
        }
    }
}
