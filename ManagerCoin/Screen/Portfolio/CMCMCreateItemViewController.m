//
//  CMCMCreateItemViewController.m
//  ManagerCoin
//
//  Created by LongLy on 10/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMCreateItemViewController.h"
#import "CMCMModelProtfolio.h"
#import "CMCMModelSearch.h"
#import "CMCMSearchTableViewController.h"
#import "CMCMModelSearch.h"
#import "CMCMDatabaseManager.h"

@interface CMCMCreateItemViewController ()<UITextFieldDelegate, CMCMSearchTableViewControllerDelegate>
@property (nonatomic) NSMutableArray *arrayDataTableView;
@property (nonatomic) CMCMDatabaseManager *dbManager;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle3;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle4;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle5;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UIView *viewRadio;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UIButton *btnSell;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (nonatomic) UIButton *btnDonePicker;
@property (nonatomic) UIButton *btnDoneTextField;
@property (nonatomic) NSInteger isBuy;
@property (nonatomic) NSInteger quality;
@property (nonatomic) NSInteger price;
@property (nonatomic)UIDatePicker* picker;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeTypePrice;
@property (nonatomic) NSInteger numType;
@property (nonatomic) CMCMSearchTableViewController *searchVC;
@property (nonatomic) CMCMAPI *api;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UIView *viewNav;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle0;
@property (nonatomic) CMCMModelSearch *sItem;
@property (weak, nonatomic) IBOutlet UILabel *lbError;

@end
#define cItemTableViewCell @"ItemTableViewCell"
@implementation CMCMCreateItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myNotificationMethod:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.textField.delegate = self;
    self.textField2.delegate = self;
    self.quality = 0;
    self.price = 0;
    self.arrayDataTableView = [NSMutableArray new];
    [self reloadDatabase];
    [self.view setBackgroundColor:sBackgroundColor];
    
    CGRect fNav = self.viewNav.frame;
    fNav.origin.y = 24;
    self.viewNav.frame =fNav;
    
    [self.viewNav setBackgroundColor:sBackgroundColor];

    self.api = [[CMCMAPI alloc] init];
    

}
-(void)setUpviewTextBox{
    CGRect f = self.view.frame;
    f.origin.y = self.textFieldSearch.frame.size.height + self.textFieldSearch.frame.origin.y;
    f.size.height = self.view.frame.size.height - self.viewNav.frame.size.height - self.textFieldSearch.frame.size.height + self.textFieldSearch.frame.origin.y;
    self.searchVC = [[CMCMSearchTableViewController alloc] init];
    self.searchVC.delegate = self;
    self.searchVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.searchVC SML_showOnViewController:self withFrame:f];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)searchWithKey:(NSString *)key{
    NSArray *arr = [self.api searchCoin:key];
    for (CMCMModelSearch *model in arr) {
        NSLog(@"SEARCH = %@", model.title);
    }
}
- (IBAction)touchClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)touchChangeTypePrice:(id)sender {
//    if (self.numType == 1) {
//        [self.btnChangeTypePrice setTitle:@"BTC" forState:UIControlStateNormal];
//        self.lbTitle3.text = @"Price BTC";
//        self.numType = 2;
//    }else if (self.numType == 2) {
//        [self.btnChangeTypePrice setTitle:@"ETH" forState:UIControlStateNormal];
//        self.lbTitle3.text = @"Price ETH";
//        self.numType = 3;
//    }else {
//        [self.btnChangeTypePrice setTitle:@"USD" forState:UIControlStateNormal];
//        self.lbTitle3.text = @"Price USD";
//        self.numType = 1;
//    }
}

