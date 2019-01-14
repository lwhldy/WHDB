//
//  FMDBManager.m
//  DriveLicense
//
//  Created by 林文华 on 2018/12/26.
//  Copyright © 2018年 Best Lin. All rights reserved.
//

#import "WHDBManager.h"
#import "FMDB.h"
#import <objc/runtime.h>
#import "WHObject.h"

@interface WHDBManager ()

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong, readwrite) NSError *lastError;
@property (nonatomic, strong) NSString *queryTableName;

@end


@implementation WHDBManager

+ (instancetype)shareManager {
    static WHDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WHDBManager alloc] init];
    });
    return manager;
}

- (NSError *)lastError {
    return [self.db lastError];
}


#pragma mark - create database file

- (BOOL)createExistingDBConnectionAndHoldWithPath:(NSString *)path {
    return [self createExistingDBConnectionAndHoldWithPath:path error:nil];
}


- (BOOL)createExistingDBConnectionAndHoldWithPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    
    return [self createDBFileAndHoldWithPath:path error:error];
}

- (BOOL)createDBFileAndHoldWithDBName:(NSString *)databaseName {
    return [self createDBFileAndHoldWithDBName:databaseName error:nil];
}

- (BOOL)createDBFileAndHoldWithDBName:(NSString *)databaseName error:(NSError *__autoreleasing *)error {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", databaseName]];
    return [self createDBFileAndHoldWithPath:path error:error];
}


- (BOOL)createDBFileAndHoldWithPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    self.db = [[FMDatabase alloc] initWithPath:path];
    if ([self.db open]) {
        [self.db close];
        return YES;
    }else {
        *error = [self.db lastError];
        return NO;
    }
}

- (BOOL)switchDBFileAndHoldWithPath:(NSString *)path {
    return [self switchDBFileAndHoldWithPath:path error:nil];
}

- (BOOL)switchDBFileAndHoldWithPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    self.db = nil;
    return [self createDBFileAndHoldWithPath:path error:error];
}

#pragma mark - create Table

- (BOOL)createTableWithTableName:(NSString *)tableName forKeys:(NSArray *)keys {
    
    return [self createTableWithTableName:tableName forKeys:keys error:nil];
}

- (BOOL)createTableWithTableName:(NSString *)tableName forKeys:(NSArray *)keys error:(NSError *__autoreleasing *)error {
    NSMutableDictionary *initDic = [NSMutableDictionary dictionary];
    if (keys.count) {
        for (NSString *key in keys) {
            [initDic setObject:WHDB_VALUETYPE_NUMERIC forKey:key];
        }
    }
    return [self createTableWithTableName:tableName forKeyTypes:initDic error:error];
}

- (BOOL)createTableWithTableName:(NSString *)tableName forKeyTypes:(NSDictionary *)keyTypes {
    return [self createTableWithTableName:tableName forKeyTypes:keyTypes error:nil];
}

- (BOOL)createTableWithTableName:(NSString *)tableName forKeyTypes:(NSDictionary *)keyTypes error:(NSError *__autoreleasing *)error{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@", tableName];
    NSMutableDictionary *initDic = [NSMutableDictionary dictionary];
    if (keyTypes.count) {
        [initDic addEntriesFromDictionary:keyTypes];
    }
    if (self.defaultKeysEnable) {
        [sql appendString:@" (primaryId INTEGER PRIMARY KEY AUTOINCREMENT"];
        for (NSString *key in [WHObject invalidKeys]) {
            if ([key isEqualToString:@"createdAt"]) {
                [initDic setObject:WHDB_VALUETYPE_DATE forKey:key];
            }else if ([key isEqualToString:@"updatedAt"]) {
                [initDic setObject:WHDB_VALUETYPE_DATE forKey:key];
            }
        }
    }
    if (initDic.count) {
        NSArray *initKeys = initDic.allKeys;
        if (initDic.count == 1) {
            [sql appendString:[NSString stringWithFormat:@" (%@ %@)", initKeys.firstObject, [initKeys valueForKey:initKeys.firstObject]]];
        }else {
            for (NSInteger i = 0; i < initKeys.count; i++) {
                NSString *initKey = initKeys[i];
                NSString *type    = [initDic objectForKey:initKey];
                if (i == 0) {
                    if (!self.defaultKeysEnable) {
                        [sql appendString:@" ("];
                    }else{
                        [sql appendString:@","];
                    }
                    [sql appendString:[NSString stringWithFormat:@" %@ %@,", initKey, type]];
                }else if (i == initKeys.count - 1){
                    [sql appendString:[NSString stringWithFormat:@" %@ %@)", initKey, type]];
                }else {
                    [sql appendString:[NSString stringWithFormat:@" %@ %@,", initKey, type]];
                }
            }
        }
    }
    
    
    if (![self.db open]) {
        *error = [self.db lastError];
        return NO;
    }
    BOOL success = [self.db executeUpdate:sql];
    if (!success) {
        *error = [self.db lastError];
    }
    [self.db close];
    return success;
}

- (BOOL)updateOldTableName:(NSString *)oldTableName toNewTableName:(NSString *)newTableName {
    return [self updateOldTableName:oldTableName toNewTableName:newTableName error:nil];
}

