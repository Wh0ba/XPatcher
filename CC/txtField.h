#import "../defs.h"

@import Foundation;
@import UIKit;

@interface txtField : UITextField<UITextFieldDelegate>
@property (nonatomic, strong) NSURL *fileURL;

- (void) applyTheme:(XPTheme)theme;

@end
