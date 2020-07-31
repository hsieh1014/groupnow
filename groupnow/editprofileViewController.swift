import UIKit
import Firebase

class editprofileViewController: UIViewController
{
    //label
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    //textfield
    @IBOutlet weak var nameEditTextField: UITextField!
    @IBOutlet weak var mobileEditTextField: UITextField!
    @IBOutlet weak var passwordEditTextField: UITextField!
    @IBOutlet weak var addressEditTextField: UITextField!
    //firebase
    var userdb: Firestore!
    var checkuser : String!
    //save btn
    @IBOutlet weak var saveBtnEdit: UIButton!
    @IBAction func EditToSave(_ sender: Any)
    {
        self.performSegue(withIdentifier: "gobackProfile", sender: self)
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
        
        let labelbackgroundColor = UIColor{(traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor(red: 0.20, green: 0.31, blue: 0.25, alpha: 1.00)
            case .dark:
                return UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
            default:
                fatalError()
            }
        }
        
        //save Btn
        saveBtnEdit.layer.cornerRadius = 0.5 * saveBtnEdit.bounds.size.width
        saveBtnEdit.clipsToBounds = true
        saveBtnEdit.backgroundColor = labelbackgroundColor
        
        //label
        nameLabel.textColor = labelbackgroundColor
        mobileLabel.textColor = labelbackgroundColor
        passwordLabel.textColor = labelbackgroundColor
        addressLabel.textColor = labelbackgroundColor
        
        //textfield
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
        nameEditTextField.backgroundColor = textfieldbackgroundColor
        mobileEditTextField.backgroundColor = textfieldbackgroundColor
        passwordEditTextField.backgroundColor = textfieldbackgroundColor
        addressEditTextField.backgroundColor = textfieldbackgroundColor
        nameEditTextField.textColor = labelbackgroundColor
        mobileEditTextField.textColor = labelbackgroundColor
        passwordEditTextField.textColor = labelbackgroundColor
        addressEditTextField.textColor = labelbackgroundColor
        
        super.viewDidLoad()
    }
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?)
    {
        if segue.identifier == "gobackProfile"
        {
            let controller = segue.destination as! profileViewController
            controller.updateName = nameEditTextField.text!
            controller.updatemobile = mobileEditTextField.text!
            controller.updatepassword = passwordEditTextField.text!
            controller.updateaddress = addressEditTextField.text!
        }
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
}
