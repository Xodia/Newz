//
//  Article.m
//  Feedz
//
//  Created by Morgan Collino on 12/7/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import "Article.h"
#import <CoreData/CoreData.h>

@implementation Article

@synthesize identifier, title, link, date, updated, summary, content, author, entity;

- (instancetype) initWithEntity: (NSManagedObject *) object
{
	if (self = [super init])
	{
		@try {
			entity = object;
			title = [object valueForKey: @"title"];
			content = [object valueForKey: @"content"];
			summary = [object valueForKey: @"summary"];
			identifier = [object valueForKey: @"identifier"];
			link = [object valueForKey: @"link"];
			author = [object valueForKey: @"author"];
			date = [object valueForKey: @"date"];
			updated = [object valueForKey: @"updated"];
		}
		@catch (NSException *exception) {
			NSLog(@"Exception: %@", exception);
		}
	}
	return  self;
}

@end
