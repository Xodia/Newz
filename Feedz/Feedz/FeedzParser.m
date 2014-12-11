//
//  FeedzParser.m
//  Feedz
//
//  Created by Morgan Collino on 12/11/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import "FeedzParser.h"

@implementation FeedzParser

- (instancetype) init
{
	if (self = [super init])
	{
	
	}
	return  self;
}

+ (instancetype) sharedParser
{
	static FeedzParser *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[self alloc] init];
	});
	
	return shared;
}

@end
