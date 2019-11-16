//
//  PrefixHeader.h
//  ManagerCoin
//
//  Created by LongLy on 12/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#define weakify(_var_) typeof(_var_) __weak _var_ ## _weak_ = _var_
#define cmcmDBMgr [CMCMApplication sharedInstance].databaseManager

#define sBackgroundColor [UIColor colorWithRed:49/255.f green:49/255.f blue:49/255.f alpha:1.0f]
#define sNavBackgroundColor [UIColor colorWithRed:30/255.f green:30/255.f blue:30/255.f alpha:1.0f]
#define sTitleColor [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0f]
#define sTinColor [UIColor colorWithRed:255/255.f green:147/255.f blue:0/255.f alpha:1.0f]
#define sLine [UIColor colorWithRed:150/255.f green:150/255.f blue:150/255.f alpha:1.0f]
#define sBackgroundColor2 [UIColor colorWithRed:44/255.f green:44/255.f blue:44/255.f alpha:1.0f]

#import "CMCMChartAPI.h"
#import "CMCMApplication.h"
#import "AppDelegate.h"
#import "CMCMAPI.h"
#import "RBAdsManager.h"

#endif /* PrefixHeader_h */
