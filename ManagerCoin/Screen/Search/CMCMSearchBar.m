//
//  CMCMSearchBar.m
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMSearchBar.h"

#define kXMargin 8
#define kYMargin 4
#define kIconSize 29

#define kSearchBarHeight 44

@interface CMCMSearchBar()<UITextFieldDelegate>
{
    
}
@property (nonatomic) UITextField *searchField;
@property (nonatomic) UILabel *lbPlaceholder;
@property (nonatomic) UIImageView *searchImageView;
@property (nonatomic) CMCMSearchBarView *backgroundView;

@property (nonatomic) UIImage *searchImage;

@end

@implementation CMCMSearchBar

- (void)setDefaults {
    
    UIImage *searchIcon = [UIImage imageNamed:@"icon_tab_search"];
    _searchImage = searchIcon;
    self.backgroundColor =sBackgroundColor2;
    
    NSUInteger boundsWidth = [UIScreen mainScreen].bounds.size.width;
    NSUInteger textFieldHeight = kSearchBarHeight - 2*kYMargin;
    
    //Background Rounded White Image
    
    self.backgroundView = [[CMCMSearchBarView alloc] initWithFrame:CGRectMake(kXMargin, (self.bounds.size.height - textFieldHeight)/2, boundsWidth - kXMargin*2, textFieldHeight)];
    [self addSubview:self.backgroundView];
    [self.backgroundView setBackgroundColor:sBackgroundColor];
    
    //    Search Image
    self.searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kXMargin, (textFieldHeight-kIconSize)/2, kIconSize, kIconSize)];
    self.searchImageView.image = self.searchImage;
    self.searchImageView.contentMode = UIViewContentModeScaleAspectFit;
    //    self.searchImageView.center = CGPointMake(kIconSize/2 + kXMargin, CGRectGetMidY(self.bounds));
    [self.backgroundView addSubview:self.searchImageView];
    [self.searchImageView setBackgroundColor:[UIColor clearColor]];
    //
    //TextField
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(2*kXMargin + kIconSize, 0, boundsWidth - 4*kXMargin - kIconSize, textFieldHeight)];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    UIFont *defaultFont = [UIFont fontWithName:@"Avenir Next" size:14];
    self.textField.font = defaultFont;
    self.textField.textColor = sTitleColor;
    [self.textField setTintColor:sTitleColor];
    [self.textField setBackgroundColor:[UIColor clearColor]];
    [self.textField.rightView setTintColor:[UIColor clearColor]];
    [self.textField.rightView setBackgroundColor:[UIColor yellowColor]];
    
    self.textField.textAlignment = NSTextAlignmentLeft;
    [self.backgroundView addSubview:self.textField];
    
    self.lbPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(2*kXMargin + kIconSize, (textFieldHeight-textFieldHeight)/2, boundsWidth - 4*kXMargin - 2*kIconSize, textFieldHeight)];
    NSString *textPL = @"Type your search here";
    self.lbPlaceholder.text = @"Type your search here";
    self.lbPlaceholder.font = defaultFont;
    self.lbPlaceholder.textAlignment = NSTextAlignmentCenter;
    self.lbPlaceholder.textColor = sTitleColor;
    [self.lbPlaceholder setBackgroundColor:[UIColor clearColor]];
    CGSize maximumLabelSize = CGSizeMake(boundsWidth - 4*kXMargin - 2*kIconSize,textFieldHeight);
    CGSize expectedLabelSize = [textPL sizeWithFont:self.lbPlaceholder.font
                                  constrainedToSize:maximumLabelSize
                                      lineBreakMode:self.lbPlaceholder.lineBreakMode];
    CGRect flb = self.lbPlaceholder.frame;
    flb.size.height = expectedLabelSize.height;
    flb.size.width = expectedLabelSize.width;
    flb.origin.x = (boundsWidth - expectedLabelSize.width)/2;//(self.bounds.size.width - expectedLabelSize.width)/2;
    flb.origin.y = (textFieldHeight - expectedLabelSize.height)/2;
    
    self.lbPlaceholder.frame = flb;
    [self.backgroundView addSubview:self.lbPlaceholder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    CGRect newFrame = frame;
    frame.size.height = kSearchBarHeight;
    frame = newFrame;
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(10, 20, 300, 44)];
}

#pragma mark - Properties and actions

- (NSString *)text {
    return self.textField.text;
}


- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (void)setAnimationPlaceholder:(BOOL )isLeft {
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect f = self.backgroundView.frame;
                         CGRect frame = self.lbPlaceholder.frame;
                         if (isLeft) {
                             frame.origin.x = (f.size.width - frame.size.width)/2;
                         } else {
                             frame.origin.x = f.origin.x + kXMargin + kIconSize;
                         }
                         self.lbPlaceholder.frame = frame;
                     } completion:nil];
}


- (UIFont *)font {
    return self.textField.font;
}


- (void)setFont:(UIFont *)font {
    self.textField.font = font;
}

- (void)pressedCancel: (id)sender {
    if ([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
        [self.delegate searchBarCancelButtonClicked:self];
}

#pragma mark - Text Delegate

- (void)textChanged: (id)sender {
    if([self.textField.text isEqualToString:@""])
    {
        [self.lbPlaceholder setHidden:NO];
    } else {
        [self.lbPlaceholder setHidden:YES];
    }
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
        [self.delegate searchBar:self textDidChange:self.text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self setAnimationPlaceholder:NO];
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)])
        return [self.delegate searchBarShouldBeginEditing:self];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
        [self.delegate searchBarTextDidBeginEditing:self];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([self.textField.text isEqualToString:@""])
    {
        [self.lbPlaceholder setHidden:NO];
    } else {
        [self.lbPlaceholder setHidden:YES];
    }
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)])
        [self.delegate searchBarTextDidEndEditing:self];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self setAnimationPlaceholder:YES];
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
        [self.delegate searchBarSearchButtonClicked:self];
    [self endEditing:YES];
    return YES;
}


- (BOOL)isFirstResponder {
    [self setAnimationPlaceholder:YES];
    return [self.textField isFirstResponder];
}


- (BOOL)becomeFirstResponder {//
    return [self.textField becomeFirstResponder];
}


- (BOOL)resignFirstResponder {
    [self.textField resignFirstResponder];
    return YES;
}


#pragma mark - Cleanup

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation CMCMSearchBarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = sBackgroundColor;
        self.layer.cornerRadius = 18.0f;
    }
    return self;
}

@end