- (BOOL)updateOldTableName:(NSString *)oldTableName toNewTableName:(NSString *)newTableName error:(NSError *__autoreleasing *)error {
    NSString *sql = [NSString stringWithFormat:@"ALERT TABLE %@ RENAME TO %@", oldTableName, newTableName];
    if (![self.db open]) {
        *error = [self.db lastError];
        return NO;
    }
    BOOL success = [self.db executeUpdate:sql];
    if (!success) {
        *error = [self.db lastError];
    }
    [self.db close];
    return success;
}

- (BOOL)addKey:(NSString *)key inTable:(NSString *)tableName {
    
    return [self addKey:key inTable:tableName error:nil];
}

- (BOOL)addKey:(NSString *)key inTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (!key || !tableName) {
        return NO;
    }
    return [self addKeyType:@{key:WHDB_VALUETYPE_NUMERIC} inTable:tableName error:error];
}

- (BOOL)addKeyType:(NSDictionary *)keyTypes inTable:(NSString *)tableName {
    if (!keyTypes.count || !tableName) {
        return NO;
    }
    
    return [self addKeyType:keyTypes inTable:tableName error:nil];
}

- (BOOL)addKeyType:(NSDictionary *)keyTypes inTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (!keyTypes.count || !tableName) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"ALERT TABLE %@ ADD COLUMN", tableName];
    if (![self.db open]) {
        *error = [self.db lastError];
        return NO;
    }
    NSArray *keys = keyTypes.allKeys;
    BOOL success = [self.db beginTransaction];
    if (!success) {
        *error = [self.db lastError];
        return success;
    }
    for (NSString *key in keys) {
        NSString *type = [keyTypes valueForKey:key];
        NSString *subSql = [NSString stringWithFormat:@"%@ %@ %@", sql, key, type];
        success = [self.db executeUpdate:subSql];
    }
    success = [self.db commit];
    if (!success) {
        *error = [self.db lastError];
        [self.db rollback];
        return success;
    }
    [self.db close];
    return success;
}





#pragma mark - Tools

- (NSArray *)propertysForModel:(NSObject*)model
{
    unsigned int count = 0;
    //获取属性的列表
    objc_property_t *propertyList =  class_copyPropertyList([model class], &count);
    NSMutableArray *propertyArray = [NSMutableArray array];
    
    for(int i=0;i<count;i++)
    {
        //取出每一个属性
        objc_property_t property = propertyList[i];
        //获取每一个属性的变量名
        const char* propertyName = property_getName(property);
        
        NSString *proName = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
        
        [propertyArray addObject:proName];
    }
    //c语言的函数，所以要去手动的去释放内存
    free(propertyList);
    
    return propertyArray.copy;
    
}


- (NSDictionary *)getFullDictionaryForObject:(id)object {
    if (!object) {
        return nil;
    }
    if ([object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)object;
    }else {
        NSArray *propertyNames = [self propertysForModel:object];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *name in propertyNames) {
            id value = [object valueForKey:name];
            if (value) {
                [dic setObject:value forKey:name];
            }else {
                [dic setObject:[NSNull null] forKey:name];
            }
        }
        return dic;
    }
}


#pragma mark - 增

- (BOOL)insertObject:(id)object toTable:(NSString *)tableName {
    return [self insertObject:object toTable:tableName error:nil];
}

- (BOOL)insertObject:(id)object toTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (!object) {
        return NO;
    }
    return [self insertObjects:@[object] toTable:tableName error:error];
}

- (BOOL)insertObjects:(NSArray *)objects toTable:(NSString *)tableName {
    return [self insertObjects:objects toTable:tableName error:nil];
}

- (BOOL)insertObjects:(NSArray *)objects toTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (!objects.count) {
        return NO;
    }
    
    if (![self.db open]) {
        *error = [self.db lastError];
        return NO;
    }
    BOOL success = [self.db beginTransaction];
    for (id object in objects) {
        NSMutableDictionary *objDic = [NSMutableDictionary dictionary];
        [objDic addEntriesFromDictionary:[self getFullDictionaryForObject:object]];
        NSArray *keys  = objDic.allKeys;
        if (!keys.count) {
            return NO;
        }
        NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@", tableName];
        
        if (self.defaultKeysEnable) {
            [objDic setObject:[NSNull null] forKey:@"primaryId"];
            [objDic setObject:[NSDate date] forKey:@"updatedAt"];
        }
        NSMutableArray *arguments = [NSMutableArray array];
        if (keys.count == 1) {
            [sql appendString:[NSString stringWithFormat:@" (%@) VALUES (?)", keys.firstObject]];
        }else {
            NSMutableString *keysString = [NSMutableString string];
            NSMutableString *valuesString = [NSMutableString string];
            for (NSInteger i = 0; i < keys.count; i++) {
                NSString *key = keys[i];
                id value = [objDic objectForKey:key];
                [arguments addObject:value];
                if (i == 0) {
                    [keysString appendString:[NSString stringWithFormat:@" (%@,", key]];
                    [valuesString appendString:@" (?,"];
                }else if (i == keys.count - 1){
                    [keysString appendString:[NSString stringWithFormat:@" %@)", key]];
                    [valuesString appendString:@" ?)"];
                }else {
                    [keysString appendString:[NSString stringWithFormat:@" %@,", key]];
                    [valuesString appendString:@" ?,"];
                }
            }
            [sql appendFormat:@"%@ VALUES %@", keysString, valuesString];
        }
        [self.db executeUpdate:sql withArgumentsInArray:arguments];
    }
    success = [self.db commit];
    if (!success) {
        *error = [self.db lastError];
        [self.db rollback];
    }
    [self.db close];
    return success;
}

