//
//  TaxHelper.h
//  iTax
//
//  Created by Paddy-long on 16/3/29.
//  Copyright © 2016年 Paddy-long. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SalaryBlock)(CGFloat salary_beforeTax ,CGFloat salary_afterTax ,CGFloat tax);

@interface TaxHelper : NSObject

/**
 *
 *  税前-->税后
 *
 *  @param salary    税前收入
 *  @param insurance 五险一金
 *  @param block     税前收入+税后收入+个税
 */
+ (void)getAfterTaxInfoWithsalary:(CGFloat)salary insurance:(CGFloat)insurance block:(SalaryBlock)block;

/**
 *
 *  税后-->税前
 *
 *  @param salary    税后收入
 *  @param insurance 五险一金
 *  @param block     税前收入+税后收入+个税
 */
+ (void)getBeforeTaxInfoWithsalary:(CGFloat)salary insurance:(CGFloat)insurance block:(SalaryBlock)block;


/**
 *
 *  转化成标准数字形式 3位一个","
 *
 *  @param number 需要转换的数字
 *
 *  @return 转换之后的字符串
 */
+ (NSString *)convertToDecimalStyle:(CGFloat)number;

+ (UIImage *)createImageWithColor:(UIColor *)color;

@end
