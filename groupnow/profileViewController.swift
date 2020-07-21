import UIKit
import Firebase
import FirebaseStorage

class profileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    //user database
    var userdb: Firestore!
    
    //label
    @IBOutlet weak var nameLabelProfile: UILabel!
    @IBOutlet weak var mobileLabelProfile: UILabel!
    @IBOutlet weak var emailLabelProfile: UILabel!
    @IBOutlet weak var addressLabelProfile: UILabel!
    
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
        
        //edit Btn
        editbtn.layer.cornerRadius = 0.5 * editbtn.bounds.size.width
        editbtn.clipsToBounds = true
        editbtn.backgroundColor = UIColor(red: 58/255, green: 90/255, blue: 64/255, alpha: 1)
        
        
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

        super.viewDidLoad()
    }
}

