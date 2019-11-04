//
//  CMCMSettingsViewController.m
//  ManagerCoin
//
//  Created by Lý Long on 10/31/19.
//  Copyright © 2019 LongLy. All rights reserved.
//

#import "CMCMSettingsViewController.h"
#import <StoreKit/StoreKit.h>

@interface CMCMSettingsViewController ()<UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    SKProductsRequest *productsRequest;
    NSArray *validProducts;
    UIActivityIndicatorView *activityIndicatorView;
    IBOutlet UILabel *productTitleLabel;
    IBOutlet UILabel *productDescriptionLabel;
    IBOutlet UILabel *productPriceLabel;
    IBOutlet UIButton *purchaseButton;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;
@end
#define kRemoveAdsProductIdentifier @"io.hdapps4.musicpin.removeads"

@implementation CMCMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:sBackgroundColor];
    self.tableView.tableFooterView = [UIView new];

    [self SML_loadData];
}
- (void)SML_loadData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"plist"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSPropertyListFormat plistFormat;
    NSError *err = nil;
    NSArray *arr = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:&plistFormat error:&err];
    
    self.dataArray = [NSMutableArray new];
    for (NSDictionary *dic in  arr) {
        NSString *sTitle = dic[@"name"];
        NSInteger sType= [dic[@"type"] integerValue];

        if (sType == 1 ) {
            if(![sAdsManager getIspro]){
                [self.dataArray addObject:sTitle];

            }
        } else {
            [self.dataArray addObject:sTitle];
        }
    }
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = sTitleColor;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    weakify(self);
    switch (indexPath.row) {
        case 0:
            //Rate this app
            break;
        case 1:
//            Feedback
            break;
        case 2:
            //Share
            break;
        case 3:
            [self tapsRemoveAds];
            //Remove Ads
            break;
        case 4:
            [self tapRestorePurchase];
            //Restore purchase
            break;
        default:
            break;
    }
    
}
- (void)tapsRemoveAds{
    NSLog(@"User requests to remove ads");
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = self.view.center;
    [activityIndicatorView hidesWhenStopped];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];

    [self fetchAvailableProducts];
}

-(void)tapRestorePurchase
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


- (void)doRemoveAds{
    [sAdsManager setIsPro:YES];
    [self SML_loadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"INAPPREMOVEADS" object:nil];
}

-(void)fetchAvailableProducts {
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:kRemoveAdsProductIdentifier,nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (BOOL)canMakePurchases {
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseMyProduct:(SKProduct*)product {
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                break;
                
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:kRemoveAdsProductIdentifier]) {
                    NSLog(@"Purchased ");
                    [self showAlertViewComplete];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase failed ");
                break;
            default:
                break;
        }
    }
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    SKProduct *validProduct = nil;
    NSArray *products = response.products;
    NSLog(@"Product count: %lu", (unsigned long)[products count]);
    for (SKProduct *product in products)
    {
        NSLog(@"Product: %@ %@ %f", product.productIdentifier, product.localizedTitle, product.price.floatValue);
    }

    int count = [response.products count];
    
    if (count>0) {
        validProducts = response.products;
        validProduct = [response.products objectAtIndex:0];
        
        if ([validProduct.productIdentifier isEqualToString:kRemoveAdsProductIdentifier]) {
            weakify(self);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove Ads" message:[NSString stringWithFormat:@"%@", validProduct.price] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [self_weak_ purchaseMyProduct:[validProducts objectAtIndex:0]];
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                // Other action
            }];
            [alert addAction:okAction];
            [alert addAction:otherAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Not Available"
                            message:@"No products to purchase"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"Ok", nil];
        [tmp show];
    }
    
    [activityIndicatorView stopAnimating];
}

-(void)showAlertViewComplete{
    weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Purchase is completed succesfully" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self_weak_ doRemoveAds];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

}

@end
