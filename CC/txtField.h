#import "../defs.h"


@interface txtField : UITextField<UITextFieldDelegate>
@property (nonatomic, strong) NSURL *fileURL;

- (void) applyTheme:(XPTheme)theme;

@end
