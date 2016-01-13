


//swift版本，使用前一定要注意添加与OC的桥接，以及添加网络的动态库。

import Foundation

private let dbName = "my.db"

class SQListManager {
    
    static let shareManager: SQListManager = SQListManager()
    
    var queue = FMDatabaseQueue()
    
    private init(){
        //设置路线
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        path = (path as NSString).stringByAppendingPathComponent(dbName)
        queue = FMDatabaseQueue(path: path)
        creatTable()
    }
    
    //创建数据库表单
    private func creatTable(){
        //准备SQL
        let path = NSBundle.mainBundle().pathForResource("DB.sql", ofType: nil)!
        //读取bundle中的文件夹中的string，这个方法是string的init方法中的一种初始化方法。
        let sql = try! String(contentsOfFile: path)
        //执行SQL
        queue.inDatabase { (db) -> Void in
            //使用多条SQL，适合一次创建多条
            if db.executeStatements(sql){
                print("创表成功")
            }else{
                print("创表失败")
            }
        }
        print("这里用来测试线程")
    }
    
    //查询数据
    func executeSelectRecord(sql: String) -> [[String: AnyObject]]{
        var resultSet = [[String: AnyObject]]()
        self.queue.inDatabase({ (db) -> Void in
            guard let result = try? db.executeQuery(sql) else{
                print("SQL 语句错误或数据无效")
                return
            }
            while result.next(){
                //How many columns in result set
                let colCount = result.columnCount()
                var row = [String: AnyObject]()
                for index in 0..<colCount{
                    //Column index for column name
                    let name = result.columnNameForIndex(index)
                    //Result set object for column.
                    let value = result.objectForColumnIndex(index)
                    row[name] = value
                }
                resultSet.append(row)
            }
        })
        return resultSet
    }
}

