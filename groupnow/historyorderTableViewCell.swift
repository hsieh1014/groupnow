import UIKit
class historyorderTableViewCell: UITableViewCell
{
    @IBOutlet weak var historyorderImage: UIImageView!
    @IBOutlet weak var historyorderName: UILabel!
    @IBOutlet weak var historyorderprice: UILabel!
    @IBOutlet weak var historyorderstatus: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
