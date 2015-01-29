//
//  SimplePhotosController.h
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/29/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SimplePhotosController : NSObject

+ (SimplePhotosController *)sharedInstance;

@property (nonatomic, strong, readonly) NSArray *photoURLs;

- (void)savePhoto:(UIImage *)photo completion:(void (^)(void))completion;

@end
