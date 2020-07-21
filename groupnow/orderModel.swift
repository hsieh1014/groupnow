class orderModel
{
    var productid : String?
    var productname : String?
    var productprice : String?
    var productmember : String?
    var producttotalmember : String?
    
    init(id : String?,name : String?, price : String?, member : String?, totalmember : String?)
    {
        self.productid = id
        self.productname = name
        self.productprice = price
        self.productmember = member
        self.producttotalmember = totalmember
    }
}
