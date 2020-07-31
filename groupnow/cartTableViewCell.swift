import UIKit
class cartTableViewCell: UITableViewCell
{
    @IBOutlet weak var productImageCart: UIImageView!
    @IBOutlet weak var productNameCart: UILabel!
    @IBOutlet weak var productPriceCart: UILabel!
    @IBOutlet weak var productMemberCart: UILabel!
    @IBOutlet weak var productTotalCart: UILabel!
    @IBOutlet weak var productview: UIView!
    @IBOutlet weak var slash: UILabel!
    @IBOutlet weak var ntd: UILabel!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var checkbtn: UIButton!
    @IBAction func check(_ sender: Any)
    {
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
