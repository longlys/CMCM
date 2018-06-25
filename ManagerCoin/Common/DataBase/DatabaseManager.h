//
//  DatabaseManager.h
//  ManagerCoin
//
//  Created by LongLy on 25/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CMCMModelProtfolio;

@interface DatabaseManager : NSObject

+ (instancetype) shareInstance;
- (BOOL) insertTrackModel: (CMCMModelProtfolio *) trackModel;
- (NSMutableArray *) listTracksWithType;
- (BOOL) moveTrack: (CMCMModelProtfolio *) trackModel;
- (BOOL) deleteTrack: (CMCMModelProtfolio *) trackModel ;
- (BOOL) checkID: (CMCMModelProtfolio *) trackModel;

@end
