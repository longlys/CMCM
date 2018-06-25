//
//  CMCMModelSearch.h
//  ManagerCoin
//
//  Created by LongLy on 01/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCMModelSearch : NSObject

@property (nonatomic)NSString *title;
@property (nonatomic)NSString *idItem;
@property (nonatomic)NSString *idSearch;
@property (nonatomic)NSString *symbol;
@property (nonatomic)NSString *image;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
