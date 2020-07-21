import UIKit
import Firebase
import FirebaseStorage
class searchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate
{
    @IBOutlet weak var result: UITableView!

    var filterDataList = [String]()  //search result
    var group = [String]()
    var isShowSearchResult: Bool = false
    var searchController: UISearchController!
    
    //product
    var ref : DatabaseReference?
    var databasehandle : DatabaseHandle?
    var Product = [productModel]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isShowSearchResult  //true
        {
            return Product.count
        }
        else  //false
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"result",for:indexPath) as! resultTableViewCell
        if isShowSearchResult
        {
            let products : productModel
            products = Product[indexPath.row]
            cell.resultName.text = products.name
            cell.resultPrice.text = products.price
            cell.resultmember.text = products.member
            cell.resulttotalmember.text = products.totalmember
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
                    cell.resultImage.image = image
                }
            }
        }
        return cell
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
    
    //entry input
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchController.searchBar.resignFirstResponder()
    }
    
    //when typing things
    func updateSearchResults(for searchController: UISearchController)
    {
        //search bar input
        let searchString = searchController.searchBar.text!
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
                    if productName!.contains(searchString)
                    {
                        self.Product.append(p)
                        self.isShowSearchResult = true
                    }
                }
                self.result.reloadData()
            }
        })
    }
    
    override func viewDidLoad()
    {
        //SearchController
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.result.tableHeaderView = self.searchController.searchBar
        
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "resultToProduct"
        {
            let controller1 = segue.destination as? productViewController
            let indexPath = self.result.indexPathForSelectedRow
            controller1?.name = Product[indexPath!.row].name
            controller1?.price = Product[indexPath!.row].price
            controller1?.detail = Product[indexPath!.row].detail
            controller1?.memberNum = Product[indexPath!.row].member
            controller1?.totalmember = Product[indexPath!.row].totalmember
            controller1?.id = Product[indexPath!.row].id
        }
    }
}