-(void)reloadDatabase{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CoinDetail" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    self.arrayDataTableView = array.copy;
    [self setupDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupDisplay{
    [self.lbError setHidden:YES];
    self.isBuy = -1;
    UIImage *image = [[UIImage imageNamed:@"qs_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.btnClose setImage:image forState:UIControlStateNormal];
    self.btnClose.tintColor = sTinColor;
    
    [self.btnChangeTypePrice setTitle:@"USD" forState:UIControlStateNormal];
    [self.btnChangeTypePrice setTitleColor:sTinColor forState:UIControlStateNormal];
    self.numType = 1;

    self.btnAdd.layer.cornerRadius = 10.f;
    [self.btnAdd setBackgroundColor:sTinColor];
    [self.btnAdd setTitle:@"Done" forState:UIControlStateNormal];
    
    self.lbTotal.text = @"0";
    [self.lbTitle0 setTextColor:sTitleColor];
    [self.lbTitle1 setTextColor:sTitleColor];
    [self.lbTitle2 setTextColor:sTitleColor];
    [self.lbTitle3 setTextColor:sTitleColor];
    [self.lbTitle4 setTextColor:sTitleColor];
    [self.lbTitle5 setTextColor:sTitleColor];
    [self.lbTotal setTextColor:sTitleColor];
    [self.btnBuy setBackgroundImage:[UIImage imageNamed:@"circle-outline"] forState:UIControlStateNormal];
    [self.btnSell setBackgroundImage:[UIImage imageNamed:@"circle-outline"] forState:UIControlStateNormal];
    
    [self.btnBuy setTintColor:sTitleColor];
    
    
    [self.textField setTextColor:sTitleColor];
    [self.textField2 setTextColor:sTitleColor];
    [self.textField setTintColor:sTitleColor];
    [self.textField2 setTintColor:sTitleColor];
    self.textField.layer.cornerRadius = 10;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = (sTinColor).CGColor;
    self.textField2.layer.cornerRadius = 10;
    self.textField2.layer.borderWidth = 1;
    self.textField2.layer.borderColor = sTinColor.CGColor;
    
    self.textFieldSearch.layer.cornerRadius = 10;
    self.textFieldSearch.layer.borderWidth = 1;
    self.textFieldSearch.layer.borderColor = sTinColor.CGColor;

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [self.btnDate setTitle:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    
    if (self.btnDoneTextField == nil) {
        CGRect fbtn = self.view.frame;
        fbtn.size.height = 50;
        fbtn.origin.y = self.view.bounds.size.height - 50;
        self.btnDoneTextField = [[UIButton alloc] initWithFrame:fbtn];
        [self.btnDoneTextField setTintColor:sTitleColor];
        [self.btnDoneTextField setTitle:[NSString stringWithFormat:@"Done"] forState:UIControlStateNormal];
        [self.btnDoneTextField addTarget:self action:@selector(touchbtnDoneTextField:) forControlEvents:UIControlEventAllEvents];
        [self.btnDoneTextField setBackgroundColor:sTinColor];
        [self.view addSubview:self.btnDoneTextField];
        [self.btnDoneTextField setHidden:YES];
    } else {
        [self.btnDoneTextField setHidden:NO];
    }
    self.lbTotal.layer.borderColor = sTitleColor.CGColor;
    self.lbTotal.layer.borderWidth = 1.0;
    self.lbTotal.layer.cornerRadius = 10;

    self.btnDate.layer.borderColor = sTitleColor.CGColor;
    self.btnDate.layer.borderWidth = 1.0;
    self.btnDate.layer.cornerRadius = 10;

}


-(void)touchbtnDoneTextField:(id)sender{
    if (self.btnDoneTextField.hidden) {
        return;
    }
    [self.btnDoneTextField setHidden:YES];
    [self.view endEditing:YES];
    [self setupValueTotal];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*  limit to only numeric characters  */
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    
    /*  limit the users input to only 9 characters  */
    NSUInteger newLength = [self.textField.text length] + [string length] - range.length;
    return (newLength > 9) ? NO : YES;
}
- (IBAction)touchSell:(id)sender {
    self.isBuy = 0;
    [self.btnSell setBackgroundImage:[UIImage imageNamed:@"circle-filled"] forState:UIControlStateNormal];
    [self.btnBuy setBackgroundImage:[UIImage imageNamed:@"circle-outline"] forState:UIControlStateNormal];
}
- (IBAction)touchBuy:(id)sender {
    self.isBuy = 1;
    [self.btnBuy setBackgroundImage:[UIImage imageNamed:@"circle-filled"] forState:UIControlStateNormal];
    [self.btnSell setBackgroundImage:[UIImage imageNamed:@"circle-outline"] forState:UIControlStateNormal];
}

- (IBAction)touchAdd:(id)sender {
    if (![self.textField.text isEqualToString:@"0"] && ![self.textField2.text isEqualToString:@"0"] && (self.isBuy > -1) && ![self.textFieldSearch.text isEqualToString:@"--Select Coin--"])
    {
        [self saveItem];
    } else {
        [self.lbError setHidden:NO];
    }
}

- (IBAction)touchDate:(id)sender {
    CGRect f = self.view.bounds;
    f.size.height = 216;
    f.origin.y = self.view.bounds.size.height - 216;
    self.picker = [[UIDatePicker alloc] initWithFrame:f];
    self.picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self.picker addTarget:self action:@selector(setDateCustom:) forControlEvents:UIControlEventValueChanged];
    self.picker.frame = f;
    self.picker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.picker];
    if (self.btnDonePicker == nil) {
        CGRect fbtn = self.view.bounds;
        fbtn.size.height = 50;
        fbtn.origin.y = self.view.bounds.size.height - 216 - 50;
        self.btnDonePicker = [[UIButton alloc] initWithFrame:fbtn];
        [self.btnDonePicker setTintColor:sTitleColor];
        [self.btnDonePicker setTitle:[NSString stringWithFormat:@"Done"] forState:UIControlStateNormal];
        [self.btnDonePicker addTarget:self action:@selector(touchbtnDone:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnDonePicker setBackgroundColor:sTinColor];
        [self.view addSubview:self.btnDonePicker];
    } else {
        [self.btnDonePicker setHidden:NO];
    }
}
- (IBAction)textField1:(id)sender {
    self.quality = [self.textField.text integerValue];
    [self setupValueTotal];
}
- (IBAction)textField2:(id)sender {
    self.price = [self.textField2.text integerValue];
    [self setupValueTotal];
}

-(void)touchbtnDone:(id)sender{
    [self.picker removeFromSuperview];
    [self.btnDonePicker setHidden:YES];
}

-(void)setupValueTotal{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"##,##,###"];

    NSInteger total = self.quality*self.price;
    NSString *formattedNumberString = [numberFormatter
                                       stringFromNumber:[NSNumber numberWithFloat:total]];

    self.lbTotal.text = [NSString stringWithFormat:@"$ %@", formattedNumberString];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    [self.btnDoneTextField setHidden:NO];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self setupValueTotal];
    return YES;
}
- (IBAction)touchOut1:(id)sender {
    [self setupValueTotal];
}

- (IBAction)touchOut2:(id)sender {
    [self setupValueTotal];
}

-(void)setDateCustom:(UIDatePicker *)sender {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"Picked the date %@", [dateFormatter stringFromDate:[sender date]]);
    [self.btnDate setTitle:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[sender date]]] forState:UIControlStateNormal];
}

