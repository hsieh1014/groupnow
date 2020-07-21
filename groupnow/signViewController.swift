import UIKit

class signViewController: UIViewController
{

    @IBOutlet weak var signinBtn: UIButton!
    
    override func viewDidLoad()
    {
        signinBtn.layer.cornerRadius = 0.5 * signinBtn.bounds.size.width
        signinBtn.clipsToBounds = true
        signinBtn.backgroundColor = UIColor(red: 58/255, green: 90/255, blue: 64/255, alpha: 1)
        super.viewDidLoad()
    }


}

