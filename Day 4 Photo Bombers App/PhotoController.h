//
//  PhotoController.h
//  Day 4 Photo Bombers App
//
//  Created by yeldar.toktasynov on 19.06.15.
//  Copyright (c) 2015 yeldar.toktasynov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoController : NSObject

+(void) imageForPhoto: (NSDictionary *) photo size: (NSString *) size completion: (void(^)(UIImage *image)) completion;

@end
