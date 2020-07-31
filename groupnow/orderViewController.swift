import UIKit
import Firebase
class orderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //nav
    @IBOutlet weak var nav: UINavigationBar!
    
    var ref : DatabaseReference?
    var databasehandle : DatabaseHandle?
    var alreadypayorder = [String]()
    var Buylist = [orderModel]()
    @IBOutlet weak var orderlist: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Buylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"order",for:indexPath) as! orderTableViewCell
        let orders : orderModel
        orders = Buylist[indexPath.row]
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
        cell.backgroundColor = backgroundColor
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
        cell.orderview.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.00)
        cell.orderpageName.text = orders.productname
        cell.orderpageName.textColor = labelbackgroundColor
        cell.orderpagePrice.text = orders.productprice
        cell.orderpagePrice.textColor = labelbackgroundColor
        cell.orderpagemember.text = orders.productmember
        cell.orderpagemember.textColor = labelbackgroundColor
        cell.orderpageTotal.text = orders.producttotalmember
        cell.orderpageTotal.textColor = labelbackgroundColor
        cell.slash.textColor = labelbackgroundColor
        let storageRef = Storage.storage().reference(forURL: "gs://groupnow-14e0a.appspot.com/")
        var imageName = "product/"
        imageName.append(orders.productid!)
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
                cell.orderpageImage.image = image
            }
        }
        return cell
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
        
        //nav
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
        nav.tintColor = labelbackgroundColor
        
        //show already pay
        ref = Database.database().reference().child("order").child(user)
        ref?.observe(DataEventType.value, with:
        {(snapshot) in
            if snapshot.childrenCount > 0
            {
                self.Buylist.removeAll()
                for i in snapshot.children.allObjects as![DataSnapshot]
                {
                    let orderObject = i.value as? [String: AnyObject]
                    let productId = orderObject?["productid"]
                    let productName = orderObject?["productname"]
                    let productPrice = orderObject?["productprice"]
                    let productMember = orderObject?["productmember"]
                    let productTotalMember = orderObject?["producttotalmember"]
                    if self.alreadypayorder.contains(productId as! String)
                    {
                        let p = orderModel(id: productId as? String,name: productName  as? String, price: productPrice  as? String, member: productMember  as? String,totalmember: productTotalMember as? String)
                        self.Buylist.append(p)
                    }
                }
                self.orderlist.reloadData()
            }
        })
        super.viewDidLoad()
    }
}
