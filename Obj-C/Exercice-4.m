#import <Foundation/Foundation.h>

/**** Helper Class ****/ 
@interface Helpr: NSObject {}
+ (void) printString:(NSString*)val;
@end
@implementation Helpr
+ (void) printString:(NSString*)val {
    printf("%s\n", [val cString]);
}
@end
/**** Helper class end ****/


@interface Etudiant: NSObject {
    @private NSString* fname;
    @private NSString* lname;
    
    @private NSMutableArray* notes;
}
- (id) initWithName:(NSString*)firstname last:(NSString*)lastname;
- (void) addNote:(float)note;
- (float) getAverage;
- (float) getMin;
- (float) getMax;
@end

@implementation Etudiant
- (id) initWithName:(NSString*)firstname last:(NSString*)lastname {

    fname = firstname;
    lname = lastname;
    notes = [[NSMutableArray alloc] init];
    
    return self;
}
- (void) addNote:(float)note {
    NSNumber* n = [NSNumber numberWithFloat:note];
    [notes addObject:n];
}
- (float) getAverage {
     int count = [notes count];
     float sum = 0;
     
     for(NSNumber* note in notes) {
        sum += [note floatValue];
     }
     
     return sum/count;
}
- (float) getMin {  
    float min = [[notes objectAtIndex:0] floatValue];
    for(NSNumber* note in notes) {
        if( min > [note floatValue] ) {
            min = [note floatValue];
        }
    }
    
    return min;
}
- (float) getMax {  
    float max = 0;
    for(NSNumber* note in notes) {
        if( max < [note floatValue] ) {
            max = [note floatValue];
        }
    }
    
    return max;
}
- (NSString*) getName {
    return [NSString stringWithFormat:@"%@ %@", fname, lname];
}
@end


/*************************
Class that will contain and handle "Etudiants"
*/
@interface DBEtudiant: NSObject {
    @private NSMutableDictionary* students;
}
- (void) addStudent:(Etudiant*)student;
- (Etudiant*) getStudent:(NSString*)key;
@end

@implementation DBEtudiant
- (id) init {
    students = [[NSMutableDictionary alloc] init];
    
    return self;
}
- (void) addStudent:(Etudiant*)student {
    NSString* key = [student getName];
    [students setObject:student forKey:key];
}
- (Etudiant*) getStudent:(NSString*)key {
    return [students objectForKey:key];
}
@end
int main (int argc, const char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    NSArray* studentsArray = [[NSArray alloc] initWithObjects:
    [[NSArray alloc] initWithObjects:@"Majid", @"Hamdani", nil], 
    [[NSArray alloc] initWithObjects:@"Some", @"Student", nil], 
    [[NSArray alloc] initWithObjects:@"Other", @"Student", nil], 
    nil];
    
    DBEtudiant* db = [[DBEtudiant alloc] init];
    
    
    for(NSArray* student in studentsArray) {
        NSString* firstname = [student objectAtIndex:0];
        NSString* lastname = [student objectAtIndex:1];
        
        Etudiant* et = [[Etudiant alloc] initWithName:firstname last:lastname];
        
        // Adds 3 notes randomly from 0 to 20
        [et addNote:((float)rand() / RAND_MAX) * 20];
        [et addNote:((float)rand() / RAND_MAX) * 20];
        [et addNote:((float)rand() / RAND_MAX) * 20];
        
        // Add this student to the DB
        [db addStudent:et];
    }
    
    // For example you get the average grade of "Some Student" using this 
    
    printf("Etudiant: Majid Hamdani -> Moyenne = %.2f\n", [[db getStudent:@"Some Student"] getAverage]);
    
    
    [pool drain];
    return 0;

}
