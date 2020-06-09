//
//  FMDBManager.h
//  DriveLicense
//
//  Created by lwhldy on 2018/12/26.
//  Copyright © 2018年 lwhldy. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 整型 */
static NSString * _Nullable const WHDB_VALUETYPE_INTEGER = @"INTEGER";
/** 浮点型 */
static NSString * _Nullable const WHDB_VALUETYPE_FLOAT   = @"REAL";
/** 字符型 */
static NSString * _Nullable const WHDB_VALUETYPE_STRING  = @"TEXT";
/** 二进制 */
static NSString * _Nonnull const WHDB_VALUETYPE_DATA    = @"BLOB";
/** NSDate */
static NSString * _Nullable const WHDB_VALUETYPE_DATE    = @"DATE";
/** BOOL */
static NSString * _Nullable const WHDB_VALUETYPE_BOOL    = @"BOOLEAN";
/** 由sqlite来确定亲和类型 如未设置类型 默认此类型 */
static NSString * _Nullable const WHDB_VALUETYPE_NUMERIC = @"NUMERIC";

@interface WHDBManager : NSObject

+ (instancetype _Nullable )shareManager;

@property (nonatomic, assign) BOOL defaultKeysEnable;

@property (nonatomic, strong) NSString * _Nullable databasePath;

@property (nonatomic, strong, readonly) NSError * _Nullable lastError;


#pragma mark - create database file
/**
 通过已存在的database文件创建数据库连接
 
 @param  path database文件路径
 @return BOOL YES OR NO
 */
- (BOOL)createExistingDBConnectionAndHoldWithPath:(NSString*_Nonnull)path;

/**
 通过已存在的database文件创建数据库连接

 @param path database文件路径
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)createExistingDBConnectionAndHoldWithPath:(NSString* _Nonnull)path error:(NSError * _Nullable * _Nullable)error;

/**
 通过自定义databaseName来创建database文件

 @param databaseName 数据库名称
 @return YES OR NO
 */
- (BOOL)createDBFileAndHoldWithDBName:(NSString*_Nonnull)databaseName;

/**
 通过自定义databaseName来创建database文件

 @param databaseName 数据库名称
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)createDBFileAndHoldWithDBName:(NSString*_Nonnull)databaseName error:(NSError * _Nullable * _Nullable)error;

/**
 通过自定义database路径来创建database文件

 @param path 路径
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)createDBFileAndHoldWithPath:(NSString*_Nonnull)path error:(NSError * _Nullable * _Nullable)error;


/**
 切换当前database并持有
 
 @param path database路径
 @return YES OR NO
 */
- (BOOL)switchDBFileAndHoldWithPath:(NSString*_Nonnull)path;

/**
 切换当前database并持有
 
 @param path database路径
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)switchDBFileAndHoldWithPath:(NSString*_Nonnull)path error:(NSError * _Nullable * _Nullable)error;



#pragma mark - create Table

/**
 通过tableName和keys创建表

 @param tableName 表名
 @param keys 字段数组
 @return YES OR NO
 */
- (BOOL)createTableWithTableName:(NSString*_Nonnull)tableName forKeys:(NSArray* _Nullable)keys;

/**
 通过tableName和keys创建表

 @param tableName 表名
 @param keys 字段数组
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)createTableWithTableName:(NSString*_Nonnull)tableName forKeys:(NSArray* _Nullable)keys error:(NSError * _Nullable * _Nullable)error;

/**
 通过tableName和keyTypes创建表
 keyTypes INTEGER example:@{@"keyName":WHDB_VALUETYPE_INTEGER};
 所有类型请查看 WHDB_VALUETYPE 声明
 @param tableName 表名
 @param keyTypes keyTypes字典
 @return YES OR NO
 */
- (BOOL)createTableWithTableName:(NSString*_Nonnull)tableName forKeyTypes:(NSDictionary* _Nullable)keyTypes;

/**
 通过tableName和keyTypes创建表
 keyTypes INTEGER example:@{@"keyName":WHDB_VALUETYPE_INTEGER};
 更多类型请查看 WHDB_VALUETYPE 声明
 @param tableName 表名
 @param keyTypes keyTypes字典
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)createTableWithTableName:(NSString*_Nonnull )tableName forKeyTypes:(NSDictionary* _Nullable)keyTypes error:(NSError * _Nullable * _Nullable)error;


/**
 修改表名

 @param oldTableName 原表名
 @param newTableName 新表名
 @return YES OR NO
 */
- (BOOL)updateOldTableName:(NSString *_Nonnull)oldTableName toNewTableName:(NSString *_Nonnull)newTableName;

