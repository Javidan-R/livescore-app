import UIKit

class SignupController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
//        passwordField.isSecureTextEntry = true
//        confirmPasswordField.isSecureTextEntry = true
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let confirmPassword = confirmPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            showAlert(message: "Bütün sahələri doldurun!")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Parollar uyğun gəlmir!")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(message: "Email formatı düzgün deyil!")
            return
        }
        
        saveUserData(email: email, password: password)
        print("Signup successful, isLoggedIn: \(UserDefaults.standard.bool(forKey: "isLoggedIn")), navigating to ViewController")
        performSegue(withIdentifier: "toMain", sender: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Xəta", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    
    func saveUserData(email: String, password: String) {
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize() // Ensure UserDefaults is saved immediately
        // Note: Storing passwords in UserDefaults is insecure; use Keychain or a backend in production
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signUpAction(UIButton())
        }
        return true
    }
}