#pragma mark - 删

- (BOOL)removeObject:(id)object inTable:(NSString *)tableName {
    return [self removeObject:object inTable:tableName error:nil];
}

- (BOOL)removeObject:(id)object inTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (!object) {
        return NO;
    }
    return [self removeObjects:@[object] inTable:tableName error:error];
}

- (BOOL)removeObjects:(NSArray *)objects inTable:(NSString *)tableName {
    return [self removeObjects:objects inTable:tableName error:nil];
}

- (BOOL)removeObjects:(NSArray *)objects inTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    
    if (!objects.count) {
        return NO;
    }
    
    if (![self.db open]) {
        *error = [self.db lastError];
        return NO;
    }
    BOOL success = [self.db beginTransaction];
    for (id object in objects) {
        NSMutableDictionary *objDic = [NSMutableDictionary dictionary];
        [objDic addEntriesFromDictionary:[self  getFullDictionaryForObject:object]];
        NSArray *keys = objDic.allKeys;
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
        if (self.defaultKeysEnable) {
            [sql appendString:@"WHERE primaryId=:primaryId"];
            NSNumber *primaryId = [objDic objectForKey:@"primaryId"];
            [objDic removeAllObjects];
            [objDic setObject:primaryId forKey:@"primaryId"];
        }else {
            for (NSInteger i = 0; i < keys.count; i++) {
                NSString *key = keys[i];
                if (i == 0) {
                    [sql appendString:[NSString stringWithFormat:@" WHERE %@=:%@", key, key]];
                }else {
                    [sql appendString:[NSString stringWithFormat:@" AND %@=:%@", key, key]];
                }
            }
        }
        [self.db executeUpdate:sql withParameterDictionary:objDic];
        
    }
    success = [self.db commit];
    if (!success) {
        *error = [self.db lastError];
        [self.db rollback];
    }
    [self.db close];
    return success;
}

- (BOOL)removeAllRowsWithTable:(NSString *)tableName {
    return [self removeAllRowsWithTable:tableName error:nil];
}

- (BOOL)removeAllRowsWithTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (![self.db open]) {
        return NO;
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
    
    BOOL success = [self.db executeUpdate:sql];
    if (!success) {
        *error = [self.db lastError];
    }
    [self.db close];
    return success;
}

- (BOOL)removeTable:(NSString *)tableName {
    return [self removeTable:tableName error:nil];
}

- (BOOL)removeTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (![self.db open]) {
        return NO;
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"DROP TABLE %@", tableName];
    
    BOOL success = [self.db executeUpdate:sql];
    if (!success) {
        *error = [self.db lastError];
    }
    [self.db close];
    return success;
}


#pragma mark - 改

- (BOOL)updateObject:(id)object inTable:(NSString *)tableName {
    return [self updateObject:object inTable:tableName error:nil];
}

- (BOOL)updateObject:(id)object inTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (!object) {
        return NO;
    }
    return [self updateObjects:@[object] inTable:tableName error:error];
}

- (BOOL)updateObjects:(NSArray *)objects inTable:(NSString *)tableName {
    
    return [self updateObjects:objects inTable:tableName error:nil];
}

- (BOOL)updateObjects:(NSArray *)objects inTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (objects.count) {
        return NO;
    }
    if (![self.db open]) {
        *error = [self.db lastError];
        return NO;
    }
    BOOL success = [self.db beginTransaction];
    for (id object in objects) {
        NSMutableDictionary *objDic = [self getFullDictionaryForObject:object].mutableCopy;
        NSArray *keys               = objDic.allKeys;
        NSMutableArray *arguments   = [NSMutableArray array];
        NSMutableString *sql        = [NSMutableString stringWithFormat:@"UPDATE %@ SET", tableName];
        if (self.defaultKeysEnable) {
            [objDic setValue:[NSDate date] forKey:@"updatedAt"];
            [objDic removeObjectForKey:@"primaryId"];
            keys = objDic.allKeys;
        }
        if (keys.count == 1) {
            [sql appendString:[NSString stringWithFormat:@" %@=?", keys.firstObject]];
            [arguments addObject:[objDic objectForKey:keys.firstObject]];
        }else {
            for (NSInteger i = 0; i < keys.count; i++) {
                NSString *key = keys[i];
                if (i == keys.count - 1) {
                    [sql appendString:[NSString stringWithFormat:@" %@=?", key]];
                }else {
                    [sql appendString:[NSString stringWithFormat:@" %@=?,", key]];
                }
                [arguments addObject:[objDic objectForKey:key]];
            }
        }
        if (self.defaultKeysEnable) {
            [sql appendString:@" WHERE createdAt=?"];
            [arguments addObject:[objDic objectForKey:@"createdAt"]];
            [self.db executeUpdate:sql withArgumentsInArray:arguments];
        }else {
            for (NSInteger i = 0; i < keys.count; i++) {
                NSString *key = keys[i];
                
                if (i == 0) {
                    [sql appendString:[NSString stringWithFormat:@" WHERE %@=?", key]];
                    
                }else {
                    [sql appendString:[NSString stringWithFormat:@" AND %@=?", key]];
                    
                }
                [arguments addObject:[objDic objectForKey:key]];
            }
            [self.db executeUpdate:sql withArgumentsInArray:arguments];
        }
        
    }
    
    success = [self.db commit];
    if (!success) {
        *error = [self.db lastError];
        [self.db rollback];
    }
    return success;
}

