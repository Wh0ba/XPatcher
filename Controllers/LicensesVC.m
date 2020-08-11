#import "LicensesVC.h"
#import "../defs.h"
#import "../CC/Avatar.h"
@interface LicensesVC()

@property (nonatomic, strong) UITextView* mainTextView;

@end

@implementation LicensesVC {
    Avatar *Aang;
}

@synthesize mainTextView;

- (void)loadView {
    [super loadView];
    
    Aang = [Avatar shared];

    self.title = @"Licenses";
    
    self.view.backgroundColor = Aang.currentTheme == XPThemeDark ? [UIColor blackColor] : [UIColor whiteColor];
    
    
    mainTextView = [[UITextView alloc] initWithFrame:self.view.frame textContainer:nil];
    mainTextView.editable = NO;
    mainTextView.selectable = YES;
    mainTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:mainTextView];
    [self applyCostraints];
    mainTextView.backgroundColor = Aang.currentTheme == XPThemeDark ? [UIColor blackColor] : [UIColor whiteColor];
    mainTextView.textColor = Aang.currentTheme == XPThemeDark ? [UIColor whiteColor] : [UIColor blackColor];

    [self setupText];
}



- (void)setupText {
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Licenses" 
                                                 ofType:@"txt" inDirectory:@"licenses"];

    NSError *error;
    NSString* content = [NSString stringWithContentsOfFile:path
                                              encoding:NSUTF8StringEncoding
                                                 error:&error];


    if (error) {
        [Aang alertWithTitle:@"Error reading file" message:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
        return;
    }
    mainTextView.text = content;


}

- (void)applyCostraints {
    [mainTextView setTranslatesAutoresizingMaskIntoConstraints: NO];
  [NSLayoutConstraint constraintWithItem:mainTextView
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.topLayoutGuide
                               attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                                constant:0]
      .active = true;
  [NSLayoutConstraint constraintWithItem:mainTextView
                               attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.bottomLayoutGuide
                               attribute:NSLayoutAttributeTop
                              multiplier:1
                                constant:0]
      .active = true;
  [NSLayoutConstraint constraintWithItem:mainTextView
                               attribute:NSLayoutAttributeLeading
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                               attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                                constant:0]
      .active = true;  [NSLayoutConstraint constraintWithItem:mainTextView                                                                     attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual                                                     toItem:self.view attribute:NSLayoutAttributeTrailing                                                                    multiplier:1.0 constant:0].active = true;                                                                                                                                                                                                                                                                                                                          
}

@end