//
//  ViewController.m
//  CCPowerLabel
//
//  Created by jack on 16/10/18.
//  Copyright © 2016年 jack. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+Category.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]init];
    UILabel *label2 = [[UILabel alloc]init];

//..case 1
    
    [label makeAttributes:@"qwe",
           MakeTextAlignment(NSTextAlignmentCenter),
           MakeBackgroundColor([UIColor redColor]),
           MakeRect(10,10,100,100),
           MakeTextColor([UIColor blueColor]),
           MakeTextFont([UIFont systemFontOfSize:20.f]),
           AddToSuperView(self.view),
           nil];
    
//..case 2
    
    label.CBackgroundColor([UIColor redColor])
         .CText(@"asdad")
         .CTextColor([UIColor whiteColor])
         .CTextAlignment(1)
         .CFontSize(18.f)
         .CRect(CGRectMake(0, 0, 100, 100))
         .AddToSuperView(self.view);
//..end
    
    [label2 addAttributes:label.attributes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
