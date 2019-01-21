//
//  FMDBManager.h
//  DriveLicense
//
//  Created by lwhldy on 2018/12/26.
//  Copyright © 2018年 lwhldy. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 整型 */
static NSString *const WHDB_VALUETYPE_INTEGER = @"INTEGER";
/** 浮点型 */
static NSString *const WHDB_VALUETYPE_FLOAT   = @"REAL";
/** 字符型 */
static NSString *const WHDB_VALUETYPE_STRING  = @"TEXT";
/** 二进制 */
static NSString *const WHDB_VALUETYPE_DATA    = @"BLOB";
/** NSDate */
static NSString *const WHDB_VALUETYPE_DATE    = @"DATE";
/** BOOL */
static NSString *const WHDB_VALUETYPE_BOOL    = @"BOOLEAN";
/** 由sqlite来确定亲和类型 如未设置类型 默认此类型 */
static NSString *const WHDB_VALUETYPE_NUMERIC = @"NUMERIC";

@interface WHDBManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, assign) BOOL defaultKeysEnable;

@property (nonatomic, strong) NSString *databasePath;

@property (nonatomic, strong, readonly) NSError *lastError;


#pragma mark - create database file
/**
 通过已存在的database文件创建数据库连接
 
 @param  path database文件路径
 @return BOOL YES OR NO
 */
- (BOOL)createExistingDBConnectionAndHoldWithPath:(NSString*)path;

/**
 通过已存在的database文件创建数据库连接

 @param path database文件路径
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)createExistingDBConnectionAndHoldWithPath:(NSString*)path error:(NSError **)error;

/**
 通过自定义databaseName来创建database文件

 @param databaseName 数据库名称
 @return YES OR NO
 */
- (BOOL)createDBFileAndHoldWithDBName:(NSString*)databaseName;

/**
 通过自定义databaseName来创建database文件

 @param databaseName 数据库名称
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)createDBFileAndHoldWithDBName:(NSString*)databaseName error:(NSError **)error;

/**
 通过自定义database路径来创建database文件

 @param path 路径
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)createDBFileAndHoldWithPath:(NSString*)path error:(NSError **)error;


/**
 切换当前database并持有
 
 @param path database路径
 @return YES OR NO
 */
- (BOOL)switchDBFileAndHoldWithPath:(NSString*)path;

/**
 切换当前database并持有
 
 @param path database路径
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)switchDBFileAndHoldWithPath:(NSString*)path error:(NSError **)error;



#pragma mark - create Table

/**
 通过tableName和keys创建表

 @param tableName 表名
 @param keys 字段数组
 @return YES OR NO
 */
- (BOOL)createTableWithTableName:(NSString*)tableName forKeys:(NSArray*)keys;

/**
 通过tableName和keys创建表

 @param tableName 表名
 @param keys 字段数组
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)createTableWithTableName:(NSString*)tableName forKeys:(NSArray*)keys error:(NSError **)error;

/**
 通过tableName和keyTypes创建表
 keyTypes INTEGER example:@{@"keyName":WHDB_VALUETYPE_INTEGER};
 所有类型请查看 WHDB_VALUETYPE 声明
 @param tableName 表名
 @param keyTypes keyTypes字典
 @return YES OR NO
 */
- (BOOL)createTableWithTableName:(NSString*)tableName forKeyTypes:(NSDictionary*)keyTypes;

/**
 通过tableName和keyTypes创建表
 keyTypes INTEGER example:@{@"keyName":WHDB_VALUETYPE_INTEGER};
 更多类型请查看 WHDB_VALUETYPE 声明
 @param tableName 表名
 @param keyTypes keyTypes字典
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)createTableWithTableName:(NSString*)tableName forKeyTypes:(NSDictionary*)keyTypes error:(NSError **)error;


/**
 修改表名

 @param oldTableName 原表名
 @param newTableName 新表名
 @return YES OR NO
 */
- (BOOL)updateOldTableName:(NSString *)oldTableName toNewTableName:(NSString *)newTableName;

/**
 修改表名
 
 @param oldTableName 原表名
 @param newTableName 新表名
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)updateOldTableName:(NSString *)oldTableName toNewTableName:(NSString *)newTableName error:(NSError **)error;

/**
 为表添加字段

 @param key 字段名
 @param tableName 表名
 @return YES OR NO
 */
- (BOOL)addKey:(NSString*)key inTable:(NSString*)tableName;

/**
 为表添加字段
 
 @param key 字段名
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)addKey:(NSString*)key inTable:(NSString*)tableName error:(NSError **)error;


/**
 为表添加字段
 
 @param keyTypes 字段类型字典
 keyType INTEGER example:@{@"keyName":WHDB_VALUETYPE_INTEGER};
 更多类型请查看 WHDB_VALUETYPE 声明
 @param tableName 表名
 @return YES OR NO
 */
