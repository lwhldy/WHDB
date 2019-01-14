//
//  WHObject.h
//  WHDBManager
//
//  Created by 林文华 on 2019/1/4.
//  Copyright © 2019年 lwhldy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^WHBoolResultBlock)(BOOL succeeded,  NSError *error);

@interface WHObject : NSObject

#pragma mark -  Init

/**
 通过tableName初始化一个新的Object

 @param tableName 表名
 @return WHObject对象
 */
- (instancetype)initWithTableName:(NSString*)tableName;
/**
 通过表名创建新的 WHObject
 
 @param tableName 表名
 @return WHObject对象
 */
+ (instancetype)objectWithTableName:(NSString*)tableName;

/**
 通过表名和主键id创建一个已经存在的WHObject

 @param tableName 表名
 @param primaryId 主键值
 @return WHObject对象
 */
+ (instancetype)objectWithTableName:(NSString*)tableName primaryId:(NSNumber*)primaryId;
/**
 通过表名和字典创建一个新的 WHObject
 
 @param tableName 表名
 @param dictionary 字典
 @return WHObject对象
 */
+ (instancetype)objectWithTableName:(NSString*)tableName dictionary:(NSDictionary*)dictionary;


#pragma Properties
/** 主键id */
@property (nonatomic, strong, readonly) NSNumber *primaryId;
/** 更新时间 */
@property (nonatomic, strong, readonly) NSDate *updatedAt;
/** 创建时间 */
@property (nonatomic, strong, readonly) NSDate *createdAt;
/** 表名 */
@property (nonatomic, strong, readonly) NSString *tableName;
/** 所有的key数组 */
@property (nonatomic, strong, readonly) NSArray *allKeys;
/** 预留字段 如果WHDBManager的defaultKeys为YES才生效 默认不生效*/
+ (NSArray *)invalidKeys;

#pragma Setter && Getter

/**
 添加键值对

 @param object 对象
 限定: NSNumer NSData NSString NSDate
 @param key 键
 */
- (void)setObject:(id)object forKey:(NSString*)key;

/**
 通过键获取值

 @param key 键
 @return 值
 */
- (id)objectForKey:(NSString *)key;


/**
  通过键移除值

 @param key 键
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 通过字典添加值
 
 @param dictionary 字典
 */
- (void)setObjectsWithDictionary:(NSDictionary*)dictionary;

/**
 获取对象的所有键值对

 @return NSDictionary
 */
- (NSDictionary*)dictionaryForObject;

#pragma mark - Save

/**
 保存/更新-如果已经存在的话

 @return YES OR NO
 */
- (BOOL)save;

/**
 保存/更新-如果已经存在的话

 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)save:(NSError **)error;


/**
 批量保存

 @param objects WHObject数组
 @param tableName 表名
 @return YES OR NO
 */
+ (BOOL)saveAll:(NSArray<WHObject *> *)objects inTable:(NSString*)tableName;

/**
 批量保存
 
 @param objects WHObject数组
 @param tableName 表名
 @param error 如果出错将被赋值
 @return YES OR NO
 */
+ (BOOL)saveAll:(NSArray<WHObject *> *)objects inTable:(NSString*)tableName error:(NSError **)error;


#pragma mark - Delete

/**
 删除

 @return YES OR NO
 */
- (BOOL)delete;

/**
 删除

 @param error 如果出错将被赋值
 @return YES OR NO
 */
- (BOOL)delete:(NSError **)error;

/**
 保存对象数组

 @param objects WHObject 数组
 @return YES OR NO
 */
+ (BOOL)deleteAll:(NSArray<WHObject *>*)objects inTable:(NSString*)tableName;

/**
 保存对象数组

 @param objects WHObject 数组
 @param error 如果出错将被赋值
 @return YES OR NO
 */
+ (BOOL)deleteAll:(NSArray<WHObject *>*)objects inTable:(NSString*)tableName error:(NSError **)error;



@end
