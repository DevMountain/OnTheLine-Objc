//
//  PhotoSectionHeaderView.m
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/29/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "PhotoSectionHeaderView.h"
#import "PhotosController.h"
#import "CloudManager.h"

@interface PhotoSectionHeaderView ()

@property (nonatomic, strong) IBOutlet UILabel *userName;

@end

@implementation PhotoSectionHeaderView

- (void)updateWithPhotoId:(NSString *)photoId {
    
    if (!self.userName) {
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width, self.bounds.size.height)];
        self.userName.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.userName];
    }
    
    [[PhotosController sharedInstance] downloadRecord:photoId completionHandler:^(CKRecord *record) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (record[@"user"]) {
                CKReference *reference = record[@"user"];
                [[CloudManager sharedInstance] fetchRecordWithID:reference.recordID.recordName completionHandler:^(CKRecord *record) {
                    self.userName.text = record[@"username"];
                }];
            } else {
                self.userName.text = @"Posted by Anonymous";
            }
        });
    }];
}

@end
