//
//  CMCMSearchBar.h
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMCMSearchBarDelegate;

@interface CMCMSearchBar : UIView

@property (nonatomic) NSString *text;
@property (nonatomic) UIFont *font;
@property (nonatomic) NSString *placeholder;

//The text field subview
@property (nonatomic) UITextField *textField;
@property (nonatomic, getter = isCancelButtonHidden) BOOL cancelButtonHidden; //NO by Default
@property (nonatomic, weak) id <CMCMSearchBarDelegate> delegate;

@end

@protocol CMCMSearchBarDelegate <NSObject>

@optional
- (void)searchBarCancelButtonClicked:(CMCMSearchBar *)searchBar;
- (void)searchBarSearchButtonClicked:(CMCMSearchBar *)searchBar;

- (BOOL)searchBarShouldBeginEditing:(CMCMSearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(CMCMSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(CMCMSearchBar *)searchBar;

- (void)searchBar:(CMCMSearchBar *)searchBar textDidChange:(NSString *)searchText;

@end


//A rounded view that makes up the background of the search bar.
@interface CMCMSearchBarView : UIView

@end
