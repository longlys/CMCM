//
//  CMCMSearchTableViewCell.m
//  ManagerCoin
//
//  Created by LongLy on 01/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMSearchTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CMCMSearchTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleCell;
@property (weak, nonatomic) IBOutlet UIImageView *artCoin;

@end

@implementation CMCMSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:sBackgroundColor];
    [self.titleCell setTextColor:sTitleColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)CMCM_newCellWithReuseIdentifier:(NSString *)reuseIdentifier{
    CMCMSearchTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    [cell setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    return cell;
}

-(void)setDisplayForCell:(CMCMModelSearch *)item {
    self.titleCell.text = item.title;

    [self.artCoin setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"image"]];
    self.artCoin.contentMode = UIViewContentModeScaleAspectFill;
    
}


@end
