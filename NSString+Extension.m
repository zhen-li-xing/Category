//
//  NSString+Extension.m
//  SomeFunction
//
//  Created by 李震 on 16/8/5.
//  Copyright © 2016年 lizhen. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL) isValidateMobile {
    //手机号以13, 15, 17, 18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)validateIdentityCard{
    BOOL flag;
    if (self.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:self];
    
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(self.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }
}

- (BOOL)validateContainsSpace {
    return [self rangeOfString:@" "].location == NSNotFound;
}

- (NSString *)ageFromBirthday {
    if (self.length != 10 ||
        [self characterAtIndex:4] != '.' ||
        [self characterAtIndex:7] != '.') {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    
    NSString *selfYear = [self substringToIndex:4];
    NSString *nowYear = [today substringToIndex:4];
    NSInteger age = nowYear.integerValue - selfYear.integerValue;
    
    NSString *selfDate = [self substringFromIndex:5];
    NSString *nowDate = [today substringFromIndex:5];
    if ([nowDate compare:selfDate] < 0) {
        age = age - 1;
    }
    
    if (age < 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%ld", age];
}

- (NSString *)ageFromIDCard {
    NSString *birthday = [self birthdayFromIDCard];
    
    return [birthday ageFromBirthday];
}

- (NSString*)birthdayFromIDCard {
    NSString *result = @"未知";
    if (self.length == 15) {
        NSMutableString *birthString = [[self substringWithRange:NSMakeRange(6, 6)] mutableCopy];
        [birthString insertString:@"19" atIndex:0];
        [birthString insertString:@"." atIndex:4];
        [birthString insertString:@"." atIndex:7];
        result = birthString;
    } else if (self.length == 18) {
        NSMutableString *birthString = [[self substringWithRange:NSMakeRange(6, 8)] mutableCopy];
        [birthString insertString:@"." atIndex:4];
        [birthString insertString:@"." atIndex:7];
        result = birthString;
    }
    
    return result;
}

- (NSString*)sexFromIDCard {
    NSString *sexString = @"";
    
    if (self.length == 15) {
        sexString =  [[self substringWithRange:NSMakeRange(14, 1)] mutableCopy];
    } else if (self.length == 18) {
        sexString = [[self substringWithRange:NSMakeRange(16, 1)] mutableCopy];
    } else {
        return @"";
    }
    
    char c = [sexString UTF8String][0];
    if (c < '0' || c > '9') {
        return @"";
    }
    int x = sexString.intValue;
    if (x < 0 || sexString.length == 0) {
        return @"";
    }
    if (x % 2 == 0) {
        return @"女";
    } else {
        return @"男";
    }
    return sexString;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (NSString *)stringWithMoneyAmount:(double)amount {
    BOOL minus = amount < 0;
    if (minus) {
        amount = -amount;
    }
    NSMutableString *toString = [NSMutableString string];
    long round = floor(amount);
    int fraction = floor((amount - round + 0.005) * 100.0);
    NSString *fractionString = [NSString stringWithFormat:@".%02d", fraction];
    
    do {
        int thousand = round % 1000;
        if (round < 1000) {
            [toString insertString:[NSString stringWithFormat:@"%d", thousand] atIndex:0];
        } else {
            [toString insertString:[NSString stringWithFormat:@",%03d", thousand] atIndex:0];
        }
        round = round / 1000;
    } while (round);
    [toString appendString:fractionString];
    if (minus) {
        [toString insertString:@"-" atIndex:0];
    }
    return toString;
}

+ (NSString *)stringWithMoneyAmountInChinese:(double)amount {
    if (amount < 10000) {
        return [NSString stringWithFormat:@"%g", amount];
    } else {
        // 在百位四舍五入，比如12356变成124
        amount = round(amount / 100.0);
        amount = amount / 100;
        return [NSString stringWithFormat:@"%g万", amount];
    }
}

+ (NSString *)stringIntervalFrom:(NSDate *)start to:(NSDate *)end {
    NSInteger interval = end.timeIntervalSince1970 - start.timeIntervalSince1970;
    if (interval <= 0) {
        return @"刚刚";
    }
    
    if (interval < 60) {
        return [NSString stringWithFormat:@"%zd 秒前", interval];
    }
    
    interval = interval / 60;
    if (interval < 60) {
        return [NSString stringWithFormat:@"%zd 分钟前", interval];
    }
    
    interval = interval / 60;
    if (interval < 24) {
        return [NSString stringWithFormat:@"%zd 小时前", interval];
    }
    
    interval = interval / 24;
    if (interval < 7) {
        return [NSString stringWithFormat:@"%zd 天前", interval];
    }
    
    if (interval < 30) {
        return [NSString stringWithFormat:@"%zd 周前", interval / 7];
    }
    
    if (interval < 365) {
        return [NSString stringWithFormat:@"%zd 个月前", interval / 30];
    }
    return [NSString stringWithFormat:@"%zd 年前", interval / 365];
}
//邮箱
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isEmptyString {
    return self.length == 0 || [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}

- (NSString *)hideInformation {
    static const NSInteger kVisibleLength = 4;
    if (self.length <= kVisibleLength) {
        return self;
    }
    NSInteger length = self.length - kVisibleLength * 2;
    NSMutableString *result = [self mutableCopy];
    for (NSInteger i = 0; i < length; i++) {
        [result replaceCharactersInRange:NSMakeRange(i + kVisibleLength, 1) withString:@"*"];
    }
    return result;
}

- (long long)fileSize
{
    // 1.文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.判断file是否存在
    BOOL isDirectory = NO;
    BOOL fileExists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    // 文件\文件夹不存在
    if (fileExists == NO) return 0;
    
    // 3.判断file是否为文件夹
    if (isDirectory) { // 是文件夹
        NSArray *subpaths = [mgr contentsOfDirectoryAtPath:self error:nil];
        long long totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            totalSize += [fullSubpath fileSize];
        }
        return totalSize;
    } else { // 不是文件夹, 文件
        // 直接计算当前文件的尺寸
        NSDictionary *attr = [mgr attributesOfItemAtPath:self error:nil];
        return [attr[NSFileSize] longLongValue];
    }
}

@end
