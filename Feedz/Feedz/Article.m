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

@synthesize images, littleImage, bigImage, lDescription, title, content, id_, seederId, author, entity, user_id;

- (instancetype) initWithEntity: (NSManagedObject *) object
{
	if (self = [super init])
	{
		@try {
			entity = object;
			title = [object valueForKey: @"title"];
			content = [object valueForKey: @"content"];
			id_ = [[object valueForKey: @"id"] integerValue];
			seederId = [[object valueForKey: @"seeder"] integerValue];
			images = [object valueForKey: @"images"];
			littleImage = [object valueForKey: @"littleImage"];
			bigImage = [object valueForKey: @"bigImage"];
			lDescription = [object valueForKey: @"lDescription"];
			author = [object valueForKey: @"author"];
			user_id = [object valueForKey: @"user_id"];
		}
		@catch (NSException *exception) {
			NSLog(@"Exception: %@", exception);
		}
	}
	return  self;
}

@end
