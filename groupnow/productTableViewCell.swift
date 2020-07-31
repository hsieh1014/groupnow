import UIKit
class productTableViewCell: UITableViewCell
{

    @IBOutlet weak var homePageProduct: UIImageView!
    @IBOutlet weak var homePageProductName: UILabel!
    @IBOutlet weak var homePageMember: UILabel!
    @IBOutlet weak var homePageTotalMember: UILabel!
    @IBOutlet weak var homePageView: UIView!
    @IBOutlet weak var slash: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
