import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseCore

var usercheck : String = ""
var user : String = ""

class signupViewController: UIViewController
{
    //set user database
    var userdb: Firestore!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userphoneTextField: UITextField!
    @IBOutlet weak var useremailTextField: UITextField!
    @IBOutlet weak var userpasswordTextField: UITextField!
    @IBOutlet weak var useraddressTextField: UITextField!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var mobileText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var passwordText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    
    @IBOutlet weak var save: UIButton!
    @IBAction func signupBtn(_ sender: Any)
    {
        //useremail and userpassword
        if useremailTextField.text != "" && userpasswordTextField.text != ""
         {
             signup(email:useremailTextField.text!, password:userpasswordTextField.text!)
             addData(username: usernameTextField.text!, usermobile: userphoneTextField.text!, useremail: useremailTextField.text!, userpassword: userpasswordTextField.text!, useraddress: useraddressTextField.text!)
            usercheck = useremailTextField.text!
            user = usernameTextField.text!
         }
         else
         {
             displayAlert(title: "error", message: "Please entry your email and passwor.")
         }
    }
    
    override func viewDidLoad()
    {
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
        
        //Text and Textfield
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
                return UIColor(red: 0.20, green: 0.31, blue: 0.25, alpha: 1.00)
            case .dark:
                return UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 1.00)
            default:
                fatalError()
            }
        }
        nameText.textColor = textbackgroundColor
        mobileText.textColor = textbackgroundColor
        emailText.textColor = textbackgroundColor
        passwordText.textColor = textbackgroundColor
        addressText.textColor = textbackgroundColor
        usernameTextField.backgroundColor = textfieldbackgroundColor
        userphoneTextField.backgroundColor = textfieldbackgroundColor
        useremailTextField.backgroundColor = textfieldbackgroundColor
        userpasswordTextField.keyboardType = UIKeyboardType.emailAddress
        userpasswordTextField.backgroundColor = textfieldbackgroundColor
        userpasswordTextField.isSecureTextEntry = true
        useraddressTextField.backgroundColor = textfieldbackgroundColor
        usernameTextField.textColor = textbackgroundColor
        userphoneTextField.textColor = textbackgroundColor
        useremailTextField.textColor = textbackgroundColor
        userpasswordTextField.textColor = textbackgroundColor
        useraddressTextField.textColor = textbackgroundColor
        
        //save Btn
        save.layer.cornerRadius = 0.5 * save.bounds.size.width
        save.clipsToBounds = true
        let btnbackgroundColor = UIColor{(traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor(red: 0.20, green: 0.31, blue: 0.25, alpha: 1.00)
            case .dark:
                return UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
            default:
                fatalError()
            }
        }
        save.backgroundColor = btnbackgroundColor
        
        //user database
        userdb = Firestore.firestore()
        
        super.viewDidLoad()
    }
    
    func signup(email: String, password: String)
    {
        Auth.auth().createUser(withEmail: email, password: password, completion:
        {(user,error) in
            if error != nil
            {
                self.displayAlert(title: "create account error", message: (error?.localizedDescription)!)
            }
            else
            {
                //SIGN UP
                //print("created.")
                self.performSegue(withIdentifier: "signup", sender: self)
            }
        })
    }
    
    //error alert
    func displayAlert(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController,animated: true,completion: nil)
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
    
    func addData(username:String,usermobile:String,useremail:String,userpassword:String,useraddress:String)
    {
        let userinfo = userdb.collection("user")
        userinfo.document(useremail).setData([
        "name": username,
        "mobile": usermobile,
        "email": useremail,
        "password": userpassword,
        "address": useraddress,
        "ordernum":0])
    }
}
