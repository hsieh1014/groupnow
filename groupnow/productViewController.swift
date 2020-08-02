import UIKit
import Firebase
import FirebaseStorage
class productViewController: UIViewController
{
    @IBOutlet weak var productview: UIView!
    @IBOutlet weak var nav: UINavigationBar!
    
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
    @IBOutlet weak var slash: UILabel!
    
    var ref: DatabaseReference!
    @IBOutlet weak var plusoneBtn: UIButton!
    @IBAction func plusone(_ sender: Any)
    {
        displayAlert(title: "成功加入購物車", message: "請至購物車結帳")
        self.ref.child(user).child(id!).setValue(["productid":  id,"productname": name,"productprice": price,"productmember": memberNum, "producttotalmember": totalmember])
        
    }
    
    override func viewDidLoad()
    {
//        if #available(iOS 11.0, *)
//        {
//             self.additionalSafeAreaInsets.top = 20
//        }
        //navigation
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
        let height = CGFloat(72)
        nav.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        
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
        let viewbackgroundColor = UIColor{(traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor(red: 1, green: 1, blue: 1, alpha: 1.00)
            case .dark:
                return UIColor(red: 1, green: 1, blue: 1, alpha: 1.00)
            default:
                fatalError()
            }
        }
        productview.backgroundColor = viewbackgroundColor
        
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
            
            //product info
            let labelbackgroundColor = UIColor{(traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .light:
                    return UIColor(red: 0.64, green: 0.69, blue: 0.54, alpha: 1.00)
                case .dark:
                    return UIColor(red: 0.64, green: 0.64, blue: 0.64, alpha: 1.00)
                default:
                    fatalError()
                }
            }
            //product name
            productname.text = name
            productname.layer.masksToBounds = true
            productname.layer.cornerRadius = 5
            productname.backgroundColor = labelbackgroundColor
            
            //product price for one person
            productprice.text = price
            productprice.layer.masksToBounds = true
            productprice.layer.cornerRadius = 5
            productprice.backgroundColor = labelbackgroundColor
            
            //product detail
            let label = UILabel()
            label.frame = CGRect(x:100,y:430,width:220, height:150)
            label.text = detail
            productdetail.backgroundColor = labelbackgroundColor
            label.numberOfLines = 0
            label.sizeToFit()
            productdetail.layer.masksToBounds = true
            productdetail.layer.cornerRadius = 5
            productdetail = label
            view.addSubview(label)
            
            productmember.text = memberNum
            productmember.layer.masksToBounds = true
            productmember.layer.cornerRadius = 5
            productmember.backgroundColor = labelbackgroundColor
            
            slash.backgroundColor = labelbackgroundColor
            
            producttotalmember.text = totalmember
            producttotalmember.layer.masksToBounds = true
            producttotalmember.layer.cornerRadius = 5
            producttotalmember.backgroundColor = labelbackgroundColor
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
