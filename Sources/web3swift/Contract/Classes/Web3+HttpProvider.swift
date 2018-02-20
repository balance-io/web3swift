//
//  Web3+Provider.swift
//  web3swift
//
//  Created by Alexander Vlasov on 19.12.2017.
//  Copyright © 2017 Bankex Foundation. All rights reserved.
//

import Foundation
import BigInt

public class Web3HttpProvider: Web3Provider {
    public var url: URL
    public var network: Networks?
    public var attachedKeystoreManager: KeystoreManager? = nil
    public init?(_ httpProviderURL: URL, network net: Networks? = nil, keystoreManager manager: KeystoreManager? = nil) {
        guard httpProviderURL.scheme == "http" || httpProviderURL.scheme == "https" else {return nil}
        url = httpProviderURL
        if net == nil {
            var request = JSONRPCrequest()
            request.method = JSONRPCmethod.getNetwork
            let params = [] as Array<Encodable>
            let pars = JSONRPCparams(params: params)
            request.params = pars
            let response = Web3HttpProvider.syncPost(request, providerURL: httpProviderURL)
            if response == nil {
                return nil
            }
            guard let res = response as? [String: Any] else {return nil}
            if let error = res["error"] as? String {
                print(error as String)
                return nil
            }
            guard let result = res["result"] as? String, let intNetworkNumber = Int(result) else {return nil}
            network = Networks.fromInt(intNetworkNumber)
            if network == nil {return nil}
        } else {
            network = net
        }
        attachedKeystoreManager = manager
    }
    
    public func sendSync(request: JSONRPCrequest) -> [String: Any]? {
        if request.method == nil {
            return nil
        }
        guard let response = self.syncPost(request) else {return nil}
        guard let res = response as? [String: Any] else {return nil}
        print(res)
        return res
    }
    
    internal func syncPost(_ request: JSONRPCrequest) -> Any? {
        return Web3HttpProvider.syncPost(request, providerURL: self.url)
    }
    
    static func syncPost(_ request: JSONRPCrequest, providerURL: URL) -> Any? {
        guard let httpBody = try? JSONEncoder().encode(request) else {return nil}
        
        var request = URLRequest(url: providerURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = httpBody
        
        let dispatchGroup = DispatchGroup()
        var returnDict: [String: Any]? = nil
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            dispatchGroup.leave()
            guard let data = data, error != nil else {return}
            returnDict = try? JSONDecoder().decode([String: Any].self, from: data)
        }
        dispatchGroup.enter()
        task.resume()
        dispatchGroup.wait()
        
        return returnDict
    }
}

