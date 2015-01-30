//
//  PhotoTableViewCell.m
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/28/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "PhotoTableViewCell.h"
#import "PhotosController.h"
#import "CloudManager.h"

@interface PhotoTableViewCell ()

@property (nonatomic, strong) NSString *photoId;
@property (nonatomic, strong) CKRecord *photo;

@end

@implementation PhotoTableViewCell

- (void)prepareForReuse {
    self.photoImageView.image = nil;
}

- (void)updateWithPhotoId:(NSString *)photoId {
    self.photoId = photoId;
    
    [[PhotosController sharedInstance] downloadRecord:photoId completionHandler:^(CKRecord *record) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CKAsset *asset = record[@"photo"];
            UIImage *image = [UIImage imageWithContentsOfFile:asset.fileURL.path];
            self.photoImageView.image = image;
            
            NSString *dateDiff = [self dateDiff:record[@"createdDate"]];
            self.creationDate.text = dateDiff;
            
            NSArray *messages = record[@"comments"];
            if (messages.count > 0) {
                self.firstMessage.text = messages[0];
            }
                        
            [self setNeedsLayout];
            
        });
        
    }];
}

- (void)updateWithPhotoFileName:(NSString *)photoFileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSData *photoData = [NSData dataWithContentsOfFile:[documentsPath stringByAppendingPathComponent:photoFileName]];
    UIImage *image = [UIImage imageWithData:photoData];
    
    self.photoImageView.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *)dateDiff:(NSDate *)origDate {

    NSDate *todayDate = [NSDate date];
    double ti = [origDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else 	if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"never";
    }	
}

@end
