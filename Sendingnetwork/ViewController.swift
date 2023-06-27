//
//  ViewController.swift
//  Sendingnetwork
//
//  Created by chenghao on 2023/1/15.
//

import Cocoa
import Radixmobile

class ViewController: NSViewController {
    
    private var dendrite: RadixmobileRadixMonolith?
    private var timer: Timer?
    
    @IBOutlet weak var serverLable: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.serverLable.cell?.title = "server status"
//        if (@available(macOS 10.14, *)) {
//            NSWorkspace.shared.open(NSURL.init(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") as! URL)
//        }
        // opend privacy
//        NSWorkspace.shared.open(NSURL.init(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")! as URL)
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startServer(_ sender: Any) {
//        var process = Process()
//        Process.launchedProcess(launchPath: "/Users/chenghao/Developer/Sendingnetwork/Sendingnetwork/dendrite-libp2p", arguments: [])
        if dendrite == nil {

            guard let storageDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                fatalError("can't get document directory")
            }
            guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                fatalError("can't get caches directory")
            }


            NSLog("Storage directory: \(storageDirectory)")
            NSLog("Cache directory: \(cachesDirectory)")

            self.dendrite = RadixmobileRadixMonolith()
            self.dendrite?.storageDirectory = storageDirectory.path
            self.dendrite?.cacheDirectory = cachesDirectory.path
            if DendriteSettings.shared.testMode {
                self.dendrite?.testNet = true
            }

            if DendriteSettings.shared.p2pEnableStaticPeer {
                self.setStaticPeer(DendriteSettings.shared.p2pStaticPeerURI)
            } else {
                self.setStaticPeer("")
            }
            self.setMulticastEnabled(!DendriteSettings.shared.p2pDisableMulticast)
            self.dendrite?.start()
        } else {
            self.dendrite?.start()
        }
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.printPeers), userInfo: nil, repeats: true)
        }
        self.timer?.fire()
        self.serverLable.cell?.title = "server open"
    }
    
    @objc private func printPeers() {
//        let peers = self.dendrite?.peerCount()
//        let addrs = self.dendrite?.hostAddrs()
//        NSLog("Dendrite connected to \(peers ?? 0) peers, addrs: \(addrs ?? "")")
        keepHealth()
    }
    
    @objc private func keepHealth() {
        let destUrl:URL = URL(string: "http://127.0.0.1:65432/_api/client/monitor/health")!
        let session = URLSession.shared
        var request = URLRequest(url: destUrl)
        request.httpMethod = "GET"
        //请求头参数
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let task: URLSessionDataTask = session.dataTask(with: request) {[weak self] data, response, error in
            guard let self = self else { return }
            guard error == nil, let data:Data = data, let httpResponse :HTTPURLResponse = response as? HTTPURLResponse else {
//                print("server已经断开：\(error!.localizedDescription)")
                debugPrint("server disconnect")
                self.dendrite?.start()
                return
            }
            if httpResponse.statusCode != 200 {
                debugPrint("server disconnect")
                self.dendrite?.start()
                return
            }
            
//            let dataStr = String(data: data, encoding: String.Encoding.utf8)!
//            let dict = self.getDictionaryFromJSONString(jsonString: dataStr)
            print("server connecting =\(destUrl)\(httpResponse.statusCode)")
//            print("GET请求结果：\(dict)")
        }
        //开始请求
        task.resume()
    }
    
    @IBAction func stopServer(_ sender: Any) {
        if self.dendrite != nil {
            self.dendrite?.stop()
        }
        self.timer?.invalidate()
        self.timer = nil
        self.serverLable.cell?.title = "server close"
    }
    
    @objc public func setMulticastEnabled(_ enabled: Bool) {
        guard self.dendrite != nil else { return }
        guard let dendrite = self.dendrite else { return }
        dendrite.setMulticastEnabled(enabled)
    }
    
    @objc public func setStaticPeer(_ uri: String) {
        guard self.dendrite != nil else { return }
        guard let dendrite = self.dendrite else { return }
        dendrite.setStaticPeer(uri.trimmingCharacters(in: .whitespaces))
    }
}

