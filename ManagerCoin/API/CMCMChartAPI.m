//
//  CMCMChartAPI.m
//  ManagerCoin
//
//  Created by LongLy on 16/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMChartAPI.h"
#import "NSDate+Utilities.h"

static CMCMChartAPI *_sharedObject = nil;
@interface CMCMChartAPI()

@end


@implementation CMCMChartAPI
+ (instancetype)sharedInstance {
    static dispatch_once_t p = 0;
    dispatch_once(&p, ^{
        if (!_sharedObject) {
            _sharedObject = [[CMCMChartAPI alloc] init];
        }
    });
    return _sharedObject;
}
-(NSString *)getCodeByTypeChart:(ChartType )type{
    switch (type) {
        case Type24h:
            return @"histoday";
            break;
        case Type1M:
            return @"histoday";
            break;
        case Type3M:
            return @"histoday";
            break;
        case Type6M:
            return @"histoday";
            break;
        case Type1Y:
            return @"histoday";
            break;
        case TypeALL:
            return @"histoday";
            break;
        default:
            break;
    }
    return nil;
}


- (void)loadDataChartWithStyle:(ChartType)type withCodeItem:(NSString *)nameItem complete:(void (^)(CMCMModelChart *resul, NSError *error))completionBlock
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    NSString *codeChart = [self getCodeByTypeChart:type];
    
    NSTimeInterval lastTime = [self createTimestamp:[NSDate date]];
    NSTimeInterval firstTime = [self getTimestampWithType:type];
    
//    https://graphs2.coinmarketcap.com/currencies/ethereum/1526373900000/1526460304601/
    NSString *urlString = [NSString stringWithFormat:@"https://graphs2.coinmarketcap.com/currencies/%@/%.0f/%.0f/",nameItem,firstTime,lastTime];
    NSURL *url = [NSURL URLWithString: urlString];
    if (url) {
        
        NSURLComponents *components = [[NSURLComponents alloc] initWithURL: url resolvingAgainstBaseURL: NO];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: components.URL];
        
        request.HTTPMethod = @"GET";
        
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error == nil) {
                
                NSDictionary *responseBody = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
                
                CMCMModelChart *model = [[CMCMModelChart alloc] initWithDictionary:responseBody];
                
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
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"Not Found" code:999 userInfo:nil];
        completionBlock(nil, error);
    }
}
-(NSTimeInterval )getTimestampWithType:(ChartType )type{
    NSDate *today = [NSDate date];
    NSDate *lastHours= [today dateBySubtractingHours:7];
    NSDate *lastMinutes= [today dateBySubtractingMinutes:1];
    NSDate *yesterday = [today dateBySubtractingDays:1];
    NSDate *lastWeek= [today dateBySubtractingDays:7];
    NSDate *lastMonth = [today dateBySubtractingMonths:1];
    NSDate *last3Month = [today dateBySubtractingMonths:3];
    NSDate *last6Month = [today dateBySubtractingMonths:6];
    NSDate *lastYear= [today dateBySubtractingYears:1];
    NSDate *all= [today dateBySubtractingYears:10];

    switch (type) {
        case TypeMin:
            return [self createTimestamp:lastMinutes];
            break;
        case TypeHou:
            return [self createTimestamp:lastHours];
            break;
        case Type24h:
            return [self createTimestamp:yesterday];
            break;
        case Type1W:
            return [self createTimestamp:lastWeek];
            break;
        case Type1M:
            return [self createTimestamp:lastMonth];
            break;
        case Type3M:
            return [self createTimestamp:last3Month];
            break;
        case Type6M:
            return [self createTimestamp:last6Month];
            break;
        case Type1Y:
            return [self createTimestamp:lastYear];
            break;
        case TypeALL:
            return [self createTimestamp:all];
            break;
        default:
            break;
    }
}

-(NSTimeInterval )createTimestamp:(NSDate *)dateTime{
    NSTimeInterval since1970 = [dateTime timeIntervalSince1970]; // January 1st 1970
    return since1970 * 1000;
}


@end
