//
//  RootViewController.m
//  iTax
//
//  Created by Paddy-long on 16/3/29.
//  Copyright © 2016年 Paddy-long. All rights reserved.
//

#import "RootViewController.h"
#import "AboutViewController.h"
#import "TaxHelper.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UITextField *salaryTextField;      //税前or税后金额
@property (weak, nonatomic) IBOutlet UITextField *insuranceField;       //五险一金

@property (weak, nonatomic) IBOutlet UIButton *btn_beforeTax;           //税前-->税后
@property (weak, nonatomic) IBOutlet UIButton *btn_afterTax;            //税后-->税前

@property (weak, nonatomic) IBOutlet UILabel *taxLab;           //个税
@property (weak, nonatomic) IBOutlet UILabel *beforeTaxLab;     //税前收入
@property (weak, nonatomic) IBOutlet UILabel *afterTaxLab;      //税后收入
@property (weak, nonatomic) IBOutlet UIButton *goDetailBtn;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customNavView];
    [self customSet];
    [self clearData];
}

- (void)customNavView
{
    self.title = @"税前税后互测";
    
    NSDictionary *textAttrDic =@{
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSFontAttributeName:[UIFont systemFontOfSize:18.0f]
                                 };
    
    self.navigationController.navigationBar.titleTextAttributes = textAttrDic;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:HexColor(0x167e45)];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn addTarget:self action:@selector(clearData) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"清除" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = clearItem;
}

- (void)customSet
{
    self.salaryTextField.layer.borderWidth = 1;
    self.salaryTextField.layer.cornerRadius = 2.5;
    self.salaryTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.insuranceField.layer.borderWidth = 1;
    self.insuranceField.layer.cornerRadius = 2.5;
    self.insuranceField.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    self.btn_beforeTax.layer.borderWidth = 1;
    self.btn_beforeTax.layer.cornerRadius = 2.5;
    self.btn_beforeTax.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btn_afterTax.layer.borderWidth = 1;
    self.btn_afterTax.layer.cornerRadius = 2.5;
    self.btn_afterTax.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.btn_beforeTax addTarget:self action:@selector(buttonClickBoforeTax:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_afterTax addTarget:self action:@selector(buttonClickAfterTax:) forControlEvents:UIControlEventTouchUpInside];
    

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDismiss)];
    [self.view addGestureRecognizer:tapGR];


    [self.goDetailBtn setBackgroundImage:[TaxHelper createImageWithColor:HexColor(0x2d84ff)] forState:UIControlStateNormal];
    [self.goDetailBtn addTarget:self action:@selector(go2DetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clearData
{
    self.salaryTextField.text = nil;
    self.insuranceField.text = nil;
    
    self.taxLab.text = @"0.00";
    self.beforeTaxLab.text = @"0.00";
    self.afterTaxLab.text = @"0.00";
}

- (void)keyboardDismiss
{
    [self.view endEditing:YES];
}


#pragma mark -- 计算税收 --
//税前-->税后
- (void)buttonClickBoforeTax:(id)sender
{
    CGFloat salary = [self.salaryTextField.text doubleValue];
    CGFloat insurance = [self.insuranceField.text doubleValue];

    if (salary <= 0.0) {
        return;
    }
    else if (salary < insurance) {
        [self alertWithTitle:@"输入有误😂" messege:@"五险一金 > 税前收入？请输入正确的金额！"];
        return;
    }

    [TaxHelper getAfterTaxInfoWithsalary:salary insurance:insurance block:^(CGFloat salary_beforeTax, CGFloat salary_afterTax, CGFloat tax) {
        [self resetWithsalary:salary_beforeTax afterTaxsalary:salary_afterTax tax:tax];
    }];
}

//税后-->税前
- (void)buttonClickAfterTax:(id)sender
{
    CGFloat salary = [self.salaryTextField.text doubleValue];
    CGFloat insurance = [self.insuranceField.text doubleValue];

    if (salary <= 0.0) {
        return;
    }
    else if (salary < insurance) {
        [self alertWithTitle:@"输入有误😂" messege:@"五险一金 > 税后收入？请输入正确的金额！"];
        return;
    }

    [TaxHelper getBeforeTaxInfoWithsalary:salary insurance:insurance block:^(CGFloat salary_beforeTax, CGFloat salary_afterTax, CGFloat tax) {
        [self resetWithsalary:salary_beforeTax afterTaxsalary:salary_afterTax tax:tax];
    }];
}

- (void)resetWithsalary:(CGFloat)salary_beforeTax afterTaxsalary:(CGFloat)salary_afterTax tax:(CGFloat)tax
{
    self.taxLab.text = [TaxHelper convertToDecimalStyle:tax];
    self.beforeTaxLab.text = [TaxHelper convertToDecimalStyle:salary_beforeTax];
    self.afterTaxLab.text = [TaxHelper convertToDecimalStyle:salary_afterTax];

    NSString *title = nil;
    if (tax > 0) {
        title = @"已达到纳税标准!";
    }else{
        title = @"您的收入还未达到纳税标准😂";
    }
    NSString *msg = [NSString stringWithFormat:@"应交个税: %@\n税前收入: %@\n税后收入: %@",self.taxLab.text,self.beforeTaxLab.text,self.afterTaxLab.text];
    [self alertWithTitle:title messege:msg];

    [self keyboardDismiss];
}

- (void)alertWithTitle:(NSString *)title messege:(NSString *)messege
{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:title message:messege delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertV show];
}


#pragma mark -- 查看详情 --
- (void)go2DetailBtnClick
{
    AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:NSStringFromClass([AboutViewController class]) bundle:nil];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

@end
