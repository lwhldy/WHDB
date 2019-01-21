//
//  WHObject.m
//  WHDBManager
//
//  Created by lwhldy on 2019/1/4.
//  Copyright © 2019年 lwhldy. All rights reserved.
//

#import "WHObject.h"
#import "WHDBManager.h"

@interface WHObject ()
@property (nonatomic, strong) NSMutableDictionary *keyValues;

@property (nonatomic, strong, readwrite) NSNumber *primaryId;
@property (nonatomic, strong, readwrite) NSDate   *updatedAt;
@property (nonatomic, strong, readwrite) NSDate   *createdAt;
@property (nonatomic, strong, readwrite) NSString *tableName;


@end

@implementation WHObject

- (instancetype)initWithTableName:(NSString *)tableName {
    self = [super init];
    if (self) {
        self.tableName = tableName;
        self.keyValues = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)objectWithTableName:(NSString *)tableName {
    return [[WHObject alloc] initWithTableName:tableName];
}

+ (instancetype)objectWithTableName:(NSString *)tableName primaryId:(NSNumber *)primaryId {
    WHObject *object  = [[WHObject alloc] initWithTableName:tableName];
    object.primaryId = primaryId;
    return object;
}

+ (instancetype)objectWithTableName:(NSString *)tableName dictionary:(NSDictionary *)dictionary {
    WHObject *object = [[WHObject alloc] initWithTableName:tableName];
    for (NSString *key in dictionary.allKeys) {
        id value = [dictionary valueForKey:key];
        [object setObject:value forKey:key];
    }
    return object;
}

#pragma setter && getter

- (void)setObject:(id)object forKey:(NSString *)key {
    if (object == nil) {
        if (key) {
            [self removeObjectForKey:key];
        }
        return;
    }
    
    if ([WHDBManager shareManager].defaultKeysEnable && [[WHObject invalidKeys] containsObject:key]) {
        NSException *exception = [NSException exceptionWithName:@"WHDB error" reason:[NSString stringWithFormat:@"'%@'键被保留.", key] userInfo:nil];
        [exception raise];
    }
    if (![object isKindOfClass:[NSNumber class]] &&
        ![object isKindOfClass:[NSData class]]  &&
        ![object isKindOfClass:[NSString class]] &&
        ![object isKindOfClass:[NSDate class]] ) {
        
        NSException *exception = [NSException exceptionWithName:@"WHDB error" reason:[NSString stringWithFormat:@"对象不是可用的存储类型."] userInfo:nil];
        [exception raise];
    }
    [self.keyValues setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    if ([[self allKeys] containsObject:key]) {
        [self.keyValues removeObjectForKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    if ([[self allKeys] containsObject:key]) {
       return [self.keyValues valueForKey:key];
    }
    return nil;
}

- (void)setObjectsWithDictionary:(NSDictionary *)dictionary {
    for (NSString *key in dictionary.allKeys) {
        id value = [dictionary valueForKey:key];
        [self setObject:value forKey:key];
    }
}

- (NSDictionary *)dictionaryForObject {
    if (self.keyValues.count) {
        return self.keyValues.copy;
    }
    return nil;
}

- (NSArray*)allKeys {
    return self.keyValues.allKeys;
}

#pragma mark - Table Methods

+ (BOOL)addColumnWithKey:(NSString *)key inTable:(NSString *)tableName {
    return [[self class] addColumnWithKey:key inTable:tableName error:nil];
}

+ (BOOL)addColumnWithKey:(NSString *)key inTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (!key) {
        return NO;
    }
    return [[self class] addColumnWithKeyType:@{key:WHDB_VALUETYPE_NUMERIC} inTable:tableName error:error];
}

+ (BOOL)addColumnWithKeyType:(NSDictionary *)keyType inTable:(NSString *)tableName {
    
    return [[self class] addColumnWithKeyType:keyType inTable:tableName error:nil];
}

+ (BOOL)addColumnWithKeyType:(NSDictionary *)keyType inTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    if (!keyType) {
        return NO;
    }
    return [[WHDBManager shareManager] addKeyType:keyType inTable:tableName error:error];
}

#pragma mark - Save

- (BOOL)save {
    return [self save:nil];
}

- (BOOL)save:(NSError *__autoreleasing *)error {
    if ([WHDBManager shareManager].defaultKeysEnable) {
        [self.keyValues setValue:[NSDate date] forKey:@"updatedAt"];
        [self.keyValues setValue:[NSDate date] forKey:@"createdAt"];
    }
    return [[WHDBManager shareManager] insertObject:self.keyValues toTable:self.tableName error:error];
    
}

+ (BOOL)saveAll:(NSArray<WHObject *> *)objects inTable:(NSString *)tableName {
    return [[self class] saveAll:objects inTable:tableName];
}

+ (BOOL)saveAll:(NSArray<WHObject *> *)objects inTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    NSMutableArray *dictionaryArray = [NSMutableArray array];
    for (WHObject *obj in objects) {
        if ([WHDBManager shareManager].defaultKeysEnable) {
            [obj.keyValues setValue:[NSDate date] forKey:@"updatedAt"];
            [obj.keyValues setValue:[NSDate date] forKey:@"createdAt"];
        }
        [dictionaryArray addObject:[obj dictionaryForObject]];
    }
    return [[WHDBManager shareManager] insertObjects:dictionaryArray toTable:tableName error:error];
}


#pragma mark - update

- (BOOL)updateWithCondition:(NSDictionary *)condition {
    return [self updateWithCondition:condition error:nil];
}

- (BOOL)updateWithCondition:(NSDictionary *)condition error:(NSError *)error {
    return [[WHDBManager shareManager] updateObject:self.keyValues condition:condition inTable:self.tableName];
}

+ (BOOL)updateAll:(NSArray<WHObject *> *)objects conditions:(NSArray *)conditions inTable:(NSString *)tableName {
    return [[self class] updateAll:objects conditions:conditions inTable:tableName error:nil];
}

+ (BOOL)updateAll:(NSArray<WHObject *> *)objects conditions:(NSArray *)conditions inTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    NSMutableArray *dictionaryArray = [NSMutableArray array];
    for (WHObject *obj in objects) {
        [dictionaryArray addObject:[obj dictionaryForObject]];
    }
    return [[WHDBManager shareManager] updateObjects:dictionaryArray conditions:conditions inTable:tableName error:error];
}


