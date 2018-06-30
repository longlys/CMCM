//
//  CMCMPortfolioTableViewCell.m
//  ManagerCoin
//
//  Created by LongLy on 09/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMPortfolioTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CMCMPortfolioTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *artwork;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbValue;
@property (weak, nonatomic) IBOutlet UILabel *lbvauleChange;
@property (weak, nonatomic) IBOutlet UILabel *lbPirceBuy;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalNew;

@end

@implementation CMCMPortfolioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lbvauleChange.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lbvauleChange.layer.borderWidth = 1.0;
    self.lbvauleChange.layer.cornerRadius = 8;
    [self setBackgroundColor:sBackgroundColor];
//    self.lbTotalNew.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.lbTotalNew.layer.borderWidth = 1.0;
//    self.lbTotalNew.layer.cornerRadius = 8;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (instancetype)CMCM_newCellWithReuseIdentifier:(NSString *)reuseIdentifier{
    CMCMPortfolioTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    [cell setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)setDisplayForCell:(CMCMModelProtfolio *)item {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"##,##,###"];

    
    self.lbTitle.text = [NSString stringWithFormat:@"%@(%@)", item.title, item.symbol];
    self.lbValue.text = [NSString stringWithFormat:@"Quanlity: %ld", (long)item.quanlity];
    [self.artwork setImageWithURL:[NSURL URLWithString:item.artwork] placeholderImage:[UIImage imageNamed:@"image"]];
    self.artwork.contentMode = UIViewContentModeScaleAspectFill;
    float a = item.priceNow;
    float b = item.price;
    float r = a/b*100 - 100;
    
    self.lbvauleChange.text = [NSString stringWithFormat:@"%.2f%%",r];
    if (r>0) {
        [self.lbvauleChange setTextColor:[UIColor greenColor]];
        [self.lbvauleChange setTextColor:[UIColor greenColor]];
        self.lbvauleChange.layer.borderColor = [UIColor greenColor].CGColor;
    } else {
        [self.lbvauleChange setTextColor:[UIColor redColor]];
        [self.lbvauleChange setTextColor:[UIColor redColor]];
        self.lbvauleChange.layer.borderColor = [UIColor redColor].CGColor;
    }
    NSString *formattedNumberString = [numberFormatter
                                       stringFromNumber:[NSNumber numberWithFloat:item.priceNow*item.quanlity]];
    NSString *formattedNumberStringlbPirceBuy = [numberFormatter
                                                 stringFromNumber:[NSNumber numberWithFloat:item.price]];

    self.lbPirceBuy.text = [NSString stringWithFormat:@"Price: $%@", formattedNumberStringlbPirceBuy];
    self.lbTotalNew.text = [NSString stringWithFormat:@"Σ: $%@", formattedNumberString];
}

@end
