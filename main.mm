#include <Foundation/Foundation.h>
#include <string>
#include <string_view>
#include <variant>
#include <iostream>
#include <iomanip>

using UserValue = std::variant<int, double, bool, std::string, std::nullptr_t>;

auto get_namespace(NSString *kv_namespace) -> NSString * {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundle_identifier = [[bundle infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *application_identifier = bundle_identifier ? bundle_identifier : [[bundle executableURL] lastPathComponent];
    NSString *kv_namespace_str = [NSString stringWithFormat:@"%@.%@", application_identifier, kv_namespace];
    return kv_namespace_str;
}

auto set(const std::string_view kv_namespace, const std::string_view key,
         const UserValue value) -> void {
    NSString *key_str = [NSString stringWithUTF8String:key.data()];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:get_namespace([NSString stringWithUTF8String:kv_namespace.data()])];
    
    if (std::holds_alternative<int>(value)) {
        NSInteger value_int = (NSInteger)std::get<int>(value);
        [defaults setInteger:value_int forKey:key_str];
        return;
    }
    if (std::holds_alternative<double>(value)) {
        double value_double = std::get<double>(value);
        [defaults setDouble:value_double forKey:key_str];
        return;
    }
    if (std::holds_alternative<bool>(value)) {
        bool value_bool = std::get<bool>(value);
        [defaults setBool:value_bool forKey:key_str];
        return;
    }

    NSString *value_str = [NSString stringWithUTF8String:std::get<std::string>(value).c_str()];
    [defaults setObject:value_str forKey:key_str];
}

auto get(const std::string_view kv_namespace, const std::string_view key)
    -> UserValue {
    NSString *key_str = [NSString stringWithUTF8String:key.data()];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:get_namespace([NSString stringWithUTF8String:kv_namespace.data()])];
    id value = [defaults objectForKey:key_str];
    
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        return nullptr;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        if (strcmp([value objCType], @encode(double)) == 0) {
            return static_cast<double>([defaults doubleForKey:key_str]);
        }
        
        if (strcmp([value objCType], @encode(BOOL)) == 0 ||
            strcmp([value objCType], @encode(char)) == 0) {
            return static_cast<bool>([defaults boolForKey:key_str]);
        }
        
        return static_cast<int>([defaults integerForKey:key_str]);
    } else {
        return {std::string([[defaults stringForKey:key_str] UTF8String])};
    }
}

auto remove(const std::string_view kv_namespace, const std::string_view key)
    -> void {
    NSString *key_str = [NSString stringWithUTF8String:key.data()];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:get_namespace([NSString stringWithUTF8String:kv_namespace.data()])];
    
    NSString *result = [defaults stringForKey:key_str];
    
    if (result != nil) {
        [defaults removeObjectForKey:key_str];
    }
}

auto remove_all(const std::string_view kv_namespace) -> void {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:get_namespace([NSString stringWithUTF8String:kv_namespace.data()])];
    [defaults removePersistentDomainForName:get_namespace([NSString stringWithUTF8String:kv_namespace.data()])];
}

int main (int argc, const char * argv[])
{
    // Test setting and getting values
    set("namespace", "key_int", 10);
    set("namespace", "key_double", 3.14);
    set("namespace", "key_bool", true);
    set("namespace", "key_string", "Hello, world!");

    UserValue intValue = get("namespace", "key_int");
    UserValue doubleValue = get("namespace", "key_double");
    UserValue boolValue = get("namespace", "key_bool");
    UserValue stringValue = get("namespace", "key_string");

    if (std::holds_alternative<int>(intValue)) {
        std::cout << "Retrieved int value: " << std::get<int>(intValue) << std::endl;
    }

    if (std::holds_alternative<double>(doubleValue)) {
        std::cout << "Retrieved double value: " << std::get<double>(doubleValue) << std::endl;
    }

    if (std::holds_alternative<bool>(boolValue)) {
        std::cout << "Retrieved bool value: " << std::boolalpha << std::get<bool>(boolValue) << std::endl;
    }

    if (std::holds_alternative<std::string>(stringValue)) {
        std::cout << "Retrieved string value: " << std::get<std::string>(stringValue) << std::endl;
    }

    // Test removing a value
    remove("namespace", "key_int");
    UserValue removedValue = get("namespace", "key_int");
    if (std::holds_alternative<std::nullptr_t>(removedValue)) {
        std::cout << "Value removed successfully." << std::endl;
    }

    // Test removing all values under a namespace
    remove_all("namespace");
    UserValue removedAllValue = get("namespace", "key_double");
    if (std::holds_alternative<std::nullptr_t>(removedAllValue)) {
        std::cout << "All values under 'namespace' removed successfully." << std::endl;
    }

    return 0;
}
