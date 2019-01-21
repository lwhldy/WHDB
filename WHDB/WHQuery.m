//
//  WHQuery.m
//  WHDBManager
//
//  Created by lwhldy on 2019/1/9.
//  Copyright © 2019年 lwhldy. All rights reserved.
//

#import "WHQuery.h"
#import "WHDBManager.h"

@interface WHQuery ()

@property (nonatomic, strong) NSMutableDictionary *equalKeyVaulues;
@property (nonatomic, strong) NSMutableDictionary *notEqualKeyVaulues;
@property (nonatomic, strong) NSMutableArray      *nullKeys;
@property (nonatomic, strong) NSMutableArray      *notNullKeys;
@property (nonatomic, strong) NSMutableDictionary *lessThanKeyValues;
@property (nonatomic, strong) NSMutableDictionary *greaterThanKeyValues;
@property (nonatomic, strong) NSMutableDictionary *lessThanOrEqualKeyValues;
@property (nonatomic, strong) NSMutableDictionary *greaterThanOrEqualKeyValues;
@property (nonatomic, strong) NSMutableDictionary *betweenKeyValues;
@property (nonatomic, strong) NSMutableDictionary *containsKeyArrays;
@property (nonatomic, strong) NSMutableDictionary *containsAllKeyArrays;
@property (nonatomic, strong) NSMutableDictionary *notContainsKeyArrays;
@property (nonatomic, strong) NSMutableDictionary *containsStringKeyValues;
@property (nonatomic, strong) NSMutableDictionary *notContainsStringKeyValues;
@property (nonatomic, strong) NSMutableDictionary *prefixKeyValues;
@property (nonatomic, strong) NSMutableDictionary *notHasPrefixKeyValues;
@property (nonatomic, strong) NSMutableDictionary *sufixKeyValues;
@property (nonatomic, strong) NSMutableDictionary *notHasSufixKeyValues;
@property (nonatomic, strong) NSMutableArray      *relationalKeyArrays;
@property (nonatomic, strong) NSMutableArray      *descendingArray;
@property (nonatomic, strong) NSMutableArray      *ascendingArray;

@end

@implementation WHQuery

#pragma mark - Init

- (instancetype)initWithTableName:(NSString *)tableName {
    self = [super init];
    if (self) {
        self.tableName = tableName;
    }
    return self;
}

+ (instancetype)queryWithTableName:(NSString *)tableName {
    WHQuery *query = [[WHQuery alloc] initWithTableName:tableName];
    return query;
}

#pragma mark - Options

- (void)whereKeyIsNull:(NSString *)nullkey {
    if (!nullkey) {
        return;
    }
    if (!self.nullKeys) {
        self.nullKeys = [NSMutableArray array];
    }
    
    [self.nullKeys addObject:nullkey];
}

- (void)whereKeyNotNull:(NSString *)notNullkey {
    if (!notNullkey) {
        return;
    }
    if (!self.notNullKeys) {
        self.notNullKeys = [NSMutableArray array];
    }
    
    [self.notNullKeys addObject:notNullkey];
}

- (void)whereKey:(NSString *)key equalTo:(id)object {
    if (!key || !object) {
        return;
    }
    if (!self.equalKeyVaulues) {
        self.equalKeyVaulues = [NSMutableDictionary dictionary];
    }
    
    [self.equalKeyVaulues setObject:object forKey:key];
}

- (void)whereKey:(NSString *)key notEqualTo:(id)object {
    if (!key || !object) {
        return;
    }
    if (!self.notEqualKeyVaulues) {
        self.notEqualKeyVaulues = [NSMutableDictionary dictionary];
    }
    
    [self.notEqualKeyVaulues setObject:object forKey:key];
}

- (void)whereKey:(NSString *)key lessThan:(id)object {
    if (!key || !object) {
        return;
    }
    if (!self.lessThanKeyValues) {
        self.lessThanKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.lessThanKeyValues setObject:object forKey:key];
}

- (void)whereKey:(NSString *)key lessThanOrEqual:(id)object {
    if (!key || !object) {
        return;
    }
    if (!self.lessThanOrEqualKeyValues) {
        self.lessThanOrEqualKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.lessThanOrEqualKeyValues setObject:object forKey:key];
}

- (void)whereKey:(NSString *)key greaterThan:(id)object {
    if (!key || !object) {
        return;
    }
    if (!self.greaterThanKeyValues) {
        self.greaterThanKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.greaterThanKeyValues setObject:object forKey:key];
}