- (BOOL)updateObject:(id)object forCondition:(NSDictionary *)condition inTable:(NSString *)tableName {
    NSDictionary *objDic   = [self getFullDictionaryForObject:object];
    NSArray *keys          = objDic.allKeys;
    if (!keys.count || !condition.allKeys.count) {
        return NO;
    }
    if (![self.db open]) {
        return NO;
    }
    NSMutableArray *arguments = [NSMutableArray array];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET", tableName];
    if (keys.count == 1) {
        [sql appendString:[NSString stringWithFormat:@" %@=?", keys.firstObject]];
        [arguments addObject:[objDic objectForKey:keys.firstObject]];
    }else {
        for (NSInteger i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            if (i == keys.count - 1) {
                [sql appendString:[NSString stringWithFormat:@" %@=?", key]];
            }else {
                [sql appendString:[NSString stringWithFormat:@" %@=?,", key]];
            }
            [arguments addObject:[objDic objectForKey:key]];
        }
    }
    NSArray *conditionKeys = condition.allKeys;
    for (NSInteger i = 0; i < condition.allKeys.count; i++) {
        NSString *key = conditionKeys[i];
        
        if (i == 0) {
            [sql appendString:[NSString stringWithFormat:@" WHERE %@=?", key]];
            
        }else {
            [sql appendString:[NSString stringWithFormat:@" AND %@=?", key]];
            
        }
        [arguments addObject:[condition objectForKey:key]];
    }
    
    BOOL success = [self.db executeUpdate:sql withArgumentsInArray:arguments];
    [self.db close];
    return success;
}

- (BOOL)updateForCondition:(NSDictionary *)condition toValue:(NSDictionary *)valueDic inTable:(NSString *)tableName {
    return [self updateObject:valueDic forCondition:condition inTable:tableName];
}

#pragma mark - 查

- (NSArray *)queryCollectionForCondition:(NSArray *)condition
                         relateCondition:(NSArray *)relateCondition
                               orderKeys:(NSArray *)orderKeys
                                 inTable:(NSString *)tableName
                             relateTable:(NSString *)relateTableName {
    //SELECT EMP_ID, NAME, DEPT FROM COMPANY INNER JOIN DEPARTMENT
    //ON COMPANY.ID = DEPARTMENT.EMP_ID;
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@", tableName];
    if (![self.db open]) {
        return nil;
    }
    if (condition.count != relateCondition.count) {
        return nil;
    }
    if (condition.count) {
        [sql appendFormat:@" INNER JOIN %@", relateTableName];
    }
    if (condition.count) {
        
        for (NSInteger i = 0; i < condition.count; i++) {
            NSString *key = condition[i];
            NSString *relateKey = relateCondition[i];
            if (i == 0) {
                [sql appendString:[NSString stringWithFormat:@" ON %@.%@ = %@.%@", tableName, key, relateTableName, relateKey]];
            }else {
                [sql appendString:[NSString stringWithFormat:@" AND %@.%@ = %@.%@",tableName, key, relateTableName ,relateKey]];
            }
        }
    }
    
    if (orderKeys.count) {
        for (NSInteger i = 0; i < orderKeys.count; i++) {
            NSString *key = orderKeys[i];
            if (i == 0) {
                [sql appendString:[NSString stringWithFormat:@" ORDER BY %@ DESC", key]];
            }else {
                [sql appendString:[NSString stringWithFormat:@" ,%@", key]];
            }
        }
    }
    NSMutableArray *result = [NSMutableArray array];
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        [result addObject:[rs resultDictionary]];
    }
    [self.db close];
    return result;
}

- (NSArray*)queryForNullKeys:(NSArray*)nullKeys
                   orderKeys:(NSArray*)orderKeys
                     inTable:(NSString*)tableName {
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@", tableName];
    if (![self.db open]) {
        return nil;
    }
    if (nullKeys.count) {
        [sql appendString:@" where"];
    }
    if (nullKeys.count) {
        for (NSInteger i = 0; i < nullKeys.count; i++) {
            NSString *key = nullKeys[i];
            if (i == 0) {
                [sql appendString:[NSString stringWithFormat:@" %@ IS NULL", key]];
            }else {
                [sql appendString:[NSString stringWithFormat:@" AND %@ IS NULL", key]];
            }
        }
    }
    
    if (orderKeys.count) {
        for (NSInteger i = 0; i < orderKeys.count; i++) {
            NSString *key = orderKeys[i];
            if (i == 0) {
                [sql appendString:[NSString stringWithFormat:@" ORDER BY %@ DESC", key]];
            }else {
                [sql appendString:[NSString stringWithFormat:@" ,%@", key]];
            }
        }
    }
    NSMutableArray *result = [NSMutableArray array];
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        [result addObject:[rs resultDictionary]];
    }
    [self.db close];
    return result;
}



