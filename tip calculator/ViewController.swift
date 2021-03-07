// Homework #2 Swift class
// Titus Devakumar

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var tip1Label: UILabel!
    @IBOutlet weak var fifteenPercentTipLabel: UILabel!
    @IBOutlet weak var twentyPercentTipLabel: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        billTextField.delegate = self
        
        print("Hello, Titus")
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    @IBAction func calculateTipButtonPressed(_ sender: Any) {
        print("Not Including tip")
        hideKeyboard()
        calculateAllTips()
    }
    
    
    func hideKeyboard() {
        billTextField.resignFirstResponder()
    }
    
    func calculateAllTips() {
        guard let subtotal = convertCurrencyToDouble(input: billTextField.text!) else {
            print("Not a number!: \(billTextField.text!)")
            return
        }
        print("Your total without tip is: $\(subtotal)")
        
        // Calculate the tips
        let tip1 = calculateTip(subtotal: subtotal, tipPercentage: 110.0)
        let tip2 = calculateTip(subtotal: subtotal, tipPercentage: 115.0)
        let tip3 = calculateTip(subtotal: subtotal, tipPercentage: 120.0)
        
        // Update the UI
        tip1Label.text = convertDoubleToCurrency(amount: tip1)
        fifteenPercentTipLabel.text = convertDoubleToCurrency(amount: tip2)
        twentyPercentTipLabel.text = convertDoubleToCurrency(amount: tip3)
    }
    
    func calculateTip(subtotal: Double, tipPercentage: Double) -> Double {
        return subtotal * (tipPercentage / 100.0)
    }
    
    
    func convertCurrencyToDouble(input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.number(from: input)?.doubleValue
    }
    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    
    @objc func keyboardWillChange(notification: Notification) {

        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    
    // UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return pressed")
        hideKeyboard()
        calculateAllTips()
        return true
    }
}
