//
//  CMCMPortfolioTableViewCell.h
//  ManagerCoin
//
//  Created by LongLy on 09/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCMModelProtfolio.h"

@interface CMCMPortfolioTableViewCell : UITableViewCell

+ (instancetype)CMCM_newCellWithReuseIdentifier:(NSString *)reuseIdentifier;
-(void)setDisplayForCell:(CMCMModelProtfolio *)item;

@end
