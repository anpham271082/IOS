//
//  SQLiteService.swift
//  application_ios
//
//  Created by An Pham Ngoc on 9/13/24.
//

import Foundation
import SQLCipher
public class PerSQLite{
    class func initDatabase() {
        var json = [AnyHashable:Any]()
        if let filePath = Bundle.main.path(forResource: "tables", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
            let dic = (try? JSONSerialization.jsonObject(with: data)) as? [AnyHashable:Any] {
            json = dic
        }
        let fileManager = FileManager.default
        let list:NSArray = json["list"] as! NSArray
        for i in 0..<list.count {
            let strDbName: String = (list[i] as AnyObject).value(forKey: "name") as! String
            let strPath = "\(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0])/Caches/\("au")_\(strDbName)"
            let success: Bool = fileManager.fileExists(atPath: strPath)
            if !success {
                let file: String? = Bundle.main.path(forResource: Global.DATABASE_SQLITE, ofType: nil)
                if file != nil {
                    try? FileManager.default.copyItem(atPath: file!, toPath: strPath)
                }
            }
            let tables:NSArray = (list[i] as AnyObject).value(forKey: "tables") as! NSArray
            for j in 0..<tables.count {
                if !(isTableExist((tables[j] as AnyObject).value(forKey: "table") as! String, dbName: strDbName)) {
                    createTable((tables[j] as AnyObject).value(forKey: "table") as! String, fields: (tables[j] as AnyObject).value(forKey: "field") as! String, dbName: strDbName)
                }
            }
        }
    }
    class func getPathDB(_ strDbName: String) -> String {
        let strPath = "\(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0])/Caches/\("au")_\(strDbName)"
        return strPath
    }
    class func createTable(_ strTable: String, fields strFields: String, dbName strDbName: String) {
        let strPath: String = getPathDB(strDbName)
        var database: OpaquePointer? = nil
        if sqlite3_open_v2(strPath, &database, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            let sqlQuery = "create table if not exists \(strTable)(\(strFields))"
            sqlite3_exec(database, sqlQuery, nil, nil, nil)
            sqlite3_close(database)
        }
    }
    class func isExist(_ strTable: String, dbName strDbName: String) -> Bool {
        let strPath: String = getPathDB(strDbName)
        var check: Bool = false
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            let sqlQuery: String = "select count(issued_date) from \(strTable)"
            if sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_ROW {
                    if sqlite3_column_int(statement, 0) > 0 {
                        check = true
                    }
                }
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
        return check
    }
    class func deleteData(_ strTable: String, dbName strDbName: String) {
        let strPath: String = getPathDB(strDbName)
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            let sqlQuery: String = "delete from \(strTable)"
            sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil)
            sqlite3_step(statement)
            sqlite3_finalize(statement)
            sqlite3_close(database)
        }
    }
    class func deleteDataWithFilter(_ strTable: String, contestId contestIdStr: String, dbName strDbName: String) {
        let strPath: String = getPathDB(strDbName)
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            let sqlQuery: String = "delete from \(strTable) where \(contestIdStr)"
            sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil)
            sqlite3_step(statement)
            sqlite3_finalize(statement)
            sqlite3_close(database)
        }
    }
    class func isExistQueryData(_ sqlQuery: String, dbName strDbName: String) -> Bool {
        let strPath: String = getPathDB(strDbName)
        var flag: Bool = false
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            if sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_ROW {
                    flag = true
                }
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
        return flag
    }
    class func update(_ strTable: String, data: [AnyHashable: Any], dbName strDbName: String) {
        let strPath: String = getPathDB(strDbName)
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            let sqlQuery: String = "UPDATE \(strTable) SET content = ? "
            sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil)
            let content = data["content"] as? String
            sqlite3_bind_text(statement, 1, content, -1, nil)
            sqlite3_step(statement)
            sqlite3_finalize(statement)
            sqlite3_close(database)
        }
    }
    class func updateParam(_ strTable: String, data: [AnyHashable: Any], dbName strDbName: String) {
        let strPath: String = getPathDB(strDbName)
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            let param = data["param"] as? String
            let sqlQuery = "UPDATE \(strTable) SET content = ? WHERE param='\(String(describing:param))'"
            sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil)
            let content = data["content"] as? String
            sqlite3_bind_text(statement, 1, content, -1, nil)
            sqlite3_step(statement)
            sqlite3_finalize(statement)
            sqlite3_close(database)
        }
    }
    class func insert(_ strTable: String, data: NSMutableDictionary, fields strFields: String, dbName strDbName: String) {
        let strPath: String = getPathDB(strDbName)
        let strFields = strFields.trimmingCharacters(in: .whitespacesAndNewlines)
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            var sqlQuery: String = "insert into \(strTable)(\(strFields)) "
            let arrString: [Any] = strFields.components(separatedBy: ",")
            var values: String? = nil
            for _ in 0..<arrString.count {
                if ((values?.isEmpty) != nil) {
                    values = "\(values!),?"
                }
                else {
                    values = "?"
                }
            }
            values = "values(\(values!))"
            sqlQuery = "\(sqlQuery)\(values!)"
            sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil)
            var column: Int = 0
            while column < arrString.count {
                let value = data[arrString[column]] as? String
                sqlite3_bind_text(statement, Int32(column + 1), value, -1, nil)
                column = column + 1
            }
            sqlite3_step(statement)
            sqlite3_finalize(statement)
            sqlite3_close(database)
        }
    }
    class func isTableExist(_ strTable: String, dbName strDbName: String) -> Bool {
        let strPath: String = getPathDB(strDbName)
        var count: Int = 0
        var result: Bool = false
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            let sqlQuery: String = "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='\(strTable)'"
            if sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    count = Int(sqlite3_column_int(statement, 0))
                    if count > 0 {
                        result = true
                    }
                }
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
        return result
    }
    class func getData(_ strTable: String, data: NSMutableArray, strFields: String, dbName strDbName: String) {
        let strPath: String = getPathDB(strDbName)
        let strFields = strFields.trimmingCharacters(in: .whitespacesAndNewlines)
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            let sqlQuery: String = "select \(strFields) from \(strTable)"
            let arrString: [Any] = strFields.components(separatedBy: ",")
            if sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let currentDic = NSMutableDictionary()
                    var column: Int = 0
                    while column < arrString.count {
                        currentDic[arrString[column]] = String(cString:(sqlite3_column_text(statement, Int32(column))))
                        column = column + 1
                    }
                    data.add(currentDic)
                }
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
    }
    class func getQueryData(_ data: NSMutableArray, strFields: String, sqlQuery: String, dbName strDbName: String) {
        let strPath: String = getPathDB(strDbName)
        let strFields = strFields.trimmingCharacters(in: .whitespacesAndNewlines)
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            let arrString: [Any] = strFields.components(separatedBy: ",")
            if sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let currentDic = NSMutableDictionary()
                    var column: Int = 0
                    while column < arrString.count {
                        currentDic[arrString[column]] = String(cString:(sqlite3_column_text(statement, Int32(column))))
                        column =  column + 1
                    }
                    data.add(currentDic)
                }
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
    }
    class func getContentData(_ sqlQuery: String, dbName strDbName: String) -> String {
        let strPath: String = getPathDB(strDbName)
        var strData: String = ""
        var database: OpaquePointer? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_open(strPath, &database) == SQLITE_OK {
            sqlite3_key(database, Global.DATABASE_SQLITE_PASS, Int32(Global.DATABASE_SQLITE_PASS.utf8.count))
            if sqlite3_prepare_v2(database, sqlQuery, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_ROW {
                    strData = String(cString:(sqlite3_column_text(statement, 0)))
                }
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
        return strData
    }
}
