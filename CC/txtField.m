#import "txtField.h"

@implementation txtField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.borderStyle = UITextBorderStyleRoundedRect;
	self.font = [UIFont systemFontOfSize:15];
	
	//self.textAlignment = 1;
	self.keyboardType = UIKeyboardTypeDefault;
	self.returnKeyType = UIReturnKeyDone;
	self.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;    
	//self.textAlignment = NSTextAlignmentCenter;
	
	[self setTintColor:[UIColor redColor]];
        self.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
        
    }
return self;
}

@end