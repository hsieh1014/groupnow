import UIKit
import FirebaseDatabase
import FirebaseStorage
class addViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate
{
    //nav
    @IBOutlet weak var nav: UINavigationBar!
    
    //upload product image
    var image : UIImage? = nil
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var uiview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    //set product database
    var ref : DatabaseReference!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var memberTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    var memberNum = "0"

    @IBOutlet weak var addbtn: UIButton!
    @IBAction func add(_ sender: Any)
    {
        //random ID
        let id = ref.childByAutoId().key
        
        //product database -> realtime database
        var dict : Dictionary<String,Any> = ["id": id!,
                                             "title": titleTextField.text!,
                                             "price": priceTextField.text!,
                                             "totalmember": memberTextField.text!,
                                             "detail":detailTextView.text!,
                                             "member":memberNum,
                                             "url": ""]
        ref.child("product").child(id!).updateChildValues(dict,withCompletionBlock: {
            (error,ref) in
            if error == nil
            {
                return
            }
        })
        
        //image -> storage
        guard let imageSelected = self.image else
        {
            print("error")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else
        {
            return
        }

        let storageRef = Storage.storage().reference(forURL: "gs://groupnow-14e0a.appspot.com/")
        let storageProduct = storageRef.child("product").child(id!)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProduct.putData(imageData, metadata: metadata, completion:
        {(storageMetaData,error) in
            if error != nil
            {
                print(error!.localizedDescription)
                return
            }
            storageProduct.downloadURL(completion: {(url,error) in
                if let metaImageUrl = url?.absoluteString
                {
                    dict["url"] = metaImageUrl
                    self.ref.child("product").child(id!).updateChildValues(["url": metaImageUrl])
                }
            })
        })
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
        uiview.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.00)
        
        //nav
        let navbackgroundColor = UIColor{(traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor(red: 0.20, green: 0.31, blue: 0.25, alpha: 1.00)
            case .dark:
                return UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
            default:
                fatalError()
            }
        }
        nav.tintColor = navbackgroundColor
        
        detailTextView.layer.cornerRadius = 5 
        //product database
        ref = Database.database().reference()
        selectpic()
        
        //add btn
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
        addbtn.layer.cornerRadius = 0.5 * addbtn.bounds.size.width
        addbtn.clipsToBounds = true
        addbtn.backgroundColor = labelbackgroundColor
        
        titleLabel.textColor = labelbackgroundColor
        priceLabel.textColor = labelbackgroundColor
        memberLabel.textColor = labelbackgroundColor
        detailLabel.textColor = labelbackgroundColor
        
        titleTextField.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.92, alpha: 1.00)
        priceTextField.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.92, alpha: 1.00)
        memberTextField.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.92, alpha: 1.00)
        detailTextView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.92, alpha: 1.00)
        
        titleTextField.textColor = UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 1.00)
        priceTextField.textColor = UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 1.00)
        memberTextField.textColor = UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 1.00)
        detailTextView.textColor = UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 1.00)
        
        titleTextField.delegate = self
        detailTextView.delegate = self
        
        super.viewDidLoad()
    }
    
    //Set the maximum character length of a TextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        return textView.text.count + (text.count - range.length) <= 10
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
    
    //go to select picture
    func selectpic()
    {
        productImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        productImage.addGestureRecognizer(tapGesture)
    }
    @objc func presentPicker()
    {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker,animated: true,completion: nil)
    }
}
extension addViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image = imageSelected
            productImage.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = imageOriginal
            productImage.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
