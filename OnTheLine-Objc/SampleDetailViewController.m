//
//  SampleDetailViewController.m
//  OnTheLine-Objc
//
//  Created by Caleb Hicks on 1/29/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "SampleDetailViewController.h"

@interface SampleDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SampleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameLabel.text = self.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
