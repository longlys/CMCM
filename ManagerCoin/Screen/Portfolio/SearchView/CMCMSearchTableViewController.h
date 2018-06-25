//
//  CMCMSearchTableViewController.h
//  ManagerCoin
//
//  Created by LongLy on 01/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCMModelSearch.h"

@class CMCMSearchTableViewController, DLFileBookMarkComponent;

@protocol CMCMSearchTableViewControllerDelegate <NSObject>
- (void)SML_suggestViewController:(CMCMSearchTableViewController *)sender didSelectString:(CMCMModelSearch *)modelSearch;
@end
@interface CMCMSearchTableViewController : UITableViewController
-(instancetype)initWithFrame:(CGRect )frame;
-(void)requestTableViewWithKeyword:(NSString *)key;

@property (weak, nonatomic) id<CMCMSearchTableViewControllerDelegate>delegate;

- (void)SML_showOnViewController:(UIViewController *)viewController withFrame:(CGRect)frm;
-(void)SML_hideOnViewController;
- (BOOL)isShow;

@end
