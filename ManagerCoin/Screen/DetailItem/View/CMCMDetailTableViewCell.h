//
//  CMCMDetailTableViewCell.h
//  ManagerCoin
//
//  Created by LongLy on 22/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCMItemModel.h"

@interface CMCMDetailTableViewCell : UITableViewCell

+ (instancetype)CMCM_newCellWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setDisplayForCell:(CMCMItemModel *)model withTitle:(NSString *)item;

@end