- (void)whereKey:(NSString *)key greaterThanOrEqual:(id)object{
    if (!key || !object) {
        return;
    }
    if (!self.greaterThanOrEqualKeyValues) {
        self.greaterThanOrEqualKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.greaterThanOrEqualKeyValues setObject:object forKey:key];
}

- (void)whereKey:(NSString *)key betweenIn:(NSArray *)betweenArray {
    if (!key || betweenArray.count != 2) {
        return;
    }
    if (!self.betweenKeyValues) {
        self.betweenKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.betweenKeyValues setObject:betweenArray forKey:key];
}

- (void)whereKey:(NSString *)key containedIn:(NSArray *)array {
    if (!key || !array.count) {
        return;
    }
    if (!self.containsKeyArrays) {
        self.containsKeyArrays = [NSMutableDictionary dictionary];
    }
    
    [self.containsKeyArrays setObject:array forKey:key];
}

- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array {
    if (!key || !array.count) {
        return;
    }
    if (!self.notContainsKeyArrays) {
        self.notContainsKeyArrays = [NSMutableDictionary dictionary];
    }
    
    [self.notContainsKeyArrays setObject:array forKey:key];
}

- (void)whereKey:(NSString *)key containsAllObjectsInArray:(NSArray *)array {
    if (!key || !array.count) {
        return;
    }
    if (!self.containsAllKeyArrays) {
        self.containsAllKeyArrays = [NSMutableDictionary dictionary];
    }
    
    [self.containsAllKeyArrays setObject:array forKey:key];
}

- (void)whereKey:(NSString *)key containsString:(NSString *)substring {
    if (!key || !substring) {
        return;
    }
    if (!self.containsStringKeyValues) {
        self.containsStringKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.containsStringKeyValues setObject:substring forKey:key];
}


- (void)whereKey:(NSString *)key notContainsString:(NSString *)substring {
    if (!key || !substring) {
        return;
    }
    if (!self.notContainsStringKeyValues) {
        self.notContainsStringKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.notContainsStringKeyValues setObject:substring forKey:key];
}


- (void)whereKey:(NSString *)key hasPrefix:(NSString *)prefix {
    if (!key || !prefix) {
        return;
    }
    if (!self.prefixKeyValues) {
        self.prefixKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.prefixKeyValues setObject:prefix forKey:key];
}

- (void)whereKey:(NSString *)key notHasPrefix:(NSString *)prefix {
    if (!key || !prefix) {
        return;
    }
    if (!self.notHasPrefixKeyValues) {
        self.notHasPrefixKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.notHasPrefixKeyValues setObject:prefix forKey:key];
}



- (void)whereKey:(NSString *)key hasSuffix:(NSString *)suffix {
    if (!key || !suffix) {
        return;
    }
    if (!self.sufixKeyValues) {
        self.sufixKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.sufixKeyValues setObject:suffix forKey:key];
}

- (void)whereKey:(NSString *)key notHasSuffix:(NSString *)suffix {
    if (!key || !suffix) {
        return;
    }
    if (!self.notHasSufixKeyValues) {
        self.notHasSufixKeyValues = [NSMutableDictionary dictionary];
    }
    
    [self.notHasSufixKeyValues setObject:suffix forKey:key];
}

#pragma mark - Sorting

- (void)orderByAscending:(NSString *)key {
    if (!key) {
        return;
    }
    if (!self.ascendingArray) {
        self.ascendingArray = [NSMutableArray array];
    }
    
    [self.ascendingArray addObject:key];
}

- (void)orderByDescending:(NSString *)key {
    if (!key) {
        return;
    }
    if (!self.descendingArray) {
        self.descendingArray = [NSMutableArray array];
    }
    
    [self.descendingArray addObject:key];
}

#pragma mark -  Relation query 关联查询

- (void)whereKey:(NSString *)key equalToRelationalKey:(NSString *)relationalKey inRelationalTable:(NSString *)relationTableName {
    if (!key || !relationalKey || !relationTableName) {
        return;
    }
    if (!self.relationalKeyArrays) {
        self.relationalKeyArrays = [NSMutableArray array];
    }
    [self.relationalKeyArrays addObject:@{key:@{relationalKey:relationTableName}}];
}


#pragma mark -  Find methods

- (NSArray *)findObjects {
    
    return [self findObjects:nil];
}

