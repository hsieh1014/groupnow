import UIKit
import FirebaseAuth
class loginViewController: UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signinBtn: UIButton!
    @IBAction func signin(_ sender: Any)
    {
        if emailTextField.text != "" && passwordTextField.text != ""
        {
            authService(email: emailTextField.text!, password: passwordTextField.text!)
            usercheck = emailTextField.text!
        }
        else
        {
            print("try again")
            displayAlert(title: "error", message: "Please entry your email and password.")
        }
    }
    
    
    override func viewDidLoad()
    {
        signinBtn.layer.cornerRadius = 0.5 * signinBtn.bounds.size.width
        signinBtn.clipsToBounds = true
        signinBtn.backgroundColor = UIColor(red: 58/255, green: 90/255, blue: 64/255, alpha: 1)
        
        super.viewDidLoad()
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
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?)
    {
        if segue.identifier == "signin"
        {
        }
    }
}
