//
//  PhotosController.m
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/27/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "PhotosController.h"
#import "CloudManager.h"

@interface PhotosController ()

@property (nonatomic, strong) NSArray *photoRecordIDs;

@end

@implementation PhotosController

+ (PhotosController *)sharedInstance {
    static PhotosController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PhotosController alloc] init];
    });
    return sharedInstance;
}

- (void)updatePhotos:(void (^)())completion {
    [[CloudManager sharedInstance] fetchRecordsWithType:@"Photos" completionHandler:^(NSArray *records) {
        self.photoRecordIDs = [records valueForKeyPath:@"recordID.recordName"];
        [self downloadAssets];
        completion(self.photoRecordIDs);
    }];
}

- (void)downloadAssets {
    for (NSString *recordID in self.photoRecordIDs) {
        [self downloadRecord:recordID completionHandler:nil];
    }
}

- (void)savePhoto:(UIImage *)photo message:(NSString *)message completion:(void (^)(void))completion {
    
    CGSize scaledSize = CGSizeMake(512, 512);
    
    if (photo.size.width > photo.size.height) {
        CGFloat ratio = photo.size.height / photo.size.width;
        scaledSize.height = round(scaledSize.width * ratio);
    } else {
        CGFloat ratio = photo.size.width / photo.size.height;
        scaledSize.width = round(scaledSize.height * ratio);
    }
    
    UIGraphicsBeginImageContext(scaledSize);
    [photo drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    NSData *data = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 0.75);
    UIGraphicsEndImageContext();
    
    // write the image out to a cache file
    NSURL *cachesDirectory = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSString *temporaryName = [[NSUUID UUID].UUIDString stringByAppendingPathExtension:@"jpeg"];
    NSURL *localURL = [cachesDirectory URLByAppendingPathComponent:temporaryName];
    [data writeToURL:localURL atomically:YES];
    
    // upload the cache file as a CKAsset
    [[CloudManager sharedInstance] uploadAssetWithURL:localURL message:message completionHandler:^(CKRecord *record) {
        
        if (record == nil) {
            // Beautifully handle the error in your app
        } else {
            // Do something with the record name
            completion();
        }
    }];
    
}

- (void)downloadRecord:(NSString *)recordName completionHandler:(void (^)(CKRecord *record))completionHandler {
    
    if (recordName == nil) {
        return;
    } else {
        
        [[CloudManager sharedInstance] fetchRecordWithID:recordName completionHandler:^(CKRecord *record) {
            if (completionHandler) {
                completionHandler(record);
            }
        }];
    }
}

@end