- (NSArray *)findObjects:(NSError *__autoreleasing *)error {
    NSArray *results = [self findObjectsWithIsCount:NO error:error];
    if (results.count) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in results) {
            WHObject *object = [WHObject objectWithTableName:self.tableName];
            NSMutableDictionary *keyValues = [object valueForKey:@"keyValues"];
            if ([dic.allKeys containsObject:@"primaryId"]) {
                [object setValue:[dic valueForKey:@"primaryId"] forKey:@"primaryId"];
                NSDate *createdAt = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"createdAt"] floatValue]];
                NSDate *updatedAt = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"createdAt"] floatValue]];
                [object setValue:createdAt forKey:@"createdAt"];
                [object setValue:updatedAt forKey:@"updatedAt"];
            }
            [keyValues addEntriesFromDictionary:dic];
            [array addObject:object];
        }
        return array;
    }else {
        return nil;
    }
}

- (NSArray *)findObjectsWithIsCount:(BOOL)isCount error:(NSError **)error {
    NSArray *results = [[WHDBManager shareManager] queryForCondition:self.equalKeyVaulues
                                                   notEqualCondition:self.notEqualKeyVaulues
                                                         greaterThan:self.greaterThanKeyValues
                                                  greaterThanOrEqual:self.greaterThanOrEqualKeyValues
                                                            lessThan:self.lessThanKeyValues
                                                     lessThanOrEqual:self.lessThanOrEqualKeyValues
                                                           betweenIn:self.betweenKeyValues
                                           containsKeyArrayCondition:self.containsKeyArrays
                                         notContainKeyArrayCondition:self.notContainsKeyArrays
                                             containsStringCondition:self.containsStringKeyValues
                                          notContainsStringCondition:self.notContainsStringKeyValues
                                                  hasPrefixCondition:self.prefixKeyValues
                                               notHasPrefixCondition:self.notHasPrefixKeyValues
                                                  hasSubfixCondition:self.sufixKeyValues
                                               notHasSubfixCondition:self.notHasSufixKeyValues
                                                 relationalKeyArrays:self.relationalKeyArrays
                                                         notNullKeys:self.notNullKeys
                                                            nullKeys:self.nullKeys
                                                       ascendingKeys:self.ascendingArray
                                                      descendingKeys:self.descendingArray
                                                               limit:self.limit
                                                             isCount:isCount
                                                             inTable:self.tableName
                                                               error:error];
    
    return results;
}

- (void)findObjectsInBackgroundWithBlock:(WHArrayResultBlock)block {
    
}

#pragma mark -  Get methods

+ (WHObject *)getObjectWithTableName:(NSString *)tableName primaryId:(NSNumber *)primaryId {
    
    return [[self class] getObjectWithTableName:tableName primaryId:primaryId error:nil];
}

+ (WHObject *)getObjectWithTableName:(NSString *)tableName primaryId:(NSNumber *)primaryId error:(NSError *__autoreleasing *)error {
    return [[WHQuery queryWithTableName:tableName] getObjectWithPrimaryId:primaryId error:error];
}


- (WHObject *)getObjectWithPrimaryId:(NSNumber *)primaryId {
    return [self getObjectWithPrimaryId:primaryId error:nil];
}

- (WHObject *)getObjectWithPrimaryId:(NSNumber *)primaryId error:(NSError *__autoreleasing *)error {
    if (!primaryId || !self.tableName) {
        return nil;
    }
    NSArray *array = [[WHDBManager shareManager] queryForCondition:@{@"primaryId":primaryId} orderKeys:nil inTable:self.tableName];
    if (array.count) {
        NSDictionary *dic = array.firstObject;
        WHObject *object = [WHObject objectWithTableName:self.tableName];
        NSMutableDictionary *keyValues = [object valueForKey:@"keyValues"];
        [keyValues addEntriesFromDictionary:dic];
        if ([keyValues.allKeys containsObject:@"primaryId"]) {
            [object setValue:[keyValues valueForKey:@"primaryId"] forKey:@"primaryId"];
            [object setValue:[keyValues valueForKey:@"createdAt"] forKey:@"createdAt"];
            [object setValue:[keyValues valueForKey:@"updatedAt"] forKey:@"updatedAt"];
        }
        return object;
    }else {
        return nil;
    }
}

#pragma mark -  Delete methods

- (BOOL)deleteAll {
    return [self deleteAll:nil];
}

- (BOOL)deleteAll:(NSError *__autoreleasing *)error {
    return [[WHDBManager shareManager] removeAllRowsWithTable:self.tableName error:error];
}

#pragma mark -  Count methods

- (NSInteger)countObjects {
    return [self countObjects:nil];
}

- (NSInteger)countObjects:(NSError *__autoreleasing *)error {
    
    NSArray *results = [self findObjectsWithIsCount:YES error:error];
    if (results.count) {
        NSDictionary *result = results.firstObject;
        NSString *key = result.allKeys.firstObject;
        return [[result objectForKey:key] integerValue];
    }else {
        return 0;
    }
}



@end
