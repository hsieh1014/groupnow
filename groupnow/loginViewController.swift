import UIKit
import FirebaseAuth
class loginViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var useremail: UITextField!
    @IBOutlet weak var userpassword: UITextField!
    @IBAction func signin(_ sender: Any)
    {
        if useremail.text != "" && userpassword.text != ""
        {
            authService(email: useremail.text!, password: userpassword.text!)
            usercheck = useremail.text!
        }
        else
        {
            print("try again")
            displayAlert(title: "error", message: "Please entry your email and password.")
        }
    }

    override func viewDidLoad()
    {
        //signin Button
        signinBtn.layer.cornerRadius = 0.5 * signinBtn.bounds.size.width
        signinBtn.clipsToBounds = true
        let btnBackgroundColor = UIColor{(traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return  UIColor(red: 58/255, green: 90/255, blue: 64/255, alpha: 1)
            case .dark:
                return UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00)
            default:
                fatalError()
            }
        }
        signinBtn.backgroundColor = btnBackgroundColor
        
        //View
        let backgroundColor = UIColor{(traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor(red: 0.89, green: 0.82, blue: 0.66, alpha: 1.00)
            case .dark:
                return UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.00)
            default:
                fatalError()
            }
        }
        view.backgroundColor = backgroundColor
        
        let textfieldbackgroundColor = UIColor{(traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor(red: 1, green: 1, blue: 1, alpha: 1.00)
            case .dark:
                return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
            default:
                fatalError()
            }
        }
        let textbackgroundColor = UIColor{(traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor(red: 0.23, green: 0.35, blue: 0.25, alpha: 1.00)
            case .dark:
                return UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.00)
            default:
                fatalError()
            }
        }
        
        //email Textfield
        useremail.backgroundColor = textfieldbackgroundColor
        useremail.attributedPlaceholder = NSAttributedString(string: "email",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.64, green: 0.64, blue: 0.64, alpha: 1.00)])
        useremail.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        useremail.keyboardType = UIKeyboardType.emailAddress
        
        //password Textfield
        userpassword.backgroundColor = textfieldbackgroundColor
        userpassword.attributedPlaceholder = NSAttributedString(string: "email",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.64, green: 0.64, blue: 0.64, alpha: 1.00)])
        userpassword.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        userpassword.isSecureTextEntry = true
        signinBtn.addTarget(self,
                            action: #selector(signin),
                            for: .touchUpInside)
        
        //Text
        let label = UILabel(frame: CGRect(x: 81, y: 664, width: 184, height: 21))
        label.text = "Don't have an account ?"
        label.textColor = textbackgroundColor
        label.font = UIFont(name: "Helvetica", size: 17)
        self.view.addSubview(label)
        
        //signup Button
        let signupButton = UIButton(
          frame: CGRect(x: 273, y: 659, width: 80, height: 30))
        signupButton.setTitle("SIGN UP", for: .normal)
        signupButton.setTitleColor(textbackgroundColor,for: .normal)
        signupButton.isEnabled = true
        signupButton.addTarget(self,
                               action: #selector(signup),
                               for: .touchUpInside)
        self.view.addSubview(signupButton)
        
        super.viewDidLoad()
    }
    @objc func signup()
    {
        performSegue(withIdentifier: "signup", sender: self)
    }
    
    //touch screen to hide the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    //return btn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
          textField.resignFirstResponder()
          return true
    }
    
    //signin auth
    func authService(email: String, password: String)
    {
        Auth.auth().signIn(withEmail: email, password: password)
        {(user,error) in
            if error != nil
            {
                let errorString = String(describing: (error! as NSError).userInfo["FIRAuthErrorUserInfoNameKey"]!)
                if errorString == "ERROR_USER_NOT_FOUND"
                {
                    print("no account")
                    self.displayAlert(title: "no account", message:"sign up first!")
                }
                else
                {
                    self.displayAlert(title: "Sign in error", message: (error?.localizedDescription)!)
                }
            }
            else //sign in
            {
                self.performSegue(withIdentifier: "signin", sender: self)
            }
        }
    }
    
    //error alert
    func displayAlert(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController,animated: true,completion: nil)
    }
}
