@import Foundation;
@import UIKit;

@interface FMController: UITableViewController <UIDocumentPickerDelegate>

- (instancetype)initWithPath:(NSURL *)path;
@end


