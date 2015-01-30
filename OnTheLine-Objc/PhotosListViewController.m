//
//  PhotosListViewController.m
//  OnTheLine-Objc
//
//  Created by Joshua Howland on 1/26/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "PhotosListViewController.h"
#import "SimplePhotosController.h"
#import "PhotoTableViewCell.h"

@interface PhotosListViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) bool alreadyLaunched;

@end

@implementation PhotosListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"On The Line";
    [self refresh:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        default:
            return 1;
            break;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PhotosListViewController photoCellHeight];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Take Photo

- (IBAction)takePhoto:(id)sender {

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (CGFloat)photoCellHeight {
    return 210;
}

#pragma mark - Simple PhotoController

- (IBAction)refresh:(id)sender {
    [self.tableView reloadData];
    [sender endRefreshing];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // retrieve the image and resize it down
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [[SimplePhotosController sharedInstance] savePhoto:image completion:^{

        [self refresh:nil];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil]
    ;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [SimplePhotosController sharedInstance].photoURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    [cell updateWithPhotoFileName:[SimplePhotosController sharedInstance].photoURLs[indexPath.section]];
    return cell;
}

@end


