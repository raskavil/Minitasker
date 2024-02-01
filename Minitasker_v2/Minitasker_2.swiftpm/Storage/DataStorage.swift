import Foundation

class DataStorage {
    
    
    
    
    
    

    @Stored(defaultValue: [], "tasks") private var localTasks: [StorableTask]
    @Stored(defaultValue: [], "groups") private var localGroups: [StorableGroup]
    
    
    
}
