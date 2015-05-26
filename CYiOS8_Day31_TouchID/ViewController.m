//
//  ViewController.m
//  CYiOS8_Day31_TouchID
//
//  Created by Constance Yang on 15/5/13.
//  Copyright (c) 2015年 Constance Yang. All rights reserved.
//

#import "ViewController.h"
#import "CYSecureEngine.h"

@interface ViewController ()
{
    UITextField *secretInputTextField;
    
    UILabel *secretRetrieveLabel;
    
    CYSecureEngine *engine;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set for a margin
    
    self.view.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.view.backgroundColor = [UIColor grayColor];
    
    engine = [[CYSecureEngine alloc]init];
    
    [self initSubViews];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark -- initial subViews

-(void)initSubViews
{
    secretInputTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, 200, 30)];
    
    secretInputTextField.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:secretInputTextField];
    
    secretRetrieveLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 200, 30)];
    
    [self.view addSubview:secretRetrieveLabel];
    
    secretRetrieveLabel.alpha = 0.0;
    
    //button
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [commitButton setTitle:@"Commit" forState:UIControlStateNormal];
    
    commitButton.frame = CGRectMake(20, 150, 100, 30);
    
    commitButton.backgroundColor = [UIColor redColor];
    
    [commitButton addTarget:self action:@selector(commitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:commitButton];
    
    
    UIButton *retrieveBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [retrieveBUtton setTitle:@"Retrieve" forState:UIControlStateNormal];
    
    retrieveBUtton.frame = CGRectMake(130, 150, 100, 30);
    
    retrieveBUtton.backgroundColor = [UIColor redColor];
    
    [retrieveBUtton addTarget:self action:@selector(retrieveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:retrieveBUtton];
}

#pragma mark --
#pragma mark -- button method

-(void)commitButtonPressed:(UIButton *)button
{
    [secretInputTextField resignFirstResponder];
    
    NSString *secretString = secretInputTextField.text;
    
    engine.secretString = secretString;
    
    secretInputTextField.text = @"";
    
    secretRetrieveLabel.text = @"<placeHolder>";
    
}

-(void)retrieveButtonPressed:(UIButton *)button
{
    [secretInputTextField resignFirstResponder];
    
    NSString *secretString = engine.secretString;
    
    secretRetrieveLabel.text = secretString;
    
    secretRetrieveLabel.alpha = 1.0;
    
}

@end
