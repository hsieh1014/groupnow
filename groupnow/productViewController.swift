import UIKit
import Firebase
import FirebaseStorage
class productViewController: UIViewController
{
    var name : String?
    var id : String?
    var price : String?
    var detail : String?
    var memberNum : String?
    var totalmember : String?
    
    @IBOutlet weak var productimage: UIImageView!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var productprice: UILabel!
    @IBOutlet weak var productdetail: UILabel!
    @IBOutlet weak var productmember: UILabel!
    @IBOutlet weak var producttotalmember: UILabel!
    
    var ref: DatabaseReference!
    @IBOutlet weak var plusoneBtn: UIButton!
    @IBAction func plusone(_ sender: Any)
    {
        displayAlert(title: "成功加入購物車", message: "請至購物車結帳")
        self.ref.child(user).child(id!).setValue(["productid":  id,"productname": name,"productprice": price,"productmember": memberNum, "producttotalmember": totalmember])
        //self.performSegue(withIdentifier: "gobacktohome", sender: self)
        
    }
    
    override func viewDidLoad()
    {
        if let name = name,let detail=detail,let memberNum = memberNum,let price = price,let totalmember = totalmember,let id = id
        {
            //product image
            let storageRef = Storage.storage().reference(forURL: "gs://groupnow-14e0a.appspot.com/")
            var imageName = "product/"
            imageName.append(id)
            let storageProduct = storageRef.child(imageName)
            storageProduct.getData(maxSize: 15 * 1024 * 1024)
            {(data,error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
                else
                {
                    let image = UIImage(data: data!)
                    self.productimage.image = image
                }
            }
            
            //product name
            productname.text = name
            productname.layer.masksToBounds = true
            productname.layer.cornerRadius = 5
            
            //product price for one person
            productprice.text = price
            productprice.layer.masksToBounds = true
            productprice.layer.cornerRadius = 5
            
            //product detail
            let label = UILabel()
            label.frame = CGRect(x:100,y:430,width:220, height:0)
            label.text = detail
            label.numberOfLines = 0
            label.sizeToFit()
            productdetail.layer.masksToBounds = true
            productdetail.layer.cornerRadius = 5
            productdetail = label
            view.addSubview(label)
            
            productmember.text = memberNum
            productmember.layer.masksToBounds = true
            productmember.layer.cornerRadius = 5
            
            producttotalmember.text = totalmember
            producttotalmember.layer.masksToBounds = true
            producttotalmember.layer.cornerRadius = 5
        }
        
        //add to order
        ref = Database.database().reference().child("order")
        
        super.viewDidLoad()
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
@IBDesignable public class PaddingLabel : UILabel
{
    @IBInspectable var topInsert: CGFloat = 5
    @IBInspectable var bottomInsert: CGFloat = 5
    @IBInspectable var leftInsert: CGFloat = 15
    @IBInspectable var rightInsert: CGFloat = 5
    
    public override func drawText(in rect: CGRect)
    {
        let insets = UIEdgeInsets.init(top: topInsert, left: leftInsert, bottom: bottomInsert, right: rightInsert)
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize
    {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width+leftInsert+rightInsert, height: size.height+topInsert+bottomInsert)
    }
    
}