/**
 修改表名
 
 @param oldTableName 原表名
 @param newTableName 新表名
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)updateOldTableName:(NSString *_Nonnull)oldTableName toNewTableName:(NSString *_Nonnull)newTableName error:(NSError * _Nullable * _Nullable)error;

/**
 为表添加字段

 @param key 字段名
 @param tableName 表名
 @return YES OR NO
 */
- (BOOL)addKey:(NSString*_Nonnull)key inTable:(NSString*_Nonnull)tableName;

/**
 为表添加字段
 
 @param key 字段名
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)addKey:(NSString*_Nonnull)key inTable:(NSString*_Nonnull)tableName error:(NSError * _Nullable * _Nullable)error;


/**
 为表添加字段
 
 @param keyTypes 字段类型字典
 keyType INTEGER example:@{@"keyName":WHDB_VALUETYPE_INTEGER};
 更多类型请查看 WHDB_VALUETYPE 声明
 @param tableName 表名
 @return YES OR NO
 */
- (BOOL)addKeyType:(NSDictionary*_Nonnull)keyTypes inTable:(NSString*_Nonnull)tableName;

/**
 为表添加字段
 
 @param keyTypes 字段类型字典
 keyType INTEGER example:@{@"keyName":WHDB_VALUETYPE_INTEGER};
 更多类型请查看 WHDB_VALUETYPE 声明
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)addKeyType:(NSDictionary*_Nonnull)keyTypes inTable:(NSString*_Nonnull)tableName error:(NSError * _Nullable * _Nullable)error;


#pragma mark - 增

/**
 添加行

 @param object 字典或模型
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)insertObject:(id _Nonnull)object toTable:(NSString*_Nonnull)tableName;

/**
 添加行
 
 @param object 字典或模型
 @param tableName 表名
 @return YES or NO
 */
- (BOOL)insertObject:(id _Nonnull)object toTable:(NSString* _Nonnull)tableName error:(NSError * _Nullable * _Nullable)error;


/**
 添加多行

 @param objects 数据数组
 @param tableName 表名
 @return YES or NO
 */
- (BOOL)insertObjects:(NSArray* _Nonnull)objects toTable:(NSString* _Nonnull)tableName;


/**
 添加多行
 
 @param objects 数据数组
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES or NO
 */
- (BOOL)insertObjects:(NSArray* _Nonnull)objects toTable:(NSString* _Nonnull)tableName error:(NSError * _Nullable * _Nullable)error;




#pragma mark - 删

/**
 删除单行数据
 @param object 模型或字典
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)removeObject:(id _Nonnull)object inTable:(NSString* _Nonnull)tableName;

/**
 删除单行数据
 @param object 条件字典/模型
 @param tableName 表名
 @param error 如果出错将被赋值
 @return 结果 YES or NO
 */
- (BOOL)removeObject:(id _Nonnull)object inTable:(NSString* _Nonnull)tableName error:(NSError * _Nullable * _Nullable)error;


/**
 删除多行数据

 @param objects 条件字典/模型 数组
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)removeObjects:(NSArray* _Nonnull)objects inTable:(NSString* _Nonnull)tableName;

/**
 删除多行数据
 
 @param objects 条件字典/模型 数组
 @param tableName 表名
 @param error 如果出错将被赋值
 @return 结果 YES or NO
 */
- (BOOL)removeObjects:(NSArray* _Nonnull)objects inTable:(NSString* _Nonnull)tableName error:(NSError * _Nullable * _Nullable)error;


/**
 删除所有行
 
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)removeAllRowsWithTable:(NSString* _Nonnull)tableName;

/**
 删除所有行
 
 @param tableName 表名
 @param error 如果出错将被赋值
 @return 结果 YES or NO
 */
- (BOOL)removeAllRowsWithTable:(NSString* _Nonnull)tableName error:(NSError * _Nullable * _Nullable)error;

/**
 删除表
 
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)removeTable:(NSString* _Nullable)tableName;

/**
 删除表
 
 @param tableName 表名
 @param error 如果出错将被赋值
 @return 结果 YES or NO
 */
- (BOOL)removeTable:(NSString* _Nullable)tableName error:(NSError * _Nullable *_Nullable)error;

#pragma mark - 改

/**
 更新一行数据

 @param object 模型或字典
 @param tableName 表名
 @return YES or NO
 */
- (BOOL)updateObject:(id _Nonnull)object condition:(NSDictionary* _Nullable)condition inTable:(NSString*_Nonnull)tableName;

/**
 更新一行数据
 
 @param object 模型或字典
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES or NO
 */
