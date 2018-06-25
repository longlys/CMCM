//
//  CMCMDetailTableViewCell.m
//  ManagerCoin
//
//  Created by LongLy on 22/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMDetailTableViewCell.h"

@interface CMCMDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbValue;

@end

@implementation CMCMDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lbTitle setTextColor:sTitleColor];
    [self.lbValue setTextColor:sTitleColor];
    [self setBackgroundColor:sBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)CMCM_newCellWithReuseIdentifier:(NSString *)reuseIdentifier{
    CMCMDetailTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    [cell setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    return cell;
}

-(void)setDisplayForCell:(CMCMItemModel *)model withTitle:(NSString *)title {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundDown];

    CMCMQuotesModel *modelPrice = model.quotesUSD;
    CMCMQuotesModel *modelBTC = model.quotesBTC;
    self.lbTitle.text = title;
    if ([title isEqualToString:@"Coin Stats Score"]) {
        self.lbValue.text = title;
    } else if ([title isEqualToString:@"Price"]) {
        NSNumber *num = @(modelPrice.price);
        NSString *numberAsString = [numberFormatter stringFromNumber:num];
        self.lbValue.text = [NSString stringWithFormat:@"$%@",numberAsString];
    }else if ([title isEqualToString:@"Price BTC"]) {
        self.lbValue.text = [NSString stringWithFormat:@"%f BTC",modelBTC.price];
    }else if ([title isEqualToString:@"Market Cap"]) {
        NSNumber *num = @(modelPrice.market_cap);
        NSString *numberAsString = [numberFormatter stringFromNumber:num];
        self.lbValue.text = [NSString stringWithFormat:@"$%@",numberAsString];
    }else if ([title isEqualToString:@"Volume 24h"]) {
        NSNumber *num = @(modelPrice.volume_24h);
        NSString *numberAsString = [numberFormatter stringFromNumber:num];
        self.lbValue.text = [NSString stringWithFormat:@"$%@",numberAsString];
    }else if ([title isEqualToString:@"Availiable Supply"]) {
        self.lbValue.text =[NSString stringWithFormat:@"$%@",model.max_supply];
    }else if ([title isEqualToString:@"Total Supply"]) {
        self.lbValue.text = [NSString stringWithFormat:@"$%@",model.total_supply];
    }else if ([title isEqualToString:@"% Change 1h"]) {
        NSNumber *num = @(modelPrice.percent_change_1h);
        NSString *numberAsString = [numberFormatter stringFromNumber:num];
        self.lbValue.text = [NSString stringWithFormat:@"%@%%",numberAsString];
    }else if ([title isEqualToString:@"% Change 1d"]) {
        NSNumber *num = @(modelPrice.percent_change_24h);
        NSString *numberAsString = [numberFormatter stringFromNumber:num];
        self.lbValue.text = [NSString stringWithFormat:@"%@%%",numberAsString];
    }else if ([title isEqualToString:@"% Change 1w"]) {
        NSNumber *num = @(modelPrice.percent_change_7d);
        NSString *numberAsString = [numberFormatter stringFromNumber:num];
        self.lbValue.text = [NSString stringWithFormat:@"%@%%",numberAsString];
    }

}
@end