- (BOOL)addKeyType:(NSDictionary*)keyTypes inTable:(NSString*)tableName;

/**
 为表添加字段
 
 @param keyTypes 字段类型字典
 keyType INTEGER example:@{@"keyName":WHDB_VALUETYPE_INTEGER};
 更多类型请查看 WHDB_VALUETYPE 声明
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)addKeyType:(NSDictionary*)keyTypes inTable:(NSString*)tableName error:(NSError **)error;


#pragma mark - 增

/**
 添加行

 @param object 字典或模型
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)insertObject:(id)object toTable:(NSString*)tableName;

/**
 添加行
 
 @param object 字典或模型
 @param tableName 表名
 @return YES or NO
 */
- (BOOL)insertObject:(id)object toTable:(NSString*)tableName error:(NSError **)error;


/**
 添加多行

 @param objects 数据数组
 @param tableName 表名
 @return YES or NO
 */
- (BOOL)insertObjects:(NSArray*)objects toTable:(NSString*)tableName;


/**
 添加多行
 
 @param objects 数据数组
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES or NO
 */
- (BOOL)insertObjects:(NSArray*)objects toTable:(NSString*)tableName error:(NSError **)error;




#pragma mark - 删

/**
 删除单行数据
 @param object 模型或字典
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)removeObject:(id)object inTable:(NSString*)tableName;

/**
 删除单行数据
 @param object 条件字典/模型
 @param tableName 表名
 @param error 如果出错将被赋值
 @return 结果 YES or NO
 */
- (BOOL)removeObject:(id)object inTable:(NSString*)tableName error:(NSError **)error;


/**
 删除多行数据

 @param objects 条件字典/模型 数组
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)removeObjects:(NSArray*)objects inTable:(NSString*)tableName;

/**
 删除多行数据
 
 @param objects 条件字典/模型 数组
 @param tableName 表名
 @param error 如果出错将被赋值
 @return 结果 YES or NO
 */
- (BOOL)removeObjects:(NSArray*)objects inTable:(NSString*)tableName error:(NSError **)error;


/**
 删除所有行
 
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)removeAllRowsWithTable:(NSString*)tableName;

/**
 删除所有行
 
 @param tableName 表名
 @param error 如果出错将被赋值
 @return 结果 YES or NO
 */
- (BOOL)removeAllRowsWithTable:(NSString*)tableName error:(NSError **)error;

/**
 删除表
 
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)removeTable:(NSString*)tableName;

/**
 删除表
 
 @param tableName 表名
 @param error 如果出错将被赋值
 @return 结果 YES or NO
 */
- (BOOL)removeTable:(NSString*)tableName error:(NSError **)error;

#pragma mark - 改

/**
 更新一行数据

 @param object 模型或字典
 @param tableName 表名
 @return YES or NO
 */
- (BOOL)updateObject:(id)object condition:(NSDictionary*)condition inTable:(NSString*)tableName;

/**
 更新一行数据
 
 @param object 模型或字典
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES or NO
 */
- (BOOL)updateObject:(id)object condition:(NSDictionary*)condition inTable:(NSString*)tableName error:(NSError **)error;

/**
 更新多行数据
 
 @param objects 模型或字典数组
 @param tableName 表名
 @return YES or NO
 */
- (BOOL)updateObjects:(NSArray *)objects conditions:(NSArray*)conditions inTable:(NSString*)tableName;

/**
 更新多行数据
 
 @param objects 模型或字典数组
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES or NO
 */
- (BOOL)updateObjects:(NSArray *)objects conditions:(NSArray*)conditions inTable:(NSString*)tableName error:(NSError **)error;

/**
 修改符合条件的行

 @param object    模型或字典
 @param condition 条件字典
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)updateObject:(id)object
        forCondition:(NSDictionary*)condition
             inTable:(NSString*)tableName;


/**
 修改符合条件是的行

 @param condition 条件数组
 @param valueDic 修改后的键值对
 @param tableName 表名
 @return 结果 YES or NO
 */
- (BOOL)updateForCondition:(NSDictionary*)condition
                   toValue:(NSDictionary*)valueDic
                   inTable:(NSString*)tableName;

#pragma mark - 查

/**
 查询两个表关联数据
 
 @param condition 空字段
 @param tableName 表名
 @return  返回字典数组 或 nil
 */
- (NSArray*)queryRelationForCondition:(NSArray*)condition
                      relateCondition:(NSArray*)relateCondition
                            orderKeys:(NSArray*)orderKeys
                              inTable:(NSString*)tableName
                          relateTable:(NSString*)relateTableName;

/**
 查询字段为空、排序 的结果数组
 
 @param nullKeys 空字段
 @param tableName 表名
 @return  返回字典数组 或 nil
 */
