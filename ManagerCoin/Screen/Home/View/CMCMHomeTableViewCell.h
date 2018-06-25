//
//  CMCMHomeTableViewCell.h
//  ManagerCoin
//
//  Created by LongLy on 08/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCMItemModel.h"

@interface CMCMHomeTableViewCell : UITableViewCell

+ (instancetype)CMCM_newCellWithReuseIdentifier:(NSString *)reuseIdentifier;
-(void)setDisplayForCell:(CMCMItemModel *)item;
@end
