//
//  NetWorkingTool.swift
//  NetWorkIng
//
//  Created by APPLE on 1/7/16.
//  Copyright © 2016 renzc. All rights reserved.
//

import UIKit
import AFNetworking

//枚举
enum RequestMethod: String{
    case GET = "GET"
    case POST = "POST"
}

//定义一个名为回调的闭包，其中定义好包括闭包的参数和返回值
typealias RequestCallBack = (response: AnyObject?, error: NSError?) -> ()

class NetWorkingTool: AFHTTPSessionManager{
    
    //单例设置
    static var shareTools: NetWorkingTool = {
        let instance = NetWorkingTool()
        //调用响应方法
        instance.responseSerializer.acceptableContentTypes?.insert("text/html")
        return instance
    }()

    //默认为GET方法
    func request(method: RequestMethod = .GET, urlString: String, parameters: AnyObject?, finished: RequestCallBack){
        
        //根据AFNetWorking中的success的block，再定义一个success闭包代替
        let success = {(dataTask: NSURLSessionDataTask, responseObject: AnyObject?) -> () in
            //当success调用，返回response后，实现RequestCallBack闭包，并赋值
            finished(response: responseObject, error: nil)
        }
        //同理
        let failure = {(dataTask: NSURLSessionDataTask?, error: NSError) -> () in
            finished(response: nil, error: error)
        }
        
        //判断以下到底是GET方法还是POST方法
        if method == .GET{
            //调用AFNetWorking中的GET和POST方法
            GET(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            POST(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
