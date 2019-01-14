//
//  WHQuery.h
//  WHDBManager
//
//  Created by 林文华 on 2019/1/9.
//  Copyright © 2019年 lwhldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHObject.h"

typedef void(^WHArrayResultBlock)(NSArray *objects, NSError *error);
typedef void(^WHIntegerResultBlock)(NSInteger number, NSError *error);
typedef void(^WHObjectResultBlock)(WHObject *object, NSError *error);

@interface WHQuery : NSObject

#pragma Init

/**
 通过表名创建一个新的 WHQuery 对象

 @param tableName 表名
 @return WHQuery 对象
 */
- (instancetype)initWithTableName:(NSString*)tableName;


/**
 通过表名创建一个新的 WHQuery 对象

 @param tableName 表名
 @return WHQuery 对象
 */
+ (instancetype)queryWithTableName:(NSString *)tableName;

#pragma mark - Properties
/** 表名 */
@property (nonatomic, copy) NSString *tableName;

/**
 限制数量 当为计数查询是无效
 */
@property (nonatomic, assign) NSInteger limit;

#pragma mark - Options

/**
 添加键为key的值非空的约束
 
 @param notNullkey 非空键
 */
- (void)whereKeyNotNull:(NSString*)notNullkey;

/**
 添加键为key的值为空的约束
 
 @param nullkey 值为空的key
 */
- (void)whereKeyIsNull:(NSString*)nullkey;

/**
 添加键为key 值为object约束

 @param key 键
 @param object 值
 */
- (void)whereKey:(NSString*)key equalTo:(id)object;

/**
 添加键为key 值不为object约束
 
 @param key 键
 @param object 值
 */
- (void)whereKey:(NSString*)key notEqualTo:(id)object;

/**
 添加键为key的值为小于object的约束
 
 @param key 键
 @param object 值
 */
- (void)whereKey:(NSString*)key lessThan:(id)object;

/**
 添加键为key的值为小于或等于object的约束
 
 @param key 键
 @param object 值
 */
- (void)whereKey:(NSString*)key lessThanOrEqual:(id)object;

/**
 添加键为key的值为大于object的约束
 
 @param key 键
 @param object 值
 */
- (void)whereKey:(NSString*)key greaterThan:(id)object;

/**
 添加键为key的值为大于或等于object的约束
 
 @param key 键
 @param object 值
 */
- (void)whereKey:(NSString*)key greaterThanOrEqual:(id)object;

/**
 添加键为key的值为大于或等于object的约束
 
 @param key 键
 @param betweenArray 区间数据
 数组仅允许包含左区间和右区间两个元素 否则无结果
 */
- (void)whereKey:(NSString*)key betweenIn:(NSArray*)betweenArray;

/**
 添加键为key的值存在于array中的约束

 @param key 键
 @param array 数组
 */
- (void)whereKey:(NSString *)key containedIn:(NSArray *)array;

/**
 添加键为key的值不存在于array中的约束
 
 @param key 键
 @param array 数组
 */
- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array;

/**
 添加键为key的 数组内的每个值都存在于array中的约束

 @param key 键
 @param array 数组
 */
- (void)whereKey:(NSString *)key containsAllObjectsInArray:(NSArray *)array;

/**
 添加键为key的 字符串包含substring的约束
 
 @param key 键
 @param substring 子字符串
 */
- (void)whereKey:(NSString *)key containsString:(NSString *)substring;

/**
 添加键为key的 字符串包不含substring的约束
 
 @param key 键
 @param substring 子字符串
 */
- (void)whereKey:(NSString *)key notContainsString:(NSString *)substring;

/**
 添加键为key 的字符串以prefix为开头的约束

 @param key 键
 @param prefix 起始字符串
 */
- (void)whereKey:(NSString *)key hasPrefix:(NSString *)prefix;

/**
 添加键为key 的字符串不以prefix为开头的约束
 
 @param key 键
 @param prefix 起始字符串
 */
- (void)whereKey:(NSString *)key notHasPrefix:(NSString *)prefix;

/**
 添加键为key 的字符串以suffix为结尾的约束
 
 @param key 键
 @param suffix 结尾字符串
 */
- (void)whereKey:(NSString *)key hasSuffix:(NSString *)suffix;

/**
 添加键为key 的字符串不以suffix为结尾的约束
 
 @param key 键
 @param suffix 结尾字符串
 */
- (void)whereKey:(NSString *)key notHasSuffix:(NSString *)suffix;


#pragma mark - Sorting

/**
 添加以键为Key的升序约束
 
 @param key 键
 */
- (void)orderByAscending:(NSString*)key;

/**
 添加以键为Key的降序约束

 @param key 键
 */
- (void)orderByDescending:(NSString*)key;

#pragma mark -  Relation query 关联查询

/**
 添加初始化表内 key的值 等于另一个relationalTable(关联表)中 relationalKey的值的约束
 
 @param key 主表的key
 @param relationalKey 关联表的key
 @param relationTableName 关联的表名
 */
- (void)whereKey:(NSString*)key equalToRelationalKey:(NSString*)relationalKey inRelationalTable:(NSString*)relationTableName;


#pragma mark -  Find methods

- (NSArray *)findObjects;

- (NSArray *)findObjects:(NSError **)error;

//- (void)findObjectsInBackgroundWithBlock:(WHArrayResultBlock)block;


#pragma mark -  Get methods

+ (WHObject *)getObjectWithTableName:(NSString*)tableName
                           primaryId:(NSNumber*)primaryId;

+ (WHObject *)getObjectWithTableName:(NSString*)tableName
                           primaryId:(NSNumber*)primaryId
                               error:(NSError **)error;

- (WHObject *)getObjectWithPrimaryId:(NSNumber*)primaryId;

- (WHObject *)getObjectWithPrimaryId:(NSNumber*)primaryId
                               error:(NSError **)error;

#pragma mark -  Delete methods

- (BOOL)deleteAll;

- (BOOL)deleteAll:(NSError **)error;

#pragma mark -  Count methods

- (NSInteger)countObjects;

- (NSInteger)countObjects:(NSError **)error;

#pragma mark - Or Query methods (或查询)

+ (NSArray*)findObjectsForOrQueries:(NSArray<WHQuery *> *)queries;

+ (NSArray*)findObjectsForOrQueries:(NSArray<WHQuery *> *)queries error:(NSError **)error;

+ (NSInteger)countObjectsForAndQueries:(NSArray<WHQuery *> *)queries;

+ (NSInteger)countObjectsForAndQueries:(NSArray<WHQuery *> *)queries error:(NSError **)error;

@end
