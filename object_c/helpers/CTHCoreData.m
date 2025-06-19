#import <CoreData/CoreData.h>
@implementation CTHCoreData
+(void)addNew:(NSManagedObjectContext *)context Entity:(NSString*)entity Dictionary:(NSDictionary*)dic Attributes:(NSString*)attributes Param:(NSString*)param{
    if([self update:context Entity:entity Dictionary:dic Attributes:attributes Param:param])
        return;
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:context];
    NSArray *array = [attributes componentsSeparatedByString:@"|"];
    for (NSInteger i=0; i<[array count]; i++) {
        [managedObject setValue:[dic valueForKey:[array objectAtIndex:i]]  forKey:[array objectAtIndex:i]];
    }
    NSError *error;
    [context save:&error];
}
+(BOOL)update:(NSManagedObjectContext *)context Entity:(NSString*)entity Dictionary:(NSDictionary*)dic Attributes:(NSString*)attributes Param:(NSString*)param{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entity];
    if(param.length>0){
        [request setPredicate:[NSPredicate predicateWithFormat:@"param == %@", param]];
    }
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count>0){
        NSManagedObject *managedObject = objects[0];
        NSArray *array = [attributes componentsSeparatedByString:@"|"];
        for (NSInteger i=0; i<[array count]; i++) {
            [managedObject setValue:[dic valueForKey:[array objectAtIndex:i]]  forKey:[array objectAtIndex:i]];
        }
        [context save:&error];
        return TRUE;
    }
    return FALSE;
}
+(void)addEntity:(NSManagedObjectContext *)context Entity:(NSString*)entity Dictionary:(NSDictionary*)dic Attributes:(NSString*)attributes Param:(NSString*)param{
     if(param.length==0){
         if([self update:context Entity:entity Dictionary:dic Attributes:attributes Param:param])
            return;
    }
    [self addNew:context Entity:entity Dictionary:dic Attributes:attributes Param:param];
}
+(NSMutableDictionary*)getEntity:(NSManagedObjectContext *)context Entity:(NSString*)entity Param:(NSString*)param{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entity];
    if(param.length>0){
        [request setPredicate:[NSPredicate predicateWithFormat:@"param == %@", param]];
    }
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count>0){
        NSManagedObject *managedObject = objects[0];
        NSString *responseString = [managedObject valueForKey:@"response"];
        NSDictionary *dic = [CTHJson dictionaryWithJSONString:responseString];
        [context save:&error];
        return [NSMutableDictionary dictionaryWithDictionary: dic];
    }
    return nil;
}

@end
