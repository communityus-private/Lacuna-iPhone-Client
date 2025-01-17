//
//  LETableViewCellShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Ship;


@interface LETableViewCellShip : UITableViewCell {
	UILabel *nameLabel;
	UILabel *typeLabel;
	UILabel *speedLabel;
	UILabel *holdSizeLabel;
	UILabel *stealthLabel;
	UIImageView *shipImageView;
}


@property(nonatomic, retain) IBOutlet UILabel *nameLabel;
@property(nonatomic, retain) IBOutlet UILabel *typeLabel;
@property(nonatomic, retain) IBOutlet UILabel *speedLabel;
@property(nonatomic, retain) IBOutlet UILabel *holdSizeLabel;
@property(nonatomic, retain) IBOutlet UILabel *stealthLabel;
@property(nonatomic, retain) IBOutlet UIImageView *shipImageView;


- (void)setShip:(Ship *)ship;

+ (LETableViewCellShip *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