- (void)myNotificationMethod:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyFrame = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = keyFrame.CGRectValue;
    CGRect f = keyboardFrame;
    f.size.height = 50;
    f.origin.y = keyboardFrame.origin.y - 50;
    self.btnDoneTextField.frame = f;
}
- (IBAction)beginChangeTexr:(id)sender {
    [self setUpviewTextBox];
}

- (IBAction)textFieldsearch:(id)sender {
    UITextField *textf = sender;
    [self.searchVC requestTableViewWithKeyword:textf.text];
}


- (void)SML_suggestViewController:(CMCMSearchTableViewController *)sender didSelectString:(CMCMModelSearch *)modelSearch{
    self.textFieldSearch.text = modelSearch.title;
    self.sItem = modelSearch;
    [self.searchVC SML_hideOnViewController];
    [self setpriceFollowNow];
    [self.view endEditing:YES];
}
-(void)setpriceFollowNow{
    weakify(self);
    [self.api getCoinWithPriceUSD:[self.sItem.idItem integerValue]-1 complete:^(CMCMItemModel *resul, NSError *error) {
        if (error == nil) {
            self_weak_.price = resul.quotesUSD.price;
            self_weak_.textField2.text = [NSString stringWithFormat:@"%ld",(long)self_weak_.price];
        }
    }];
}

-(void)saveItem{
    CMCMModelProtfolio *model = [[CMCMModelProtfolio alloc] init];
    NSString *str = self.textFieldSearch.text;
    model.title = str;
    model.quanlity = self.quality;
    model.price = self.price;
    model.tradedate = self.btnDate.titleLabel.text;
    model.total = [self.lbTotal.text floatValue];
    model.priceType = self.numType;
    model.symbol = self.sItem.symbol;
    model.artwork = self.sItem.image;
    
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    NSString *tmpID = [NSString stringWithFormat:@"%@%f",self.sItem.idItem,ti];
    model.idCoin = tmpID;
    weakify(self);
    [cmcmDBMgr insertTrackItem:model withComplete:^(CMCMModelProtfolio *trackModel, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        [self_weak_ dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddItemNew" object:nil];
    }];
}



@end
