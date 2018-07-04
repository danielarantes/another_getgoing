
import UIKit

protocol FilterDelegate {
    func getItems(rankBy: String,distance: String, openNow: Bool)
}

class FilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var data = ["Prominence", "Distance"];

    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var slider: UISlider!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var rank = "Prominence"
    var distance = "25000"
    var delegate: FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        let s = Int(sender.value * 50000)
        distance = "\(s)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func applyAction(_ sender: Any) {
        delegate?.getItems(rankBy: rank, distance: distance, openNow: openSwitch.isOn)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rank = data[row]
    }
}
