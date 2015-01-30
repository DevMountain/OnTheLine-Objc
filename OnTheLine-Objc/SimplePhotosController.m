//
//  SimplePhotosController.m
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/29/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "SimplePhotosController.h"

@interface SimplePhotosController ()

@property (nonatomic, strong) NSArray *photoURLs;

@end

@implementation SimplePhotosController

@synthesize photoURLs = _photoURLs;

+ (SimplePhotosController *)sharedInstance {
    static SimplePhotosController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SimplePhotosController alloc] init];
    });
    return sharedInstance;
}

- (void)savePhoto:(UIImage *)photo completion:(void (^)(void))completion {

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
    
    NSString *uniqueName = [[NSUUID UUID].UUIDString stringByAppendingPathExtension:@"jpeg"];
    NSString *filePath = [self documentsPathWithFileName:uniqueName];
    
    [data writeToFile:filePath atomically:YES]; //Write the file
    
    NSMutableArray *photos = [[NSMutableArray alloc] initWithArray:self.photoURLs];
    [photos addObject:uniqueName];
    
    self.photoURLs = photos;
    
    completion();
}

- (NSString *)documentsPathWithFileName:(NSString *)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:filename];
}

- (void)setPhotoURLs:(NSArray *)photoURLs {
    [[NSUserDefaults standardUserDefaults] setObject:photoURLs forKey:@"photoURLs"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)photoURLs {
    NSArray *photoURLs = [[NSUserDefaults standardUserDefaults] objectForKey:@"photoURLs"];
    return photoURLs;
}


@end
