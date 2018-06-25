//
//  CMCMSearchTableViewCell.h
//  ManagerCoin
//
//  Created by LongLy on 01/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCMModelSearch.h"

@interface CMCMSearchTableViewCell : UITableViewCell
+ (instancetype)CMCM_newCellWithReuseIdentifier:(NSString *)reuseIdentifier;
-(void)setDisplayForCell:(CMCMModelSearch *)item;

@end
