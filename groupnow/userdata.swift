import Foundation
import Firebase

class userinfo
{
    //set user database
    var userdb: Firestore!

    //add data to user database
    func addData(username:String,usermobile:String,useremail:String,userpassword:String,useraddress:String)
    {
        let userinfo = userdb.collection("user")
        userinfo.document(useremail).setData([
        "name": username,
        "mobile": usermobile,
        "email": useremail,
        "password": userpassword,
        "address": useraddress])
    }
}
