//
//  CMCMHomeTableViewCell.m
//  ManagerCoin
//
//  Created by LongLy on 08/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMHomeTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CMCMQuotesModel.h"

@interface CMCMHomeTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *artwork;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb24h;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbCap;
@property (weak, nonatomic) IBOutlet UILabel *lbRank;
@property (weak, nonatomic) IBOutlet UILabel *lbTong24h;

@end

@implementation CMCMHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lb24h.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lb24h.layer.borderWidth = 1.0;
    self.lb24h.layer.cornerRadius = 8;
    [self setBackgroundColor:sBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+ (instancetype)CMCM_newCellWithReuseIdentifier:(NSString *)reuseIdentifier{
    CMCMHomeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    [cell setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    return cell;
}

-(void)setDisplayForCell:(CMCMItemModel *)item {
    self.lbRank.text = [NSString stringWithFormat:@"%ld",(long)item.rank];
    self.lbTitle.text = [NSString stringWithFormat:@"%@(%@)", item.title, item.symbol];
    
    CMCMQuotesModel *model = item.quotesUSD;
    float cap = 0;
    if (model.market_cap > 1000000000) {
        cap = model.market_cap/1000000000.f;
        self.lbCap.text = [NSString stringWithFormat:@"Cap: $%.1fB",cap];
    } else if (model.market_cap > 1000000) {
        cap = model.market_cap/1000000.f;
        self.lbCap.text = [NSString stringWithFormat:@"Cap: $%.1fM",cap];
    }
    float Volume = 0;
    if (model.volume_24h > 1000000000) {
        Volume = model.volume_24h/1000000000.f;
        self.lbTong24h.text = [NSString stringWithFormat:@"Volume 24h: $%.1fB",Volume];
    } else if (model.volume_24h > 1000000) {
        Volume = model.volume_24h/1000000.f;
        self.lbTong24h.text = [NSString stringWithFormat:@"Volume 24h: $%.1fM",Volume];
    }

    self.lb24h.text = [NSString stringWithFormat:@"%.2f%%",model.percent_change_24h];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundDown];
    
    NSNumber *num = @(model.price);
    NSString *numberAsString = [numberFormatter stringFromNumber:num];

    self.lbPrice.text = [NSString stringWithFormat:@"$%@",numberAsString];
    
    [self.artwork setImageWithURL:[NSURL URLWithString:item.imageName] placeholderImage:[UIImage imageNamed:@"image"]];
    self.artwork.contentMode = UIViewContentModeScaleAspectFill;
    
    if (model.percent_change_24h > 0) {
        [self.lb24h setTextColor:[UIColor greenColor]];
        [self.lbPrice setTextColor:[UIColor greenColor]];
        self.lb24h.layer.borderColor = [UIColor greenColor].CGColor;
    } else {
        [self.lb24h setTextColor:[UIColor redColor]];
        [self.lbPrice setTextColor:[UIColor redColor]];
        self.lb24h.layer.borderColor = [UIColor redColor].CGColor;
    }
}


@end
