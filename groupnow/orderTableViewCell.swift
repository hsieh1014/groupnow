import UIKit
class orderTableViewCell: UITableViewCell
{

    @IBOutlet weak var orderpageImage: UIImageView!
    @IBOutlet weak var orderpageName: UILabel!
    @IBOutlet weak var orderpagePrice: UILabel!
    @IBOutlet weak var orderpagemember: UILabel!
    @IBOutlet weak var orderpageTotal: UILabel!
    @IBOutlet weak var orderpageStatus: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
