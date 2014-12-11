//
//  DetailViewController.h
//  Feedz
//
//  Created by Morgan Collino on 11/18/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Article* detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

