import UIKit
import Firebase
import FirebaseStorage
class cartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //user
    //set user database
    var userdb: Firestore!
    //product
    var ref: DatabaseReference?
    var ref2: DatabaseReference?
    var databasehandle: DatabaseHandle?
    var Order = [orderModel]()
    var ordernum: Int!
    var buyList = [String]()
    @IBOutlet weak var order: UITableView!
    
    @IBOutlet weak var totalprice: UILabel!
    var priceCount = 0
    @IBOutlet weak var paybtn: UIButton!
    @IBAction func pay(_ sender: Any)  //send order to orderpage
    {
        //add order to user database
        userdb.collection("user").whereField("email", isEqualTo: usercheck).getDocuments
        {(querySnapshot, error) in
            if let querySnapshot = querySnapshot
            {
                for document in querySnapshot.documents
                {
                    self.ordernum = document.data()["ordernum"] as? Int
                    for count in self.buyList
                    {
                        self.ordernum = self.ordernum! + 1
                        let ordercount = "order" + String(self.ordernum)
                        let userinfo = self.userdb.collection("user")
                        userinfo.document(usercheck).setData([ordercount:count], merge: true)
                        let d = querySnapshot.documents.first
                        d?.reference.updateData(["ordernum": self.ordernum!], completion: { (error) in })
                    }
                }
            }
        }
        
        //change membeer total number
        for list in buyList
        {
            //from order database
            ref2 = Database.database().reference().child("order").child(user).child(list)
            self.ref2?.runTransactionBlock{(currentData: MutableData) -> TransactionResult in
                if var data = currentData.value as? [String: Any]
                {
                    let countString = data["productmember"]!
                    var countInt : Int = (countString as AnyObject).integerValue
                    countInt = countInt+1
                    data["productmember"] = String(countInt)
                    currentData.value = data
                }
                return TransactionResult.success(withValue: currentData)
            }
            
            //from product database
            ref2 = Database.database().reference().child("product").child(list)
            self.ref2?.runTransactionBlock{(currentData: MutableData) -> TransactionResult in
                var data = currentData.value as? [String: Any]
                let countString = data!["member"]!
                var countInt : Int = (countString as AnyObject).integerValue
                countInt = countInt+1
                data!["member"] = String(countInt)
                currentData.value = data
                let member = data!["member"]
                let total = data!["totalmember"]
                if self.isEqual(type: String.self, a: member!, b: total!) //equal
                {
                    self.ref2?.removeValue()
                }
                return TransactionResult.success(withValue: currentData)
            }
            

        }
    }
    
    func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool
    {
        guard let a = a as? T, let b = b as? T else { return false }
        return a == b
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cart",for:indexPath) as! cartTableViewCell
        let orders : orderModel
        orders = Order[indexPath.row]
        cell.productNameCart.text = orders.productname
        cell.productPriceCart.text = orders.productprice
        cell.productMemberCart.text = orders.productmember
        cell.productTotalCart.text = orders.producttotalmember
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
                cell.productImageCart.image = image
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            let orders : orderModel
            orders = Order[indexPath.row]
            if let index = buyList.firstIndex(of: orders.productid!)
            {
                buyList.remove(at: index)
            }
            priceCount = priceCount - Int(orders.productprice!)!
            totalprice.text = String(priceCount)
        }
        else  //select
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            let orders : orderModel
            orders = Order[indexPath.row]
            buyList.append(orders.productid!)
            priceCount = priceCount + Int(orders.productprice!)!
            totalprice.text = String(priceCount)
        }
    }

    override func viewDidLoad()
    {
        paybtn.layer.cornerRadius = 0.5 * paybtn.bounds.size.width
        paybtn.clipsToBounds = true
        paybtn.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 65/255, alpha: 1)

        ref = Database.database().reference().child("order").child(user)
        ref?.observe(DataEventType.value, with:
        {(snapshot) in
            if snapshot.childrenCount > 0
            {
                self.Order.removeAll()
                for i in snapshot.children.allObjects as![DataSnapshot]
                {
                    let orderObject = i.value as? [String: AnyObject]
                    let productId = orderObject?["productid"]
                    let productName = orderObject?["productname"]
                    let productPrice = orderObject?["productprice"]
                    let productMember = orderObject?["productmember"]
                    let productTotalMember = orderObject?["producttotalmember"]
                    let p = orderModel(id: productId as? String,name: productName  as? String, price: productPrice  as? String, member: productMember  as? String,totalmember: productTotalMember as? String)
                    self.Order.append(p)
                }
                self.order.reloadData()
            }
        })
        
        //user database
        userdb = Firestore.firestore()
        
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "gotoOrder"
        {
            let controller1 = segue.destination as? orderViewController
            controller1?.alreadypayorder = buyList
        }
    }
}
