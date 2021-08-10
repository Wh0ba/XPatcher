//
//  BPSAdapter.mm
//  MultiPatch
//

#import "BPSAdapter.h"
#include "../Flips/flips.h"

@implementation BPSAdapter
+(MPPatchResult*)ApplyPatch:(NSString*)patch toFile:(NSString*)input andCreate:(NSString*)output{
    struct manifestinfo manifestinfo={false, false, NULL};
    errorinfo result = ApplyPatch(patch.UTF8String,
                                  input.UTF8String, NO, //<-- Do not verify input param
                                  output.UTF8String, &manifestinfo, NO);
    
    if(result.level == el_warning){
        return [MPPatchResult newMessage:[@"Warning: " stringByAppendingFormat:@"%s", result.description] isWarning:YES];
    }
    else if(result.level != el_ok){
        return [MPPatchResult newMessage:[@"Failed to apply BPS patch: " stringByAppendingFormat:@"%s", result.description] isWarning:NO];
    }
    return nil;
}

+(MPPatchResult*)CreatePatchLinear:(NSString*)orig withMod:(NSString*)modify andCreate:(NSString*)output{
    struct manifestinfo manifestinfo={false, false, NULL};
    errorinfo result = CreatePatch(orig.UTF8String, modify.UTF8String, patchtype::ty_bps_linear, &manifestinfo, output.UTF8String);
    
    if(result.level == el_warning){
        return [MPPatchResult newMessage:[@"Warning: " stringByAppendingFormat:@"%s", result.description] isWarning:YES];
    }
    else if(result.level != el_ok){
        return [MPPatchResult newMessage:[@"Failed to create BPS patch: " stringByAppendingFormat:@"%s", result.description] isWarning:NO];
    }
    return nil;
}

+(MPPatchResult*)CreatePatchDelta:(NSString*)orig withMod:(NSString*)modify andCreate:(NSString*)output{
    struct manifestinfo manifestinfo={false, false, NULL};
    errorinfo result = CreatePatch(orig.UTF8String, modify.UTF8String, patchtype::ty_bps, &manifestinfo, output.UTF8String);
    
    if(result.level == el_warning){
        return [MPPatchResult newMessage:[@"Warning: " stringByAppendingFormat:@"%s", result.description] isWarning:YES];
    }
    else if(result.level != el_ok){
        return [MPPatchResult newMessage:[@"Failed to create BPS patch: " stringByAppendingFormat:@"%s", result.description] isWarning:NO];
    }
    return nil;
}
@end
