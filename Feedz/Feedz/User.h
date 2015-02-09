//
//  User.h
//  Feedz
//
//  Created by Morgan Collino on 12/11/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
	NSString *user_id;
	NSString *login;
	NSString *facebook_id;
	BOOL has_gizmodo, has_cnet;
}
@end
