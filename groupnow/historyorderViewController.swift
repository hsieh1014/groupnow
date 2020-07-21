import UIKit
class historyorderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"historyorder",for:indexPath) as! historyorderTableViewCell
        return cell
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}
