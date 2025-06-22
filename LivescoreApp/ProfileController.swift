import UIKit

class ProfileController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        emailField.text = UserDefaults.standard.string(forKey: "userEmail")
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        let newEmail = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !newEmail.isEmpty, isValidEmail(newEmail) else {
            showAlert(message: "Düzgün email daxil edin!")
            return
        }
        UserDefaults.standard.set(newEmail, forKey: "userEmail")
        showAlert(message: "Email yeniləndi!")
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        // Navigate back to LoginController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginController")
        UIApplication.shared.windows.first?.rootViewController = loginVC
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bildiriş", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveAction(UIButton())
        return true
    }
}
