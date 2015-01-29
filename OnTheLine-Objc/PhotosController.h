//
//  PhotosController.h
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/27/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@interface PhotosController : NSObject

@property (nonatomic, strong, readonly) NSArray *photoRecordIDs;

+ (PhotosController *)sharedInstance;

- (void)updatePhotos:(void (^)())completion;
- (void)savePhoto:(UIImage *)photo message:(NSString *)message completion:(void (^)(void))completion;
- (void)downloadRecord:(NSString *)recordName completionHandler:(void (^)(CKRecord *record))completionHandler;

@end
