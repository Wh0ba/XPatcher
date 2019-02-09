#import "Bookmark.h"
#import "../shared.h"


@implementation Bookmark


- (instancetype)initForNonAppWithName:(NSString*)name URL:(NSURL*)url {
	
	self = [super init];
	if (!self) return nil;
	
	self.name = name;
	self.URL = url;
	self.isApp = NO;
	
	return self;
}

- (instancetype)initForAppWithName:(NSString*)name bundleID:(NSString*)bid {
	
	
	self = [super init];
	if (!self) return nil;
	
	self.name = name;
	self.bundleID = bid;
	self.isApp = YES;
	
	return self;
	
}


- (NSURL*)getAppDataURL {
	
	
	LSApplicationProxy *appProxy = [LSApplicationProxy applicationProxyForIdentifier:self.bundleID];
	return [appProxy.dataContainerURL URLByAppendingPathComponent:@"Documents"];
}



/*
isApp;

bundleID;

URL;

name;
*/





#pragma mark -
#pragma mark NSCodingDelegate

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	if (!self) return nil;
	
	self.name = [decoder decodeObjectForKey:@"name"];
	self.isApp = [decoder decodeBoolForKey:@"isApp"];
	self.URL = [decoder decodeObjectForKey:@"URL"];
	self.bundleID = [decoder decodeObjectForKey:@"bundleID"];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.URL forKey:@"URL"];
    [encoder encodeObject:self.bundleID forKey:@"bundleID"];
    [encoder encodeBool:self.isApp forKey:@"isApp"];
}



@end
