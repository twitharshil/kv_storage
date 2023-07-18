#import <Foundation/Foundation.h>

int main (int argc, const char * argv[])
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // Storing values in UserDefaults

    [defaults setInteger:42 forKey:@"AccessNo"];

    NSArray *array = [[NSArray alloc] initWithObjects:@"temp", nil];
    [defaults setObject:array forKey:@"ObjectInfo"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys: @"geeks", @"key1", @"for", @"key2", @"gfgwebsite", @"key3", nil];  

    NSMutableDictionary *mutableDictionary =  [[NSMutableDictionary alloc] init];
    [mutableDictionary setValue:@"gfg" forKey:@"Key1"];

    // Retrieving values from userDefaults
    NSArray *newArr = [defaults arrayForKey:@"ObjectInfo"];
    NSLog(@"Array %@", newArr);


    NSLog(@"Number of entries in Dictionary is : %lu \n", [dictionary count]);
    NSString *myvalue = [dictionary valueForKey:@"key2"];
    NSLog(@"Array %@", myvalue);

    NSLog(@"mutableDictionary %@", mutableDictionary);
    return 0;
}