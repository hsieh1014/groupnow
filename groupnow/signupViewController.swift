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
        //save Btn
        save.layer.cornerRadius = 0.5 * save.bounds.size.width
        save.clipsToBounds = true
        save.backgroundColor = UIColor(red: 58/255, green: 90/255, blue: 64/255, alpha: 1)
        
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