- (BOOL)updateObject:(id _Nonnull)object condition:(NSDictionary* _Nullable)condition inTable:(NSString* _Nonnull)tableName error:(NSError * _Nullable *_Nullable)error;

/**
 更新多行数据
 
 @param objects 模型或字典数组
 @param tableName 表名
 @return YES or NO
 */
- (BOOL)updateObjects:(NSArray * _Nonnull)objects conditions:(NSArray* _Nullable)conditions inTable:(NSString* _Nonnull)tableName;

/**
 更新多行数据
 
 @param objects 模型或字典数组
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES or NO
 */
- (BOOL)updateObjects:(NSArray * _Nonnull)objects conditions:(NSArray* _Nullable)conditions inTable:(NSString* _Nonnull)tableName error:(NSError * _Nullable *_Nullable)error;

/**
 修改符合条件的行

 @param object    模型或字典
 @param condition 条件字典
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)updateObject:(id _Nonnull)object
        forCondition:(NSDictionary* _Nullable)condition
             inTable:(NSString* _Nonnull)tableName;


/**
 修改符合条件的行

 @param condition 条件数组
 @param valueDic 修改后的键值对
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)updateForCondition:(NSDictionary* _Nonnull)condition
                   toValue:(NSDictionary* _Nonnull)valueDic
                   inTable:(NSString* _Nonnull)tableName;

#pragma mark - 查

/**
 查询两个表关联数据
 
 @param condition 空字段
 @param tableName 表名
 @return  返回字典数组 或 nil
 */
- (NSArray* _Nullable)queryRelationForCondition:(NSArray* _Nonnull)condition
                      relateCondition:(NSArray* _Nonnull)relateCondition
                            orderKeys:(NSArray* _Nullable)orderKeys
                              inTable:(NSString* _Nonnull)tableName
                          relateTable:(NSString* _Nonnull)relateTableName;

/**
 查询字段为空、排序 的结果数组
 
 @param nullKeys 空字段
 @param tableName 表名
 @return  返回字典数组 或 nil
 */
- (NSArray*_Nullable)queryForNullKeys:(NSArray* _Nonnull)nullKeys
                   orderKeys:(NSArray* _Nullable)orderKeys
                     inTable:(NSString* _Nonnull)tableName;

/**
 模糊查询符合条件、排序 的结果数组
 
 @param fuzzyondition 模糊条件字典
 @param tableName 表名
 @return  返回字典数组 或 nil
 */
- (NSArray*_Nullable)queryForFuzzyCondition:(NSDictionary* _Nonnull)fuzzyondition
                         orderKeys:(NSArray* _Nullable)orderKeys
                           inTable:(NSString* _Nonnull)tableName;


/**
 查询非空条件、排序 的结果数组
 
 @param keys key数组
 @param tableName 表名
 @return  返回字典数组 或 nil
 */
- (NSArray*_Nullable)queryForKeysNotNull:(NSArray* _Nonnull)keys
                      orderKeys:(NSArray* _Nullable)orderKeys
                        inTable:(NSString* _Nonnull)tableName;


/**
 查询符合条件、排序、 的结果数组
 
 @param condition 条件字典
 @param orderKeys 排序条件数组
 @param tableName 表名
 @return 返回字典数组 或 nil
 */
- (NSArray*_Nullable)queryForCondition:(NSDictionary* _Nonnull)condition
                    orderKeys:(NSArray* _Nullable)orderKeys
                      inTable:(NSString* _Nonnull)tableName;

/**
  查询符合条件、排序、限制个数 的结果数组

 @param condition 条件字典
 @param orderKeys 排序条件数组
 @param limit 数量限制
 @param tableName 表名
 @return 返回字典数组 或 nil
 */
- (NSArray*_Nullable)queryForCondition:(NSDictionary* _Nonnull)condition
                    orderKeys:(NSArray* _Nullable)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString* _Nonnull)tableName;

/**
 查询符合条件、限制更大条件、排序、限制个数 的结果数组
 
 @param condition 条件字典
 @param greaterDic 比较更大的条件字典
 @param orderKeys 排序条件数组
 @param limit 数量限制
 @param tableName 表名
 @return 返回字典数组 或 nil
 */
- (NSArray*_Nullable)queryForCondition:(NSDictionary*_Nullable)condition
           greaterThanOrEqual:(NSDictionary* _Nullable)greaterDic
                    orderKeys:(NSArray* _Nullable)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString* _Nonnull)tableName;
/**
 查询符合条件、限制更小条件、排序、限制个数 的结果数组
 
 @param condition 条件字典
 @param lessDic 比较更小的条件字典
 @param orderKeys 排序条件数组
 @param limit 数量限制
 @param tableName 表名
 @return 返回字典数组 或 nil
 */