#pragma mark - Delete

- (BOOL)delete {
    return [self delete:nil];
}

- (BOOL)delete:(NSError *__autoreleasing *)error {
    return [[WHDBManager shareManager] removeObject:self.keyValues inTable:self.tableName];
}


+ (BOOL)deleteAll:(NSArray<WHObject *> *)objects inTable:(NSString*)tableName {
    return [[self class] deleteAll:objects inTable:tableName error:nil];
}

+ (BOOL)deleteAll:(NSArray<WHObject *> *)objects inTable:(NSString*)tableName error:(NSError *__autoreleasing *)error {
    NSMutableArray *dictionaryArray = [NSMutableArray array];
    for (WHObject *obj in objects) {
        [dictionaryArray addObject:[obj dictionaryForObject]];
    }
    return [[WHDBManager shareManager] removeObjects:dictionaryArray inTable:tableName error:error];
}

+ (BOOL)deleteAllInTable:(NSString *)tableName {
    return [self deleteAllInTable:tableName error:nil];
}

+ (BOOL)deleteAllInTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    return [[WHDBManager shareManager] removeAllRowsWithTable:tableName error:error];
}

+ (BOOL)deleteTable:(NSString *)tableName {
    return [self deleteTable:tableName error:nil];
}

+ (BOOL)deleteTable:(NSString *)tableName error:(NSError *__autoreleasing *)error {
    return [[WHDBManager shareManager] removeTable:tableName error:error];
}

#pragma Properties

- (NSDate *)updatedAt {
    return [self.keyValues objectForKey:@"updatedAt"];
}

- (NSDate *)createdAt {
    return [self.keyValues objectForKey:@"createdAt"];
}

- (NSNumber *)primaryId {
    return [self.keyValues objectForKey:@"primaryId"];
}

+ (NSArray *)invalidKeys {
    static NSArray *_invalidKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _invalidKeys = @[
                         @"primaryId",
                         @"createdAt",
                         @"updatedAt"
                         ];
    });
    return _invalidKeys;
}


@end
