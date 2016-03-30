//
//  TaxHelper.m
//  iTax
//
//  Created by Paddy-long on 16/3/29.
//  Copyright © 2016年 Paddy-long. All rights reserved.
//

#import "TaxHelper.h"

@implementation TaxHelper

//税前-->税后
+ (void)getAfterTaxInfoWithsalary:(CGFloat)salary insurance:(CGFloat)insurance block:(SalaryBlock)block
{
    CGFloat salary_beforeTax = salary;

    CGFloat tax = [[self class] taxWithBeforeTaxSalary:salary_beforeTax insurance:insurance];
    CGFloat salary_afterTax = salary_beforeTax - tax - insurance;

    if (block) {
        block(salary_beforeTax,salary_afterTax,tax);
    }
}

//税后-->税前
+ (void)getBeforeTaxInfoWithsalary:(CGFloat)salary insurance:(CGFloat)insurance block:(SalaryBlock)block
{
    CGFloat salary_afterTax = salary;
    CGFloat tax = 0.0;

    //最终收入-3500
    CGFloat tempMoney = salary_afterTax - 3500;
    
    //首先判断税收等级
    //无税收
    if (salary_afterTax <= 3500 && salary_afterTax >= 0) {
        tax = 0.0;
    }
    else if (tempMoney > 0 && tempMoney <= 1500-45){
        //1. 不超过1500元的	 税率:3% 扣除数:0  1500*0.03=45
        //surpass_beforeTax 代表税前超出额度,
        CGFloat surpass_beforeTax = tempMoney/(1-0.03);
        tax = surpass_beforeTax * 0.03;
    }
    else if (tempMoney > (1500-45) && tempMoney < (4500-45-300)){
        CGFloat surpass_beforeTax = (tempMoney-(1500-45))/(1-0.1);
        tax = 45 + surpass_beforeTax * 0.1;
    }
    else if (tempMoney > (4500-45-300) && tempMoney <= (9000-45-300-900)){
        CGFloat surpass_beforeTax = (tempMoney-(4500-45-300))/(1-0.2);
        tax = 45 + 300 + surpass_beforeTax * 0.2;
    }
    else if (tempMoney > (9000-45-300-900) && tempMoney <= (35000-45-300-900-6500)){
        CGFloat surpass_beforeTax = (tempMoney-(9000-45-300-900))/(1-0.25);
        tax = 45 + 300 + 900 + surpass_beforeTax * 0.25;
    }
    else if (tempMoney > (35000-45-300-900-6500) && tempMoney <= (55000-45-300-900-6500-6000)){
        CGFloat surpass_beforeTax = (tempMoney-(35000-45-300-900-6500))/(1-0.3);
        tax = 45 + 300 + 900 + 6500 + surpass_beforeTax * 0.3;
    }
    else if (tempMoney > (55000-45-300-900-6500-6000) && tempMoney <= (80000-45-300-900-6500-6000-8750)){
        CGFloat surpass_beforeTax = (tempMoney-(55000-45-300-900-6500-6000))/(1-0.35);
        tax = 45 + 300 + 900 + 6500 + 6000 + surpass_beforeTax * 0.35;
    }
    else if (tempMoney > (80000-45-300-900-6500-6000-8750)){
        CGFloat surpass_beforeTax = (tempMoney-(80000-45-300-900-6500-6000-8750))/(1-0.45);
        tax = 45 + 300 + 900 + 6500 + 6000 + 8750 + surpass_beforeTax * 0.45;
    }
    
    CGFloat salary_beforeTax = salary_afterTax + insurance + tax;

    if (block) {
        block(salary_beforeTax,salary_afterTax,tax);
    }
}


//个税
+ (CGFloat)taxWithBeforeTaxSalary:(CGFloat)salary_beforeTax insurance:(CGFloat)insurance
{
    /*
     新税法规定：工资扣除五险一金减除3500后，再计算，
     
     级数 全月应纳税所得额（月收入-3500）   税率     扣除数   扣
     1  不超过1500元的	                3%      0       45
     2	超过1500元至4500元的部分	       10%      105     300
     3	超过4500元至9000元的部分          20%      555     900
     4	超过9000元至35000元的部分         25%      1005    6500
     5	超过35000元至55000元的部分        30%      2755    6000
     6	超过55000元至80000元的部分        35%      5505    8750
     7	超过80000元的部分	               45%      13505
     计算公式:个税 = (月收入-社保公积金-3500)*相应税率-扣除额
     */
    
    CGFloat incomeSalary = salary_beforeTax - insurance - 3500;
    CGFloat tax = 0.0;
    
    if(incomeSalary <= 0){
        tax = 0.0;
    }
    else if (incomeSalary < 1500){
        tax = incomeSalary * 0.03;
    }
    else if (incomeSalary < 4500){
        tax = incomeSalary * 0.1 - 105;
    }
    else if (incomeSalary < 9000){
        tax = incomeSalary * 0.2 - 555;
    }
    else if (incomeSalary < 35000){
        tax = incomeSalary * 0.25 - 1005;
    }
    else if (incomeSalary < 55000){
        tax = incomeSalary * 0.3 - 2755;
    }
    else if (incomeSalary < 80000){
        tax = incomeSalary * 0.35 - 5505;
    }
    else{
        tax = incomeSalary * 0.45 - 13505;
    }
    
    return tax;
}


//数字格式化
+ (NSString *)convertToDecimalStyle:(CGFloat)number{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
    [currencyFormatter setPositiveFormat:@"###,##0.00;"];

    NSString *myString = (NSMutableString *)[currencyFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
    return myString;
}


+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

/*
 A(税前),B(税后),N(五险一金)
 P(个税) = (A-N-3500)*25% - 1005
 
 已知税前求税后:
 B = A-P-N = A*75% + (N+3500)*25% + 1005-N
 已知税后求税前:
 A = [B - 3500*25% - 1005]/(75%) + N
 */

@end
