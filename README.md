# WHDB
基于FMDB的二次封装库，实现了大多数基础的sqlite数据库操作，使用简单，不会sqlite语句也可以轻松使用sqlite实现本地数据存储

# Installation

```
pod 'WHDB'

Run pod install or pod update.

Import <WHDB.h>.
```
#
# Usage

    //使用WHObject或WHQuery 必须初始化数据库
    ```
    NSError *error = nil;
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"Test.sqlite"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //根据名称创建数据库文件
        [[WHDBManager shareManager] createDBFileAndHoldWithDBName:@"Test" error:&error];
    }else {
        //也可以建立已经存在的数据库文件连接
        [[WHDBManager shareManager] createExistingDBConnectionAndHoldWithPath:path error:&error];
        //删除表内所有数据
        [WHObject deleteAllInTable:@"student" error:&error];
        //删除表
        [WHObject deleteTable:@"student" error:&error];
        
        //删除表内所有数据
        [WHObject deleteAllInTable:@"score" error:&error];
        //删除表
        [WHObject deleteTable:@"score" error:&error];
    }
    
    if (error) {
        NSLog(@"CreateBD error === %@", error);
        return;
    }
    ```
    //此属性默认为NO 设置为YES时 创建 表示默认加入updatedAt createdAt primaryId三个字段
    [WHDBManager shareManager].defaultKeysEnable = YES;
    //根据提供的表名 字段名：属性 字典来创建表
    [[WHDBManager shareManager] createTableWithTableName:@"student"
                                             forKeyTypes:@{@"student_id":WHDB_VALUETYPE_INTEGER,
                                                           @"name":WHDB_VALUETYPE_STRING,
                                                           @"age":WHDB_VALUETYPE_INTEGER,
                                                           @"height":WHDB_VALUETYPE_FLOAT,
                                                           @"boy":WHDB_VALUETYPE_BOOL}
                                                   error:&error];
    [[WHDBManager shareManager] createTableWithTableName:@"score"
                                             forKeyTypes:@{@"name":WHDB_VALUETYPE_STRING,
                                                           @"studentId":WHDB_VALUETYPE_INTEGER,
                                                           @"test_score":WHDB_VALUETYPE_INTEGER}
                                                   error:&error];
    
    if (error) {
        NSLog(@"Create table error === %@", error);
        return;
    }
    
    //写入student
    NSMutableArray *stus = [NSMutableArray array];
    for (NSInteger i = 0; i < 1000; i++) {
        WHObject *obj = [WHObject objectWithTableName:@"student"];
        [obj setObject:[NSString stringWithFormat:@"st%ld", i] forKey:@"name"];
        [obj setObject:@(i+1) forKey:@"student_id"];
        [obj setObject:[NSString stringWithFormat:@"%d", arc4random()%8 + 10] forKey:@"age"];
        [obj setObject:[NSString stringWithFormat:@"%.2lf", arc4random()%100 + 80.5] forKey:@"height"];
        [obj setObject:i%2==0?@(YES):@(NO) forKey:@"boy"];
        [stus addObject:obj];
    }
    [WHObject saveAll:stus inTable:@"student" error:&error];
    if (error) {
        NSLog(@"student save data error === %@", error);
        return;
    }
    
    
    //查询
    WHQuery *query = [WHQuery queryWithTableName:@"student"];
    [query whereKey:@"age" equalTo:@(15)];
    //[query whereKey:@"age" greaterThan:@(16)];
    [query setLimit:100];
    NSArray *results = [query findObjects:&error];
    
    if (error) {
        NSLog(@"query error === %@", error);
        return;
    }else {
        NSLog(@"results == %@", results);
    }
    
    //写入score
    NSMutableArray *scores = [NSMutableArray array];
    for (NSInteger i = 0; i < results.count; i++) {
        WHObject *student = results[i];
        WHObject *obj = [WHObject objectWithTableName:@"score"];
        [obj setObject:[student objectForKey:@"name"] forKey:@"name"];
        [obj setObject:[student objectForKey:@"student_id"] forKey:@"studentId"];
        [obj setObject:@(arc4random()%50 + 51) forKey:@"test_score"];
        [scores addObject:obj];
    }
    [WHObject saveAll:scores inTable:@"score" error:&error];
    if (error) {
        NSLog(@"score save data error === %@", error);
        return;
    }
    
    //给表添加字段
    [WHObject addColumnWithKeyType:@{@"average":WHDB_VALUETYPE_INTEGER} inTable:@"student" error:&error];
    if (error) {
        NSLog(@"add column average to student error === %@", error);
        return;
    }
    
    NSMutableArray *updateArray = [NSMutableArray array];
    for (NSInteger i = 0; i < results.count; i++) {
        WHObject *student = results[i];
        [student setObject:@(arc4random()%60 + 40) forKey:@"average"];
        [updateArray addObject:student];
    }
    [WHObject updateAll:updateArray conditions:nil inTable:@"student" error:&error];
    if (error) {
        NSLog(@"update student with average error === %@", error);
        return;
    }
    //查询刚刚添加的average字段
    WHQuery *averageQuery = [WHQuery queryWithTableName:@"student"];
    [averageQuery whereKeyNotNull:@"average"];
    
    results = [averageQuery findObjects:&error];
    
    if (error) {
        NSLog(@"query student with average error === %@", error);
    }else {
        NSLog(@"query student with average succeed, results === %@", results);
    }
    
    //关联查询
    WHQuery *query2 = [WHQuery queryWithTableName:@"student"];
    [query2 whereKey:@"age" equalTo:@(15)];
    //student表中student_id 与 score表中 studentId 相等的结果
    [query2 whereKey:@"student_id" equalToRelationalKey:@"studentId" inRelationalTable:@"score"];
    results = [query2 findObjects:&error];
    
    if (error) {
        NSLog(@"query error === %@", error);
        return;
    }else {
        NSLog(@"results == %@", results);
    }
    
    
