//
//  IPSAdapter.m
//  MultiPatch
//

#import "IPSAdapter.h"
#include "../Flips/flips.h"

@implementation IPSAdapter
+(MPPatchResult*)ApplyPatch:(NSString*)patch toFile:(NSString*)input andCreate:(NSString*)output{
	struct manifestinfo manifestinfo={false, false, NULL};
    errorinfo result = ApplyPatch(patch.UTF8String,
               input.UTF8String, NO, //<-- Do not verify input param
               output.UTF8String, &manifestinfo, NO);
    
    if(result.level == el_warning){
        return [MPPatchResult newMessage:[@"Warning: " stringByAppendingFormat:@"%s", result.description] isWarning:YES];
    }
    else if(result.level != el_ok){
        return [MPPatchResult newMessage:[@"Failed to apply IPS patch: " stringByAppendingFormat:@"%s", result.description] isWarning:NO];
    }
    return nil;
}

+(MPPatchResult*)CreatePatch:(NSString*)orig withMod:(NSString*)modify andCreate:(NSString*)output{
    struct manifestinfo manifestinfo={false, false, NULL};
    errorinfo result = CreatePatch(orig.UTF8String, modify.UTF8String, patchtype::ty_ips, &manifestinfo, output.UTF8String);
    
    if(result.level == el_warning){
        return [MPPatchResult newMessage:[@"Warning: " stringByAppendingFormat:@"%s", result.description] isWarning:YES];
    }
    else if(result.level != el_ok){
        return [MPPatchResult newMessage:[@"Failed to create IPS patch: " stringByAppendingFormat:@"%s", result.description] isWarning:NO];
    }
    return nil;
}
@end
