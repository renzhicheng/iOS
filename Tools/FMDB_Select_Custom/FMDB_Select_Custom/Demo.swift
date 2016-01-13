//
//  Demo.swift
//  FMDB_Select_Custom
//
//  Created by APPLE on 1/13/16.
//  Copyright © 2016 renzc. All rights reserved.
//

import UIKit

class Demo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = SQListManager.shareManager
        print(manager.queue.path)
        let sql = "SELECT id, name, age, height FROM T_Person;"
        
        //请先插入数据，再查询数据。
//        demoInsert()
        
//        print(manager.executeSelectRecord(sql))
    }

    //如果测试demo，需先调用插入命令
    func demoInsert(){
        let name = "张仪"
        let sql = "INSERT INTO T_Person (name, age, height) VALUES (?, ?, ?);"
        SQListManager.shareManager.queue.inDatabase { (db) -> Void in
            do{
                try db.executeUpdate(sql, name, 18, 190)
                print("插入数据成功")
            }catch{
                print("插入数据失败")
            }
        }
    }
}
