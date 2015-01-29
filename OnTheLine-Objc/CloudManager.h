//
//  CloudManager.h
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/28/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@interface CloudManager : NSObject

+ (CloudManager *)sharedInstance;

- (void)uploadAssetWithURL:(NSURL *)assetURL message:(NSString *)message completionHandler:(void (^)(CKRecord *record))completionHandler;
- (void)fetchRecordWithID:(NSString *)recordID completionHandler:(void (^)(CKRecord *record))completionHandler;
- (void)fetchRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *records))completionHandler;

@end
