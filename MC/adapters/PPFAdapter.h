//
//  PPFAdapter.h
//  MultiPatch
//


#import "MPPatchResult.h"

@interface PPFAdapter : NSObject {}
+(MPPatchResult*)errorMsg:(int)error;
+(MPPatchResult*)ApplyPatch:(NSString*)patch toFile:(NSString*)input andCreate:(NSString*)output;
+(MPPatchResult*)CreatePatch:(NSString*)orig withMod:(NSString*)modify andCreate:(NSString*)output;
@end
