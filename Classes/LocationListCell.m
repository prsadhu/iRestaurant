//
//  LocationListCell.m
//  FindMeARestaurantN
//
//  Created by Praveen Sadhu on 12/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationListCell.h"
#import "Restaurant.h"

#define GREEN_DOT @"green-dot.png"
#define PURPLE_DOT @"purple-dot.png"
#define RED_DOT @"red-dot.png"

@implementation LocationListCell

@synthesize title;
@synthesize address;
@synthesize distance;
@synthesize rating;
@synthesize rating_image;
@synthesize leftButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setData:(Restaurant *)restaurant {

	title.text = restaurant.title ;
	address.text = restaurant.address;
	distance.text = [NSString stringWithFormat:@"%0.1f miles", restaurant.distance];
	rating.text = [NSString stringWithFormat:@"%0.1f", restaurant.rating];
	if( restaurant.rating > 3.5 )
		[rating_image setImage:[UIImage imageNamed:GREEN_DOT]];
	else if( restaurant.rating > 1.5 )
		[rating_image setImage:[UIImage imageNamed:PURPLE_DOT]];
	else
		[rating_image setImage:[UIImage imageNamed:RED_DOT]];

}


- (void)dealloc {
	[title release];
	[address release];
	[distance release];
	[rating release];
	[rating_image release];
    [super dealloc];
}


@end
