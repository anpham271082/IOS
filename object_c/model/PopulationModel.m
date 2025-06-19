#import "PopulationModel.h"
@implementation PopulationModel
+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(id)initWithDictionary:(NSMutableDictionary*)dic{
    self.population = [CTHHelper dictionary:dic Key:@"Population"] ? [[dic valueForKey:@"Population"] doubleValue] : -1;
    self.year = [CTHHelper dictionary:dic Key:@"Year"] ? [[dic valueForKey:@"Year"] integerValue] : -1;
    self.id_year = [CTHHelper dictionary:dic Key:@"ID Year"] ? [[dic valueForKey:@"ID Year"] integerValue] : -1;
    self.id_nation = [CTHHelper dictionary:dic Key:@"ID Nation"] ? [dic valueForKey:@"ID Nation"] : @"";
    self.nation = [CTHHelper dictionary:dic Key:@"Nation"] ? [dic valueForKey:@"Nation"] : @"";
    self.slug_nation = [CTHHelper dictionary:dic Key:@"Slug Nation"] ? [dic valueForKey:@"Slug Nation"] : @"";
    return self;
}
-(NSMutableDictionary*)getDictionary{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[CTHHelper getNumberFormatter:[NSNumber numberWithDouble:self.population] NumberStyle:NSNumberFormatterNoStyle] forKey:@"Population"];
    [dic setValue:[CTHHelper getNumberFormatter:[NSNumber numberWithInteger:self.year] NumberStyle:NSNumberFormatterNoStyle] forKey:@"Year"];
    [dic setValue:[CTHHelper getNumberFormatter:[NSNumber numberWithInteger:self.id_year] NumberStyle:NSNumberFormatterNoStyle] forKey:@"ID Year"];
    [dic setValue:self.id_nation forKey:@"ID Nation"];
    [dic setValue:self.nation forKey:@"Nation"];
    [dic setValue:self.slug_nation forKey:@"Slug Nation"];
    return dic;
}
@end