- (NSInteger)countForCondition:(NSDictionary *)condition inTable:(NSString *)tableName {
    
    if (![self.db open]) {
        return NO;
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT COUNT(*) FROM %@", tableName];
    NSArray *keys = condition.allKeys;
    for (NSInteger i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        if (i == 0) {
            [sql appendString:[NSString stringWithFormat:@" WHERE %@=:%@", key, key]];
        }else {
            [sql appendString:[NSString stringWithFormat:@" AND %@=:%@", key, key]];
        }
    }
    FMResultSet *rs = [self.db executeQuery:sql withParameterDictionary:condition];
    NSInteger resultCount = 0;
    while ([rs next]) {
        NSString *key = [rs resultDictionary].allKeys.firstObject;
        resultCount = [[[rs resultDictionary] objectForKey:key] integerValue];
        break;
    }
    [self.db close];
    return resultCount;
}

- (NSArray*)queryForFuzzyCondition:(NSDictionary*)fuzzyondition
                         orderKeys:(NSArray*)orderKeys
                           inTable:(NSString*)tableName {
    
    return [self queryForCondition:nil
                    fuzzyCondition:fuzzyondition
                greaterThanOrEqual:nil
                   lessThanOrEqual:nil
                       notNullKeys:nil
                         orderKeys:orderKeys
                             limit:-1
                           inTable:tableName];
}

- (NSArray*)queryForKeysNotNull:(NSArray*)keys
                      orderKeys:(NSArray*)orderKeys
                        inTable:(NSString*)tableName {
    
    return [self queryForCondition:nil
                   lessThanOrEqual:nil
                         orderKeys:orderKeys
                             limit:-1
                           inTable:tableName];
}

- (NSArray*)queryForCondition:(NSDictionary*)condition
                    orderKeys:(NSArray*)orderKeys
                      inTable:(NSString*)tableName {
    
    return [self queryForCondition:condition
                         orderKeys:orderKeys
                             limit:-1
                           inTable:tableName];
}

- (NSArray*)queryForCondition:(NSDictionary*)condition
                    orderKeys:(NSArray*)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString*)tableName {
    
    return [self queryForCondition:condition
                greaterThanOrEqual:nil
                         orderKeys:orderKeys
                             limit:limit
                           inTable:tableName];
}

- (NSArray*)queryForCondition:(NSDictionary*)condition
           greaterThanOrEqual:(NSDictionary*)greaterDic
                    orderKeys:(NSArray*)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString*)tableName {
    
    return [self queryForCondition:condition
                    fuzzyCondition:nil
                greaterThanOrEqual:greaterDic
                   lessThanOrEqual:nil
                       notNullKeys:nil
                         orderKeys:orderKeys
                             limit:limit
                           inTable:tableName];
    
}

- (NSArray*)queryForCondition:(NSDictionary*)condition
              lessThanOrEqual:(NSDictionary*)lessDic
                    orderKeys:(NSArray*)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString*)tableName {
    
    return [self queryForCondition:condition
                    fuzzyCondition:nil
                greaterThanOrEqual:nil
                   lessThanOrEqual:lessDic
                       notNullKeys:nil
                         orderKeys:orderKeys
                             limit:limit
                           inTable:tableName];
    
}


- (NSArray *)queryForCondition:(NSDictionary *)condition
                fuzzyCondition:(NSDictionary *)fuzzyCondition
            greaterThanOrEqual:(NSDictionary *)greaterDic
               lessThanOrEqual:(NSDictionary *)lessDic
                   notNullKeys:(NSArray *)notNullKeys
                     orderKeys:(NSArray *)orderKeys
                         limit:(NSInteger)limit
                       inTable:(NSString *)tableName {
    
    return [self queryForCondition:condition
                 notEqualCondition:nil
                       greaterThan:nil
                greaterThanOrEqual:greaterDic
                          lessThan:nil
                   lessThanOrEqual:lessDic
                         betweenIn:nil
         containsKeyArrayCondition:nil
       notContainKeyArrayCondition:nil
           containsStringCondition:fuzzyCondition
        notContainsStringCondition:nil
                hasPrefixCondition:nil
             notHasPrefixCondition:nil
                hasSubfixCondition:nil
             notHasSubfixCondition:nil
               relationalKeyArrays:nil
                       notNullKeys:notNullKeys
                          nullKeys:nil
                     ascendingKeys:nil
                    descendingKeys:orderKeys
                             limit:limit
                           isCount:NO
                           inTable:tableName
                             error:nil];
    
}

