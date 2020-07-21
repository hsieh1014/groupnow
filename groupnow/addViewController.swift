import UIKit
import FirebaseDatabase
import FirebaseStorage
class addViewController: UIViewController
{
    //upload product image
    var image : UIImage? = nil
    @IBOutlet weak var productImage: UIImageView!
    
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
        detailTextView.layer.cornerRadius = 5 
        //product database
        ref = Database.database().reference()
        selectpic()
        
        //add btn
        addbtn.layer.cornerRadius = 0.5 * addbtn.bounds.size.width
        addbtn.clipsToBounds = true
        addbtn.backgroundColor = UIColor(red: 58/255, green: 90/255, blue: 64/255, alpha: 1)
        
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
