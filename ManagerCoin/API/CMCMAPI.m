//
//  CMCMAPI.m
//  ManagerCoin
//
//  Created by LongLy on 04/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMAPI.h"

@interface CMCMAPI()

@end
static CMCMAPI *_sharedObject = nil;

@implementation CMCMAPI
+ (instancetype)sharedInstance {
    static dispatch_once_t p = 0;
    dispatch_once(&p, ^{
        if (!_sharedObject) {
            _sharedObject = [[CMCMAPI alloc] init];
        }
    });
    return _sharedObject;
}

-(NSArray *)sortByRank:(NSMutableArray *)array{
    NSArray *sorted = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        if ([obj1 isKindOfClass:[CMCMItemModel class]] && [obj2 isKindOfClass:[CMCMItemModel class]]) {
            CMCMItemModel *s1 = obj1;
            CMCMItemModel *s2 = obj2;
            
            if (s1.rank < s2.rank) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if (s1.rank > s2.rank) {
                return (NSComparisonResult)NSOrderedDescending;
            }
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sorted;
}


- (void)loadmoreListCoinWithStart:(NSInteger )start complete:(void (^)(NSArray *resul, NSError *error))completionBlock
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    NSInteger itemStart = start + 1;
    NSString *urlString = [NSString stringWithFormat:@"https://api.coinmarketcap.com/v2/ticker/?start=%ld&limit=100",(long)itemStart];
    
    NSURL *url = [NSURL URLWithString: urlString];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL: url resolvingAgainstBaseURL: NO];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: components.URL];
    
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            NSDictionary *responseBody = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
            if (responseBody[@"data"] != [NSNull null]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[responseBody[@"data"] allValues]];
                NSMutableArray *arrayResutl = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dic in array) {
                    CMCMItemModel *model = [[CMCMItemModel alloc] initWithDictionary:dic];
                    [arrayResutl addObject:model];
                }
                NSArray *resulBySort = [[NSArray alloc] initWithArray:[self sortByRank:arrayResutl]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(resulBySort, nil);
                });            
            }
            
        } else {
            // Failure
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
}

//https://api.coinmarketcap.com/v2/ticker/1/?convert=BTC
- (void)getDetailCoinWithPriceBTC:(NSInteger )idItem withCoinCover:(NSString *)typeSku complete:(void (^)(CMCMItemModel *resul, NSError *error))completionBlock
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    NSString *urlString = [NSString stringWithFormat:@"https://api.coinmarketcap.com/v2/ticker/%ld/?convert=%@",(long)idItem, typeSku];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL: url resolvingAgainstBaseURL: NO];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: components.URL];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary *responseBody = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
            NSDictionary *dic = responseBody[@"data"];
            CMCMItemModel *model = [[CMCMItemModel alloc] initWithDictionary:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(model, nil);
            });
        } else {
            // Failure
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
}

- (void)getCoinWithPriceUSD:(NSInteger )idItem complete:(void (^)(CMCMItemModel *resul, NSError *error))completionBlock
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    NSString *urlString = [NSString stringWithFormat:@"https://api.coinmarketcap.com/v2/ticker/%ld",(long)idItem+1];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL: url resolvingAgainstBaseURL: NO];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: components.URL];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary *responseBody = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
            NSDictionary *dic = responseBody[@"data"];
            CMCMItemModel *model = [[CMCMItemModel alloc] initWithDictionary:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(model, nil);
            });
        } else {
            // Failure
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
}

- (void)getallListcoinSearchAndSave
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    NSString *urlString = [NSString stringWithFormat:@"https://api.coinmarketcap.com/v2/listings/"];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL: url resolvingAgainstBaseURL: NO];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: components.URL];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:data forKey:@"listCoinSearch"];
            [userDefaults synchronize];
        } else {
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
}

-(NSArray *)getListCoin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"listCoinSearch"];
    NSError* error;
    if (data == nil) {
        return nil;
    }
    NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error][@"data"];
    NSMutableArray *resul = [NSMutableArray new];
    for (NSDictionary *dic in array) {
        CMCMModelSearch *model = [[CMCMModelSearch alloc] initWithDictionary:dic];
        [resul addObject:model];
    }
    return resul;
}
- (void)searchCoinFull:(NSString *)key complete:(void (^)(NSArray *resul))completionBlock{
    NSMutableArray *resulSum = [NSMutableArray new];
    NSArray *arr = [self searchCoin:key];
    for (int i = 0; i < arr.count; i++) {
        CMCMModelSearch *model = [arr objectAtIndex:i];
        [self searchCoinWith:model.title complete:^(CMCMItemModel *resul, NSError *error) {
            [resulSum addObject:resul];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(resulSum);
            });
        }];
        if (i == arr.count -1) {
        }
    }
}
//https://api.coinmarketcap.com/v1/ticker/bitcoin/
- (void)searchCoinWith:(NSString *)title complete:(void (^)(CMCMItemModel *resul, NSError *error))completionBlock
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    NSString *trimmed = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSString *urlString = [NSString stringWithFormat:@"https://api.coinmarketcap.com/v1/ticker/%@",trimmed];
    NSString *strResult = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSLog(@"KEY = %@",urlString);
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL: url resolvingAgainstBaseURL: NO];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: components.URL];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSArray *responseBody = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
            NSDictionary *dic = responseBody.firstObject;
            CMCMItemModel *model = [[CMCMItemModel alloc] initWithSearchDictionary:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(model, nil);
            });
        } else {
            // Failure
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    
    [task resume];
}


- (NSArray *)searchCoin:(NSString *)key{
    
    NSMutableArray *resul = [NSMutableArray new];
    for (CMCMModelSearch *model in [self getListCoin]) {
        if ([model.idSearch containsString:[key uppercaseString]]) {
            [resul addObject:model];
        } else if ([model.symbol containsString:[key uppercaseString]]) {
            [resul addObject:model];
        }
    }
    return resul;
}

@end