- (NSArray*)queryForNullKeys:(NSArray*)nullKeys
                   orderKeys:(NSArray*)orderKeys
                     inTable:(NSString*)tableName;

/**
 模糊查询符合条件、排序 的结果数组
 
 @param fuzzyondition 模糊条件字典
 @param tableName 表名
 @return  返回字典数组 或 nil
 */
- (NSArray*)queryForFuzzyCondition:(NSDictionary*)fuzzyondition
                         orderKeys:(NSArray*)orderKeys
                           inTable:(NSString*)tableName;


/**
 查询非空条件、排序 的结果数组
 
 @param keys key数组
 @param tableName 表名
 @return  返回字典数组 或 nil
 */
- (NSArray*)queryForKeysNotNull:(NSArray*)keys
                      orderKeys:(NSArray*)orderKeys
                        inTable:(NSString*)tableName;


/**
 查询符合条件、排序、 的结果数组
 
 @param condition 条件字典
 @param orderKeys 排序条件数组
 @param tableName 表名
 @return 返回字典数组 或 nil
 */
- (NSArray*)queryForCondition:(NSDictionary*)condition
                    orderKeys:(NSArray*)orderKeys
                      inTable:(NSString*)tableName;

/**
  查询符合条件、排序、限制个数 的结果数组

 @param condition 条件字典
 @param orderKeys 排序条件数组
 @param limit 数量限制
 @param tableName 表名
 @return 返回字典数组 或 nil
 */
- (NSArray*)queryForCondition:(NSDictionary*)condition
                    orderKeys:(NSArray*)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString*)tableName;

/**
 查询符合条件、限制更大条件、排序、限制个数 的结果数组
 
 @param condition 条件字典
 @param greaterDic 比较更大的条件字典
 @param orderKeys 排序条件数组
 @param limit 数量限制
 @param tableName 表名
 @return 返回字典数组 或 nil
 */
- (NSArray*)queryForCondition:(NSDictionary*)condition
           greaterThanOrEqual:(NSDictionary*)greaterDic
                    orderKeys:(NSArray*)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString*)tableName;
/**
 查询符合条件、限制更小条件、排序、限制个数 的结果数组
 
 @param condition 条件字典
 @param lessDic 比较更小的条件字典
 @param orderKeys 排序条件数组
 @param limit 数量限制
 @param tableName 表名
 @return 返回字典数组 或 nil
 */
- (NSArray*)queryForCondition:(NSDictionary*)condition
              lessThanOrEqual:(NSDictionary*)lessDic
                    orderKeys:(NSArray*)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString*)tableName;

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
- (NSArray*)queryForCondition:(NSDictionary*)condition
               fuzzyCondition:(NSDictionary*)fuzzyCondition
           greaterThanOrEqual:(NSDictionary*)greaterDic
              lessThanOrEqual:(NSDictionary*)lessDic
                  notNullKeys:(NSArray*)notNullKeys
                    orderKeys:(NSArray*)orderKeys
                        limit:(NSInteger)limit
                      inTable:(NSString*)tableName;


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
- (NSArray*)queryForCondition:(NSDictionary*)equalCondition
            notEqualCondition:(NSDictionary*)notEqualCondition
                  greaterThan:(NSDictionary*)greaterThanCondition
           greaterThanOrEqual:(NSDictionary*)greaterOrEqualCondition
                     lessThan:(NSDictionary*)lessThanCondition
              lessThanOrEqual:(NSDictionary*)lessThanOrEqualCondition
                    betweenIn:(NSDictionary*)betweenCondition
    containsKeyArrayCondition:(NSDictionary*)containsKeyArrayCondition
  notContainKeyArrayCondition:(NSDictionary*)notContainsKeyArrayCondition
      containsStringCondition:(NSDictionary*)containsStringCondition
   notContainsStringCondition:(NSDictionary*)notContainsStringCondition
           hasPrefixCondition:(NSDictionary*)hasPrefixCondition
        notHasPrefixCondition:(NSDictionary*)notHasPrefixCondition
           hasSubfixCondition:(NSDictionary*)hasSubfixCondition
        notHasSubfixCondition:(NSDictionary*)notHasSubfixCondition
          relationalKeyArrays:(NSArray*)relationalKeyArrays
                  notNullKeys:(NSArray*)notNullKeys
                     nullKeys:(NSArray*)nullKeys
                ascendingKeys:(NSArray*)ascendingKeys
               descendingKeys:(NSArray*)descendingKeys
                        limit:(NSInteger)limit
                      isCount:(BOOL)isCount
                      inTable:(NSString*)tableName
                        error:(NSError **)error;

/**
 查询符合条件的数量

 @param condition 条件数组
 @return 数量
 */
- (NSInteger)countForCondition:(NSDictionary*)condition inTable:(NSString*)tableName;

@end
