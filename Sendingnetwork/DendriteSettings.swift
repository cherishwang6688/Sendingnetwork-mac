//
//  File.swift
//  
//
//  Created by octopus on 2022/7/14.
//

import Foundation

public class DendriteSettings {
    
    // MARK: - Constants
    
    private enum UserDefaultsKeys {
        static let p2pDisableMulticast = "p2pDisableMulticast"
        static let p2pEnableStaticPeer = "p2pEnableStaticPeer"
        static let p2pStaticPeerURI = "p2pStaticPeerURI"
        static let p2pPassword = "p2pPassword"
        static let walletMnemonic = "walletMnemonic"
    }
    
    public static let shared = DendriteSettings()
    
    //是否是测试模式
    public let testMode : Bool = false
    
    /// UserDefaults to be used on reads and writes.
    private lazy var defaults: UserDefaults = {
        UserDefaults.standard.register(defaults: [
            UserDefaultsKeys.p2pEnableStaticPeer: true,
        ])
        return UserDefaults.standard
    }()
    
    // MARK: P2P
    public var p2pDisableMulticast: Bool {
        get {
            return defaults.bool(forKey: UserDefaultsKeys.p2pDisableMulticast)
        } set {
            defaults.set(newValue, forKey: UserDefaultsKeys.p2pDisableMulticast)
        }
    }
    
    public var p2pEnableStaticPeer: Bool {
        get {
            return defaults.bool(forKey: UserDefaultsKeys.p2pEnableStaticPeer)
        } set {
            defaults.set(newValue, forKey: UserDefaultsKeys.p2pEnableStaticPeer)
        }
    }
    
    public var p2pStaticPeerURI: String {
        get {
            if testMode {
                return "/ip4/111.200.195.194/tcp/8082/ws/p2p/12D3KooWEbqSC2vSudddmPARBK1nbypStxvo9wWGoqhzrBRc7N1e,/ip4/47.122.17.23/tcp/8081/p2p/12D3KooWJaTahvj7arN6DSoq8bBoDMqSY5f3ubTyASNGDMxd8gm2,/ip4/47.122.17.23/tcp/9086/p2p/12D3KooWEK2jA9hFSrSp8EqbWfqAXoCZXNAfVNZccuUpUZV1CGsD"
            } else {
                return defaults.string(forKey: UserDefaultsKeys.p2pStaticPeerURI) ?? "/ip4/121.199.61.97/tcp/8081/p2p/12D3KooWP3STR5z5EZRtrQR8iFR3FaxGz4hESbFVUd4LfCEbV1yc,/ip4/47.99.140.8/tcp/8081/p2p/12D3KooWBY4CUxr1Ebrr6Sqjr42iRZdqpXfbjqzGpHthH1qqx1zQ"
            }
        } set {
            defaults.set(newValue, forKey: UserDefaultsKeys.p2pStaticPeerURI)
        }
    }
    
    var hasWalletMnemonic: Bool {
        return !(walletMnemonic ?? "").isEmpty
    }
    
    var walletMnemonic: String? {
        get {
            return defaults.string(forKey: UserDefaultsKeys.walletMnemonic)
        } set {
            defaults.set(newValue, forKey: UserDefaultsKeys.walletMnemonic)
        }
    }
    
    var p2pPassword: String? {
        get {
            return defaults.string(forKey: UserDefaultsKeys.p2pPassword)
        } set {
            defaults.set(newValue, forKey: UserDefaultsKeys.p2pPassword)
        }
    }
    
}
