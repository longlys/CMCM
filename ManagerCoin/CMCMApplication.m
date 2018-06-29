//
//  CMCMApplication.m
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMApplication.h"
#import <objc/runtime.h>

@interface CMCMApplication ()

@property (nonatomic, strong, readwrite) CMCMDatabaseManager *databaseManager;

@end

@implementation CMCMApplication

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}


- (void)setupDatabase{
    [CMCMApplication copyDatabaseIfNeeded];
    self.databaseManager = [[CMCMDatabaseManager alloc] initWithPath:[CMCMApplication DBPath]];
}

+ (NSString *)DBPath
{
    NSString *documentsDir = [self documentsPath];
    //NSLog(@"dbpath : %@",documentsDir);
    return [documentsDir stringByAppendingPathComponent:@"ManagerCoin.sqlite"];
}
+ (NSString *)documentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return documentsDir;
}
#pragma mark - private method
+ (void)copyDatabaseIfNeeded{
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbPath = [self DBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ManagerCoin.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
//        if (!success)
//            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


@end
