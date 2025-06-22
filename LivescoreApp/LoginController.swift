import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        
        // Skip login if already logged in
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            print("Already logged in, navigating to ViewController")
            performSegue(withIdentifier: "toMain", sender: nil)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Bütün sahələri doldurun!")
            return
        }
        
        let savedEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        if email == savedEmail {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            print("Login successful, navigating to ViewController")
            performSegue(withIdentifier: "toMain", sender: nil)
        } else {
            showAlert(message: "Email və ya parol yanlışdır!")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Xəta", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginAction(UIButton())
        }
        return true
    }
}
