import UIKit

class resultTableViewCell: UITableViewCell
{

    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultName: UILabel!
    @IBOutlet weak var resultPrice: UILabel!
    @IBOutlet weak var resulttotalmember: UILabel!
    @IBOutlet weak var resultmember: UILabel!
    @IBOutlet weak var resultview: UIView!
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
