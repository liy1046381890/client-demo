//
//  HomeViewController.swift
//  myappp
//
//  Created by lucian on 2020/8/6.
//  Copyright © 2020年 lucian. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var ipTextField: UITextField!
    
    @IBOutlet weak var macTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupElements()
        
        Thread.detachNewThreadSelector(#selector(self.getInfo), toTarget: self, with: nil)
    }
    
    func setupElements() {
        errorLabel.alpha = 0
        Utils.styleView(image: "home", viewController: self)
        Utils.styleTextField(textField: ipTextField)
        Utils.styleTextField(textField: macTextField)
        Utils.styleHollowButton(button: loginOutButton)
    }
    
    
    // 获取设	备IP  Mac
    func getInfo() {
        ipTextField.placeholder = ipAddress
        macTextField.placeholder = macAddress
    }
    
    
    public var ipAddress: String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }
 

    
    public var macAddress: String{
        let index  = Int32(if_nametoindex("en0"))
        let bsdData = "en0".data(using: String.Encoding.utf8)!
        var mib : [Int32] = [CTL_NET,AF_ROUTE,0,AF_LINK,NET_RT_IFLIST,index]
        var len = 0;
        
        if sysctl(&mib,UInt32(mib.count), nil, &len,nil,0) < 0 {
            return "00:00:00:00:00:00"
        }
        
        var buffer = [CChar](repeating: 0, count: len)
        if sysctl(&mib, UInt32(mib.count), &buffer, &len, nil, 0) < 0 {
            return "00:00:00:00:00:00"
        }
        
        let infoData = NSData(bytes: buffer, length: len)
        var interfaceMsgStruct = if_msghdr()
        infoData.getBytes(&interfaceMsgStruct, length: MemoryLayout<if_msghdr>.size)
        let socketStructStart = MemoryLayout<if_msghdr>.size + 1
        let socketStructData = infoData.subdata(with: NSMakeRange(socketStructStart, len - socketStructStart))
        let rangeOfToken = socketStructData.range(of: bsdData, options: NSData.SearchOptions(rawValue: 0), in: NSMakeRange(0, socketStructData.count).toRange())
        let macAddressData = socketStructData.subdata(in: NSMakeRange((rangeOfToken?.count)! + 3, 6).toRange()!)
        var macAddressDataBytes = [UInt8](repeating: 0, count: 6)
        macAddressData.copyBytes(to: &macAddressDataBytes, count: 6)
        return macAddressDataBytes.map({ String(format:"%02x", $0) }).joined(separator: ":")  
    }
    
    
    func navigateToLogin() {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as? LoginViewController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func loginOutTapped(_ sender: AnyObject) {
        self.navigateToLogin()
    }
}
