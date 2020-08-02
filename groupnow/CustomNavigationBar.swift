import UIKit
class CustomNavigationBar: UINavigationBar
{
    var customHeight : CGFloat = 64
  
    override func sizeThatFits(_ size: CGSize) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.width, height: customHeight)
    }
  
    override func layoutSubviews()
    {
        super.layoutSubviews()
        //let y = UIApplication.shared.statusBarFrame.height
        frame = CGRect(x: frame.origin.x, y:  frame.origin.y, width: frame.size.width, height: customHeight)
      
        for subview in self.subviews
        {
            var stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarBackground")
            {
                subview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: customHeight)
                subview.backgroundColor = self.backgroundColor
            }
          
            stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarContent")
            {
                subview.frame = CGRect(x: subview.frame.origin.x, y: 20, width: subview.frame.width, height: customHeight)
                subview.backgroundColor = self.backgroundColor
            }
        }
    }
}