- (NSArray*_Nullable)queryForCondition:(NSDictionary*_Nullable)condition
              lessThanOrEqual:(NSDictionary*_Nullable)lessDic
                    orderKeys:(NSArray*_Nullable)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString*_Nullable)tableName;

/**
 查询符合条件的结果数组
 
 @param condition 条件字典
 @param fuzzyCondition 模糊条件字典
 @param greaterDic 比较更大的条件字典
 @param lessDic 比较更小的条件字典
 @param orderKeys 排序条件数组
 @param limit 数量限制
 @param tableName 表名
 @return 返回字典数组 或 nil
 */
- (NSArray*_Nullable)queryForCondition:(NSDictionary*_Nullable)condition
               fuzzyCondition:(NSDictionary* _Nullable)fuzzyCondition
           greaterThanOrEqual:(NSDictionary* _Nullable)greaterDic
              lessThanOrEqual:(NSDictionary* _Nullable)lessDic
                  notNullKeys:(NSArray* _Nullable)notNullKeys
                    orderKeys:(NSArray* _Nullable)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString*_Nullable)tableName;


/**
 查询符合条件的结果数组///所有基本条件

 @param equalCondition 相等条件字典
 @param notEqualCondition 不相等条件字典
 @param greaterThanCondition 大于条件字典
 @param greaterOrEqualCondition 大于或等于条件字典
 @param lessThanCondition 小于条件字典
 @param lessThanOrEqualCondition 小于或等于字典
 @param betweenCondition 区间条件字典
 @param containsKeyArrayCondition 被包含数组条件字典
 @param notContainsKeyArrayCondition 不被包含数组条件字典
 @param containsStringCondition 包含字符串条件字典
 @param notContainsStringCondition 不包含字符串条件字典
 @param hasPrefixCondition 以某字符串开头条件字典
 @param notHasPrefixCondition 不以某字符串开头条件字典
 @param hasSubfixCondition 以某字符串结尾条件字典
 @param notHasSubfixCondition 不以某字符串结尾条件字典
 @param relationalKeyArrays 关联条件字典
 @param notNullKeys 非空key数组
 @param nullKeys 为空key数组
 @param ascendingKeys 升序key数组
 @param descendingKeys 降序key数组
 @param limit 数量限制条件
 @param tableName 表名
 @param isCount 是否是计数查询
 @return 字典数组 或 nil
 */
- (NSArray*_Nullable)queryForCondition:(NSDictionary*_Nullable)equalCondition
            notEqualCondition:(NSDictionary*_Nullable)notEqualCondition
                  greaterThan:(NSDictionary*_Nullable)greaterThanCondition
           greaterThanOrEqual:(NSDictionary*_Nullable)greaterOrEqualCondition
                     lessThan:(NSDictionary*_Nullable)lessThanCondition
              lessThanOrEqual:(NSDictionary*_Nullable)lessThanOrEqualCondition
                    betweenIn:(NSDictionary*_Nullable)betweenCondition
    containsKeyArrayCondition:(NSDictionary*_Nullable)containsKeyArrayCondition
  notContainKeyArrayCondition:(NSDictionary*_Nullable)notContainsKeyArrayCondition
      containsStringCondition:(NSDictionary*_Nullable)containsStringCondition
   notContainsStringCondition:(NSDictionary*_Nullable)notContainsStringCondition
           hasPrefixCondition:(NSDictionary*_Nullable)hasPrefixCondition
        notHasPrefixCondition:(NSDictionary*_Nullable)notHasPrefixCondition
           hasSubfixCondition:(NSDictionary*_Nullable)hasSubfixCondition
        notHasSubfixCondition:(NSDictionary*_Nullable)notHasSubfixCondition
          relationalKeyArrays:(NSArray*_Nullable)relationalKeyArrays
                  notNullKeys:(NSArray*_Nullable)notNullKeys
                     nullKeys:(NSArray*_Nullable)nullKeys
                ascendingKeys:(NSArray*_Nullable)ascendingKeys
               descendingKeys:(NSArray*_Nullable)descendingKeys
                        limit:(NSInteger)limit
                      isCount:(BOOL)isCount
                      inTable:(NSString*_Nullable)tableName
                        error:(NSError * _Nullable * _Nullable)error;

/**
 查询符合条件的数量

 @param condition 条件数组
 @return 数量
 */
- (NSInteger)countForCondition:(NSDictionary* _Nullable)condition inTable:(NSString*_Nullable)tableName;

@end
