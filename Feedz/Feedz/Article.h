//
//  Article.h
//  Feedz
//
//  Created by Morgan Collino on 12/7/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Article : NSObject
{
	NSInteger articleId, authorId, seederId;
	NSString *title, *bigImage, *littleImage, *lDescription, *user_id;
	NSData *content;
	NSArray *images;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *bigImage;
@property (nonatomic, copy) NSString *littleImage;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *lDescription;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic) NSInteger id_;
@property (nonatomic) NSInteger seederId;
@property (nonatomic, strong) NSData *content;
@property (nonatomic, strong) NSManagedObject *entity;

- (instancetype) initWithEntity: (NSManagedObject *) object;

@end
