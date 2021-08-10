#import "FMController.h"
@import Foundation;
@import UIKit;

@class txtField;

@interface ViewController : UIViewController <UITextFieldDelegate, FMDelegate>



@property (nonatomic, strong) txtField *romPathField;

@property (nonatomic, strong) txtField *patchPathField;

@property (nonatomic, strong) txtField *resultPathField;


@end
