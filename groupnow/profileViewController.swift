import UIKit
import Firebase
import FirebaseStorage

class profileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    //user database
    var userdb: Firestore!
    
    //label
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabelProfile: UILabel!
    @IBOutlet weak var mobileLabelProfile: UILabel!
    @IBOutlet weak var emailLabelProfile: UILabel!
    @IBOutlet weak var addressLabelProfile: UILabel!
    
    //nav
    @IBOutlet weak var nav: UINavigationBar!
    
    
    //edit and update
    @IBOutlet weak var editbtn: UIButton!
    var updateName = ""
    var updatemobile = ""
    var updatepassword = ""
    var updateaddress = ""
    @IBAction func gotoEdit(_ sender: Any)
    {
        self.performSegue(withIdentifier: "gotoEdit", sender: self)
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
        
        //edit Btn
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
        editbtn.layer.cornerRadius = 0.5 * editbtn.bounds.size.width
        editbtn.clipsToBounds = true
        editbtn.backgroundColor = labelbackgroundColor
        
        
        //userdatabase
        userdb = Firestore.firestore()
        if updateName != ""
        {
            userdb.collection("user").whereField("email",isEqualTo: usercheck).getDocuments
            {(querySnapshot, error) in
                if let querySnapshot = querySnapshot
                {
                    let document = querySnapshot.documents.first
                    document?.reference.updateData(["name": self.updateName], completion: { (error) in })
                }
            }
            //read the original order database
            
            //put data in the new database
            
            //delete the old one
        }
        if updatemobile != ""
        {
            userdb.collection("user").whereField("email",isEqualTo: usercheck).getDocuments
            {(querySnapshot, error) in
                if let querySnapshot = querySnapshot
                {
                    let document = querySnapshot.documents.first
                    document?.reference.updateData(["mobile": self.updatemobile], completion: { (error) in })
                }
            }
            
        }
        if updatepassword != ""
        {
            userdb.collection("user").whereField("email",isEqualTo: usercheck).getDocuments
            {(querySnapshot, error) in
                if let querySnapshot = querySnapshot
                {
                    let document = querySnapshot.documents.first
                    document?.reference.updateData(["password": self.updatepassword], completion: { (error) in })
                }
            }
            
        }
        if updateaddress != ""
        {
            print(updateaddress)
            userdb.collection("user").whereField("email",isEqualTo: usercheck).getDocuments
            {(querySnapshot, error) in
                if let querySnapshot = querySnapshot
                {
                    let document = querySnapshot.documents.first
                    document?.reference.updateData(["address": self.updateaddress], completion: { (error) in })
                }
            }
        }
        userdb.collection("user").whereField("email", isEqualTo: usercheck).getDocuments
        {(querySnapshot, error) in
            if let querySnapshot = querySnapshot
            {
                for document in querySnapshot.documents
                {
                    var username : String!
                    var usermobile : String!
                    var useremail : String!
                    var useraddress : String!
                    if self.updateName == ""
                    {
                        username = (document.data()["name"] as! String)
                    }
                    else
                    {
                        username = self.updateName
                    }
                    
                    if self.updatemobile == ""
                    {
                        usermobile = (document.data()["mobile"] as! String)
                    }
                    else
                    {
                        usermobile = self.updatemobile
                    }
                    
                    if self.updateaddress == ""
                    {
                        useraddress = (document.data()["address"] as! String)
                    }
                    else
                    {
                        useraddress = self.updateaddress
                    }
                    
                    useremail = (document.data()["email"] as! String)
                    
                    self.nameLabelProfile.text = username
                    self.mobileLabelProfile.text = usermobile
                    self.emailLabelProfile.text = useremail
                    self.addressLabelProfile.text = useraddress
                }
            }
        }
        
        //Label
        nameLabelProfile.textColor = labelbackgroundColor
        mobileLabelProfile.textColor = labelbackgroundColor
        emailLabelProfile.textColor = labelbackgroundColor
        addressLabelProfile.textColor = labelbackgroundColor
        nameLabel.textColor = labelbackgroundColor
        mobileLabel.textColor = labelbackgroundColor
        emailLabel.textColor = labelbackgroundColor
        addressLabel.textColor = labelbackgroundColor
        
        //nav
        nav.tintColor = labelbackgroundColor
        
        super.viewDidLoad()
    }
}

