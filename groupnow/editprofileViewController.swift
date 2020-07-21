import UIKit
import Firebase

class editprofileViewController: UIViewController
{
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
        //save Btn
        saveBtnEdit.layer.cornerRadius = 0.5 * saveBtnEdit.bounds.size.width
        saveBtnEdit.clipsToBounds = true
        saveBtnEdit.backgroundColor = UIColor(red: 58/255, green: 90/255, blue: 64/255, alpha: 1)
        
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
