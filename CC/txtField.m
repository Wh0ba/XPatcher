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


		self.layer.cornerRadius = 7;
		self.layer.borderWidth = 1;
		self.layer.borderColor = kMelroseColor.CGColor;
		self.clipsToBounds = true;
		[self setTintColor:[UIColor redColor]];
		//self.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];      
		self.backgroundColor = [UIColor clearColor];
	}
return self;
}

- (void) applyTheme:(XPTheme)theme {
	if (theme == XPThemeLight){
		
		self.textColor = [UIColor blackColor];
		self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:(self.placeholder ?: @"") attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:0.5]}];
	}
	else {
		
		self.textColor = [UIColor whiteColor];
		self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:(self.placeholder ?: @"") attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.5]}];
	}
}

@end
