import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage
class homeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    //greeting
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var greetingtitle: UILabel!
    @IBOutlet weak var greetingView: UIView!
    
    //toolbar
    @IBOutlet weak var anyToolbarButton: UIToolbar!
    
    //user database
    var userdb : Firestore!
    var useremail : String!
    var ordercount : Int = 0
    var orderlist = [String]()
    
    //product
    var ref : DatabaseReference?
    var databasehandle : DatabaseHandle?
    @IBOutlet weak var productTableView: UITableView!
    
    var Product = [productModel]()
    
    override func viewDidLoad()
    {
        
        let textbackgroundColor = UIColor{(traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor(red: 0.20, green: 0.31, blue: 0.25, alpha: 1.00)
            case .dark:
                return UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 1.00)
            default:
                fatalError()
            }
        }
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
        
        //View
        view.backgroundColor = backgroundColor
        
        //top
        greeting.textColor = textbackgroundColor
        greetingtitle.textColor = textbackgroundColor
        greetingView.backgroundColor = backgroundColor
        
        //tableview
        productTableView.dataSource = self
        productTableView.delegate = self
        
        //userdatabase
        userdb = Firestore.firestore()
        userdb.collection("user").whereField("email", isEqualTo: usercheck).getDocuments
        {(querySnapshot, error) in
            if let querySnapshot = querySnapshot
            {
                for document in querySnapshot.documents
                {
                    var username : String!
                    username = (document.data()["name"] as! String)
                    user = username
                    var hello = "Hello ! "
                    hello.append(username!)
                    self.greeting.text = hello
                }
            }
        }
        
        //product database
        ref = Database.database().reference().child("product")
        ref?.observe(DataEventType.value, with:{ (snapshot) in
            if snapshot.childrenCount > 0
            {
                self.Product.removeAll()
                for i in snapshot.children.allObjects as![DataSnapshot]
                {
                    let productObject = i.value as? [String: AnyObject]
                    let productId = productObject?["id"]
                    let productName = productObject?["title"]
                    let productPrice = productObject?["price"]
                    let productMember = productObject?["member"]
                    let productDetail = productObject?["detail"]
                    let productTotalMember = productObject?["totalmember"]
                    let productImage = productObject?["url"]
                    let p = productModel(id: productId as! String?,name: productName as! String?, price: productPrice as! String?, member: productMember as! String?, detail: productDetail as! String?, totalmember: productTotalMember as! String?,image: productImage as! String?)
                    self.Product.append(p)
                
                }
                self.productTableView.reloadData()
            }
        })
        
        //toolbar
        let barbackgroundColor = UIColor{(traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor(red: 0.20, green: 0.31, blue: 0.25, alpha: 1.00)
            case .dark:
                return UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
            default:
                fatalError()
            }
        }
        anyToolbarButton.tintColor = barbackgroundColor
        
        super.viewDidLoad()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"product",for:indexPath) as! productTableViewCell
        let products : productModel
        products = Product[indexPath.row]
        cell.homePageProductName.text = products.name
        cell.homePageProductName.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.00)
        cell.homePageMember.text = products.member
        cell.homePageMember.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.00)
        cell.homePageTotalMember.text = products.totalmember
        cell.homePageTotalMember.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.00)
        cell.slash.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.00)
        let storageRef = Storage.storage().reference(forURL: "gs://groupnow-14e0a.appspot.com/")
        var imageName = "product/"
        imageName.append(products.id!)
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
                cell.homePageProduct.image = image
            }
        }
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
        cell.homePageView.backgroundColor = viewbackgroundColor
        cell.backgroundColor = backgroundColor
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "gotoProduct"
        {
            let controller1 = segue.destination as? productViewController
            let indexPath = self.productTableView.indexPathForSelectedRow
            controller1?.name = Product[indexPath!.row].name
            controller1?.price = Product[indexPath!.row].price
            controller1?.detail = Product[indexPath!.row].detail
            controller1?.memberNum = Product[indexPath!.row].member
            controller1?.totalmember = Product[indexPath!.row].totalmember
            controller1?.id = Product[indexPath!.row].id
        }
        if segue.identifier == "gotoOrder"
        {
            let controller2 = segue.destination as? orderViewController
            userdb.collection("user").whereField("email", isEqualTo: usercheck).getDocuments
            {(querySnapshot, error) in
                if let querySnapshot = querySnapshot
                {
                    for document in querySnapshot.documents
                    {
                        var count = document.data()["ordernum"] as! Int
                        while count>0
                        {
                            var ordername = "order"
                            ordername.append(String(count))
                            self.orderlist.append(document.data()[ordername] as! String)
                            count = count - 1
                        }                    }
                }
            }
            controller2?.alreadypayorder = orderlist
        }
        
    }
    
    @IBAction func backtohomepage(segue:UIStoryboardSegue)
    {
    }
}
