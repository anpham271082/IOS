#import "sqlite3.h"
@implementation CTHSqlite
+(void)initTable{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *strLibraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    BOOL success = [fileManager fileExistsAtPath:[strLibraryDirectory stringByAppendingString:@"/milo.db"]];
    if(!success) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"milo.db" ofType:nil];
        if (file){
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:file];
            [data writeToFile:[strLibraryDirectory stringByAppendingString:@"/milo.db"] options:NSDataWritingFileProtectionComplete error:&error];
        }
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"milo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString * strJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary *dic = [CTHJson dictionaryWithJSONString:strJson];
    NSMutableArray *list = [dic valueForKey:@"tables"];
    for (int i=0; i<[list count]; i++) {
        if (![self isTableExist:[[list objectAtIndex:i] valueForKey:@"table"] DBName:@"milo.db"]){
            [self createTable:[[list objectAtIndex:i] valueForKey:@"table"] Fields:[[list objectAtIndex:i] valueForKey:@"field"] DBName:@"milo.db"];
        }
    }
}
+(NSString*)getPathDB:(NSString*)strDbName{
    NSString *strLibraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    return [strLibraryDirectory stringByAppendingString:@"/milo.db"];
}
+(BOOL)isTableExist:(NSString *)strTable DBName:(NSString*)strDbName{
    //return FALSE;
    NSString *strPath = [self getPathDB:strDbName];
    int count = 0;
    BOOL result = FALSE;
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type='table' AND name='%@'",strTable];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while( sqlite3_step(statement) == SQLITE_ROW ){
                count = sqlite3_column_int(statement, 0);
                if(count>0){
                    result = TRUE;
                }
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return result;
}
+(void)createTable:(NSString*)strTable Fields:(NSString*)strFields DBName:(NSString*)strDbName{
    //return;
    NSString *strPath = [self getPathDB:strDbName];
    sqlite3 *database;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        char *errMsg;
        NSString *sqlQuery = [NSString stringWithFormat:@"create table if not exists %@(%@)",strTable,strFields];
        sqlite3_exec(database, [sqlQuery UTF8String], NULL, NULL, &errMsg);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(BOOL)isExist:(NSString*)strTable DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    BOOL check=FALSE;
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"select count(issued_date) from %@",strTable];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
            if(sqlite3_step(statement) == SQLITE_ROW) {
                if(sqlite3_column_int(statement, 0)>0)
                    check = TRUE;
            }
        }
        sqlQuery = nil;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return check;
}
+(void)deleteData:(NSString*)strTable DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"delete from %@",strTable];
        sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(void)deleteDataWithFilter:(NSString*)strTable contestId:(NSString*)contestIdStr DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"delete from %@ where %@",strTable,contestIdStr];
        sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(BOOL)isExistQueryData:(NSString*)sqlQuery DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    BOOL flag = FALSE;
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if(sqlite3_step(statement) == SQLITE_ROW) {
                flag = TRUE;
            }
        }
        sqlQuery = nil;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return flag;
}
+(void)update:(NSString*)strTable Data:(NSDictionary*)data DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE %@ SET response = ? ", strTable];
        sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil);
        sqlite3_bind_text(statement, 1, [[data valueForKey:@"response"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(void)updateParam:(NSString*)strTable Data:(NSDictionary*)data DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE %@ SET response = ? WHERE param='%@'", strTable, [data valueForKey:@"param"]];
        sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil);
        sqlite3_bind_text(statement, 1, [[data valueForKey:@"response"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(void)insert:(NSString*)strTable Data:(NSDictionary*)data Fields:(NSString*)strFields DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    strFields = [strFields stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"insert into %@(%@) ",strTable,strFields];
        NSArray *arrString = [strFields componentsSeparatedByString:@","];
        NSString *values=@"";
        for (int i=0; i<[arrString count]; i++) {
            if ([values length]==0){
                values = @"?";
            }else{
                values = [NSString stringWithFormat:@"%@,?",values];
            }
        }
        values = [NSString stringWithFormat:@"values(%@)",values];
        sqlQuery = [NSString stringWithFormat:@"%@%@",sqlQuery,values];
        sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil);
        int column = 0;
        for (; column<[arrString count]; column++){
            sqlite3_bind_text(statement,column+1,[[data objectForKey:[arrString objectAtIndex:column]]UTF8String],-1,SQLITE_TRANSIENT);
        }
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        sqlite3_close(database);
        sqlQuery = nil;
    }
}
+(void)getData:(NSString*)strTable Data:(NSMutableArray **)data Fields:(NSString*)strFields DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    strFields = [strFields stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSString *sqlQuery = [NSString stringWithFormat:@"select %@ from %@",strFields,strTable];
        NSArray *arrString = [strFields componentsSeparatedByString:@","];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while(sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *currentDic = [[NSMutableDictionary alloc] initWithCapacity:0];
                int column = 0;
                for (; column<[arrString count]; column++) {
                    [currentDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, column)] forKey:[arrString objectAtIndex:column]];
                }
                [*data addObject:currentDic];
            }
        }
        sqlQuery = nil;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}
+(void)getQueryData:(NSMutableArray **)data Fields:(NSString*)strFields Query:(NSString*)sqlQuery DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    strFields = [strFields stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        NSArray *arrString = [strFields componentsSeparatedByString:@","];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while(sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *currentDic = [[NSMutableDictionary alloc] initWithCapacity:0];
                int column = 0;
                for (; column<[arrString count]; column++) {
                    [currentDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, column)] forKey:[arrString objectAtIndex:column]];
                }
                [*data addObject:currentDic];
            }
        }
        sqlQuery = nil;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}
+(NSString*)getResponseData:(NSString*)sqlQuery DBName:(NSString*)strDbName{
    NSString *strPath = [self getPathDB:strDbName];
    NSString *strData = @"";
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([strPath UTF8String], &database) == SQLITE_OK){
        const char* key = [CTHUserDefined.PASS_SQLITE UTF8String];
        sqlite3_key(database, key, (int)strlen(key));
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if(sqlite3_step(statement) == SQLITE_ROW) {
                strData = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
        }
        sqlQuery = nil;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return strData;
}
@end
