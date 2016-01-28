//
//  ViewController.swift
//  NetWorkIng
//
//  Created by APPLE on 1/7/16.
//  Copyright © 2016 renzc. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "http://127.0.0.1/resources/vedios.json"
        NetWorkingTool.shareTools.request(RequestMethod.GET, urlString: urlString, parameters: nil) { (response, error) -> () in
            //判断是否请求错误，并打印错误信息
            if error != nil{
                print(error)
                return
            }
            
            print(response)
        }
    }
}

