#import "FMController.h"
#import "SettingsVC.h"
@class txtField;

@interface ViewController : UIViewController <UITextFieldDelegate, FMDelegate>



@property (nonatomic, strong) txtField *romPathField;

@property (nonatomic, strong) txtField *patchPathField;

@property (nonatomic, strong) txtField *resultPathField;


//- (void)setURL:(NSURL *)url forField:(id)tf;


@end