- (NSArray *)queryForCondition:(NSDictionary *)equalCondition
             notEqualCondition:(NSDictionary *)notEqualCondition
                   greaterThan:(NSDictionary *)greaterThanCondition
            greaterThanOrEqual:(NSDictionary *)greaterOrEqualCondition
                      lessThan:(NSDictionary *)lessThanCondition
               lessThanOrEqual:(NSDictionary *)lessThanOrEqualCondition
                     betweenIn:(NSDictionary *)betweenCondition
     containsKeyArrayCondition:(NSDictionary *)containsKeyArrayCondition
   notContainKeyArrayCondition:(NSDictionary *)notContainsKeyArrayCondition
       containsStringCondition:(NSDictionary *)containsStringCondition
    notContainsStringCondition:(NSDictionary *)notContainsStringCondition
            hasPrefixCondition:(NSDictionary *)hasPrefixCondition
         notHasPrefixCondition:(NSDictionary *)notHasPrefixCondition
            hasSubfixCondition:(NSDictionary *)hasSubfixCondition
         notHasSubfixCondition:(NSDictionary *)notHasSubfixCondition
           relationalKeyArrays:(NSArray *)relationalKeyArrays
                   notNullKeys:(NSArray *)notNullKeys
                      nullKeys:(NSArray *)nullKeys
                 ascendingKeys:(NSArray *)ascendingKeys
                descendingKeys:(NSArray *)descendingKeys
                         limit:(NSInteger)limit
                       isCount:(BOOL)isCount
                       inTable:(NSString *)tableName
                         error:(NSError **)error {
    self.queryTableName = tableName;
    NSString *replaceStr = isCount ? @"COUNT(*)" : @"*";
    if (isCount) {
        limit = -1;
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@", replaceStr,  tableName];
    NSMutableArray *arguments = [NSMutableArray array];
    if (![self.db open]) {
        *error = [self.db lastError];
        return nil;
    }
    //关联查询
    BOOL hasRelationCondition = NO;
    if (relationalKeyArrays.count) {
        for (NSDictionary *relationalDic in relationalKeyArrays) {
            NSString *key               = [relationalDic allKeys].firstObject;
            NSDictionary *value         = [relationalDic objectForKey:key];
            NSString *relationalKey     = [value allKeys].firstObject;
            NSString *relationTableName = [value objectForKey:relationalKey];
            [sql appendString:[NSString stringWithFormat:@" INNER JOIN %@ ON %@.%@=%@.%@", relationTableName, tableName, key, relationTableName, relationalKey]];
        }
        hasRelationCondition = YES;
    }
    
    BOOL hasCondition = NO;
    NSMutableString *conditionSql = [NSMutableString string];
    //相等
    if (equalCondition.count) {
        NSDictionary *dic = [self createConditionStringWithcondition:equalCondition operatorStr:@"=" hasCondition:hasCondition hasRelationCondition:hasRelationCondition];
        NSString *subSql  = [dic objectForKey:@"subSql"];
        NSArray  *subArgs = [dic objectForKey:@"subArgs"];
        [conditionSql appendString:subSql];
        [arguments addObjectsFromArray:subArgs];
        hasCondition = YES;
    }
    //不相等
    if (notEqualCondition.count) {
        NSDictionary *dic = [self createConditionStringWithcondition:notEqualCondition operatorStr:@"!=" hasCondition:hasCondition hasRelationCondition:hasRelationCondition];
        NSString *subSql  = [dic objectForKey:@"subSql"];
        NSArray  *subArgs = [dic objectForKey:@"subArgs"];
        [conditionSql appendString:subSql];
        [arguments addObjectsFromArray:subArgs];
        hasCondition = YES;
    }
    //大于
    if (greaterThanCondition.count) {
        NSDictionary *dic = [self createConditionStringWithcondition:greaterThanCondition operatorStr:@">" hasCondition:hasCondition hasRelationCondition:hasRelationCondition];
        NSString *subSql  = [dic objectForKey:@"subSql"];
        NSArray  *subArgs = [dic objectForKey:@"subArgs"];
        [conditionSql appendString:subSql];
        [arguments addObjectsFromArray:subArgs];
        hasCondition = YES;
    }
    //大于或等于
    if (greaterOrEqualCondition.count) {
        NSDictionary *dic = [self createConditionStringWithcondition:greaterOrEqualCondition operatorStr:@">=" hasCondition:hasCondition hasRelationCondition:hasRelationCondition];
        NSString *subSql  = [dic objectForKey:@"subSql"];
        NSArray  *subArgs = [dic objectForKey:@"subArgs"];
        [conditionSql appendString:subSql];
        [arguments addObjectsFromArray:subArgs];
        hasCondition = YES;
    }
    //小于
    if (lessThanCondition.count) {
        NSDictionary *dic = [self createConditionStringWithcondition:lessThanCondition operatorStr:@"<" hasCondition:hasCondition hasRelationCondition:hasRelationCondition];
        NSString *subSql  = [dic objectForKey:@"subSql"];
        NSArray  *subArgs = [dic objectForKey:@"subArgs"];
        [conditionSql appendString:subSql];
        [arguments addObjectsFromArray:subArgs];
        hasCondition = YES;
    }
    
    //小于或等于
    if (lessThanCondition.count) {
        NSDictionary *dic = [self createConditionStringWithcondition:lessThanCondition operatorStr:@"<=" hasCondition:hasCondition hasRelationCondition:hasRelationCondition];
        NSString *subSql  = [dic objectForKey:@"subSql"];
        NSArray  *subArgs = [dic objectForKey:@"subArgs"];
        [conditionSql appendString:subSql];
        [arguments addObjectsFromArray:subArgs];
        hasCondition = YES;
    }
    //between区间
    if (betweenCondition.count) {
        NSArray *keys = betweenCondition.allKeys;
        for (NSInteger i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            NSArray *betweenArray = [betweenCondition objectForKey:key];
            NSString *keyStr = hasRelationCondition ? [NSString stringWithFormat:@" %@.%@", self.queryTableName, key] : key;
            if (i == 0 && !hasCondition) {
                [conditionSql appendString:[NSString stringWithFormat:@" %@ BETWEEN (?, ?)", keyStr]];
            }else {
                [conditionSql appendString:[NSString stringWithFormat:@" AND %@ BETWEEN (?, ?)", keyStr]];
            }
            [arguments addObjectsFromArray:betweenArray];
        }
        hasCondition = YES;
    }
    //contains in array 被数组包含
    if (containsKeyArrayCondition.count) {
        NSArray *keys = containsKeyArrayCondition.allKeys;
        for (NSInteger i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            NSString *keyStr = hasRelationCondition ? [NSString stringWithFormat:@" %@.%@", self.queryTableName, key] : key;
            NSArray *inArray = [containsKeyArrayCondition objectForKey:keyStr];
            if (hasCondition) {
                [conditionSql appendString:@" AND IN"];
            }else {
                [conditionSql appendString:@" IN"];
            }
            if (inArray.count == 1) {
                [conditionSql appendString:@" (?)"];
            }else {
                for (NSInteger j = 0; j < inArray.count; i++) {
                    if (j == 0) {
                        [conditionSql appendString:@" (?,"];
                    }else if (j == inArray.count - 1){
                        [conditionSql appendString:@" ?)"];
                    }else {
                        [conditionSql appendString:@" ?,"];
                    }
                }
            }
            
            [arguments addObjectsFromArray:inArray];
        }
        hasCondition = YES;
    }
    //not contains in array 不被数组包含
    if (notContainsKeyArrayCondition.count) {
        NSArray *keys = notContainsKeyArrayCondition.allKeys;
        for (NSInteger i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            NSString *keyStr = hasRelationCondition ? [NSString stringWithFormat:@" %@.%@", self.queryTableName, key] : key;
            NSArray *notInArray = [notContainsKeyArrayCondition objectForKey:keyStr];
            if (hasCondition) {
                [conditionSql appendString:@" AND NOT IN"];
            }else {
                [conditionSql appendString:@" NOT IN"];
            }
            if (notInArray.count == 1) {
                [conditionSql appendString:@" (?)"];
            }else {
                for (NSInteger j = 0; j < notInArray.count; i++) {
                    if (j == 0) {
                        [conditionSql appendString:@" (?,"];
                    }else if (j == notInArray.count - 1){
                        [conditionSql appendString:@" ?)"];
                    }else {
                        [conditionSql appendString:@" ?,"];
                    }
                }
            }
            
            [arguments addObjectsFromArray:notInArray];
        }
        hasCondition = YES;
    }
    //包含字符串
    if (containsStringCondition.count) {
        [conditionSql appendString:[self createLikeStringWithcondition:containsStringCondition hasPrefix:YES hasSubfix:YES isLike:YES hasCondition:hasCondition hasRelationCondition:hasRelationCondition]];
        hasCondition = YES;
    }
    //不包含字符串
    if (notContainsStringCondition.count) {
        [conditionSql appendString:[self createLikeStringWithcondition:notContainsStringCondition hasPrefix:YES hasSubfix:YES isLike:NO hasCondition:hasCondition hasRelationCondition:hasRelationCondition]];
        hasCondition = YES;
    }
    //以某字符串开头
    if (hasPrefixCondition.count) {
        [conditionSql appendString:[self createLikeStringWithcondition:hasPrefixCondition hasPrefix:NO hasSubfix:YES isLike:YES hasCondition:hasCondition hasRelationCondition:hasRelationCondition]];
        hasCondition = YES;
    }
    //不以某字符串开头
    if (notHasPrefixCondition.count) {
        [conditionSql appendString:[self createLikeStringWithcondition:notHasPrefixCondition hasPrefix:NO hasSubfix:YES isLike:NO hasCondition:hasCondition hasRelationCondition:hasRelationCondition]];
        hasCondition = YES;
    }
    //以某字符串结尾
    if (hasSubfixCondition.count) {
        [conditionSql appendString:[self createLikeStringWithcondition:hasSubfixCondition hasPrefix:YES hasSubfix:NO isLike:YES hasCondition:hasCondition hasRelationCondition:hasRelationCondition]];
        hasCondition = YES;
    }
    //不以某字符串结尾
    if (notHasSubfixCondition.count) {
        [conditionSql appendString:[self createLikeStringWithcondition:notHasSubfixCondition hasPrefix:YES hasSubfix:NO isLike:NO hasCondition:hasCondition hasRelationCondition:hasRelationCondition]];
        hasCondition = YES;
    }
    
    
    
    if (notNullKeys.count) {
        for (NSInteger i = 0; i < notNullKeys.count; i++) {
            NSString *key = notNullKeys[i];
            NSString *keyStr = hasRelationCondition ? [NSString stringWithFormat:@" %@.%@", self.queryTableName, key] : key;
            if (i == 0 && !hasCondition) {
                [conditionSql appendString:[NSString stringWithFormat:@" %@ NOT NULL", keyStr]];
            }else {
                [conditionSql appendString:[NSString stringWithFormat:@" AND %@ NOT NULL", keyStr]];
            }
        }
    }
    if (nullKeys.count) {
        for (NSInteger i = 0; i < nullKeys.count; i++) {
            NSString *key = nullKeys[i];
            NSString *keyStr = hasRelationCondition ? [NSString stringWithFormat:@" %@.%@", self.queryTableName, key] : key;
            if (i == 0 && !hasCondition) {
                [conditionSql appendString:[NSString stringWithFormat:@" %@ IS NULL", keyStr]];
            }else {
                [conditionSql appendString:[NSString stringWithFormat:@" AND %@ IS NULL", keyStr]];
            }
        }
    }
    
    if (ascendingKeys.count) {
        for (NSInteger i = 0; i < ascendingKeys.count; i++) {
            NSString *key = ascendingKeys[i];
            NSString *keyStr = hasRelationCondition ? [NSString stringWithFormat:@" %@.%@", self.queryTableName, key] : key;
            if (i == 0 && !hasCondition) {
                [conditionSql appendString:[NSString stringWithFormat:@" ORDER BY %@ ASC", keyStr]];
            }else {
                [conditionSql appendString:[NSString stringWithFormat:@" AND ORDER BY %@ ASC", keyStr]];
            }
        }
    }
    
    if (descendingKeys.count) {
        for (NSInteger i = 0; i < descendingKeys.count; i++) {
            NSString *key = descendingKeys[i];
            NSString *keyStr = hasRelationCondition ? [NSString stringWithFormat:@" %@.%@", self.queryTableName, key] : key;
            if (i == 0 && !hasCondition) {
                [conditionSql appendString:[NSString stringWithFormat:@" ORDER BY %@ DESC", keyStr]];
            }else {
                [conditionSql appendString:[NSString stringWithFormat:@" AND ORDER BY %@ DESC", keyStr]];
            }
        }
    }
    
    if (limit > 0) {
        [conditionSql appendString:@" LIMIT ?"];
        [arguments addObject:@(limit)];
    }
    
    if (hasCondition) {
        [sql appendString:@" WHERE"];
    }
    [sql appendString:conditionSql];
    
    NSMutableArray *result = [NSMutableArray array];
    FMResultSet *rs = [self.db executeQuery:sql withArgumentsInArray:arguments];
    while ([rs next]) {
        [result addObject:[rs resultDictionary]];
    }
    if ([self.db lastErrorCode] != 0) {
        *error = [self.db lastError];
        [result removeAllObjects];
    }
    [self.db close];
    return result;
}

- (NSString*)createLikeStringWithcondition:(NSDictionary*)condition
                                 hasPrefix:(BOOL)hasPrefix
                                 hasSubfix:(BOOL)hasSubfix
                                    isLike:(BOOL)isLike
                              hasCondition:(BOOL)hasCondition
                      hasRelationCondition:(BOOL)hasRelationCondition{
    
    NSArray *keys        = condition.allKeys;
    NSMutableString *sql = [NSMutableString string];
    for (NSInteger i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        id value      = [condition objectForKey:key];
        NSString *keyStr = hasRelationCondition ? [NSString stringWithFormat:@" %@.%@", self.queryTableName, key] : key;
        if (i != 0 || hasCondition) {
            
            [sql appendString:@" AND"];

        }
        
        [sql appendString:[NSString stringWithFormat:@" %@ %@ '", keyStr, isLike ? @"LIKE" : @"NOT LIKE"]];
        if (hasPrefix) {
            [sql appendString:@"%%"];
        }
        [sql appendString:[NSString stringWithFormat:@"%@%@", value, hasSubfix ? @"%%'": @"'"]];
    }
    return sql;
}

- (NSDictionary*)createConditionStringWithcondition:(NSDictionary*)condition
                                        operatorStr:(NSString*)operatorStr
                                       hasCondition:(BOOL)hasCondition
                               hasRelationCondition:(BOOL)hasRelationCondition{
    
    NSArray *keys              = condition.allKeys;
    NSMutableString *sql       = [NSMutableString string];
    NSMutableArray  *arguments = [NSMutableArray array];
    for (NSInteger i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        id value      = [condition objectForKey:key];
        NSString *keyStr = hasRelationCondition ? [NSString stringWithFormat:@" %@.%@", self.queryTableName, key] : key;
        if (i == 0 && !hasCondition) {
            [sql appendString:[NSString stringWithFormat:@" %@%@?", keyStr, operatorStr]];
            
        }else {
            
            [sql appendString:[NSString stringWithFormat:@" AND %@%@?", keyStr, operatorStr]];
        }
        [arguments addObject:value];
    }
    return @{@"subSql":sql, @"subArgs":arguments};
    
}



@end
