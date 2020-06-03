//delete existing buildings and sync data
delete [SELECT Id FROM wdctest__Building__c];

//get all locations
Set<String> locationQueryFields = new Set<String>();
locationQueryFields.addAll(config.locationFieldByBuildingField.values());
locationQueryFields.addAll(config.locationFieldByFloorField.values());
locationQueryFields.add('Id');
locationQueryFields.add('ParentLocationId');
locationQueryFields.add('RootLocationId');

List<String> locationFields = new List<String>();
locationFields.addAll(locationQueryFields);

String locationQuery = 'SELECT ' + String.join(locationFields, ',') + 
                       ' FROM Location';
List<sObject> locations = Database.query(locationQuery);

Map<String, wdctest__Building__c> newBuildingsByLocationId = new Map<String, wdctest__Building__c>();
Map<String, List<wdctest__Floor__c>> newFloorsByParentLocationId = new Map<String, List<wdctest__Floor__c>>();
//populate building and floor records based on locations
for(sObject loc : locations) {
    if(loc.get('ParentLocationId') != null) {
        wdctest__Floor__c newFloor = new wdctest__Floor__c();
        for(String key : config.locationFieldByFloorField.keySet()) {
            String wdcField = config.locationFieldByFloorField.get(key);
            if(loc.get(wdcField) != null) {
                newFloor.put(key, loc.get(wdcField));
            }
        }
        newFloor.put('wdcLocation__c', (String)loc.get('Id'));

        if(newFloorsByParentLocationId.containsKey((String)loc.get('RootLocationId'))) {
            newFloorsByParentLocationId.get((String)loc.get('RootLocationId')).add(newFloor);
        } else{
            newFloorsByParentLocationId.put((String)loc.get('RootLocationId'), new List<wdctest__Floor__c>{newFloor});
        }
    } else{
        wdctest__Building__c newBuilding = new wdctest__Building__c();
        for(String key : config.locationFieldByBuildingField.keySet()) {
            String wdcField = config.locationFieldByBuildingField.get(key);
            if(loc.get(wdcField) != null) {
                newBuilding.put(key, loc.get(wdcField));
            }
        }
        newBuilding.put('wdcLocation__c', (String)loc.get('Id'));

        newBuildingsByLocationId.put((String)loc.get('Id'), newBuilding);
    }
}
insert newBuildingsByLocationId.values();

List<wdctest__Floor__c> newFloors = new List<wdctest__Floor__c>();
//populate parent building field on floors
for(String key : newFloorsByParentLocationId.keySet()) {
    wdctest__Building__c parentBuilding = newBuildingsByLocationId.get(key);
    for(wdctest__Floor__c flr : newFloorsByParentLocationId.get(key)) {
        Integer freqIndex = Integer.valueOf(Math.random()*config.frequencies.size());
        flr.put('wdctest__Building__c', parentBuilding.Id);
        flr.put('wdctest__Cleaning_Frequency_Days__c', config.frequencies.get(freqIndex));
        newFloors.add(flr);
    }
}
insert newFloors;

//create cleanings for floors
List<wdctest__Cleaning__c> cleanings = new List<wdctest__Cleaning__c>();
for(wdctest__Floor__c flr : newFloors) {
    Integer minutes = Integer.valueOf(Math.random() * 60 * -24);
    DateTime cleanTime = DateTime.now().addMinutes(minutes);
    cleanings.add(new wdctest__Cleaning__c(wdctest__Floor__c = flr.Id, wdctest__Cleaning_Time__c = cleanTime));
}
insert cleanings;

//get all employees
Set<String> employeeQueryFields = new Set<String>();
employeeQueryFields.addAll(config.b2WEmployeeFieldByemployeeField.values());
employeeQueryFields.add('Id');
employeeQueryFields.add('LocationId');

List<String> employeeFields = new List<String>();
employeeFields.addAll(employeeQueryFields);

String employeeQuery = 'SELECT ' + String.join(employeeFields, ',') + 
                       ' FROM Employee';
List<sObject> employees = Database.query(employeeQuery);

Map<String, List<wdctest__Employee__c>> newEmployeesByLocationId = new Map<String, List<wdctest__Employee__c>>();

Map<String, String> wdcStatusByb2wStatus = new Map<String, String>();
for(String key : config.back2workStatusByWdcTestStatus.keySet()) {
    wdcStatusByb2wStatus.put(config.back2workStatusByWdcTestStatus.get(key), key);
}

//populate employee records
for(sObject emp : employees) {
    wdctest__Employee__c newEmployee = new wdctest__Employee__c();
    for(String key : config.b2WEmployeeFieldByemployeeField.keySet()) {
        String wdcField = config.b2WEmployeeFieldByemployeeField.get(key);
        if(emp.get(wdcField) != null) {
            if(key == 'wdctest__Status__c') {
                newEmployee.put(key, wdcStatusByb2wStatus.get((String)emp.get(wdcField)));
            } else{
                newEmployee.put(key, emp.get(wdcField));
            }
        }
    }

    if(newEmployee.get('wdctest__Status__c') == null) {
        newEmployee.put('wdctest__Status__c', 'Unknown');
    }

    newEmployee.put('wdcEmployee__c', (String)emp.get('Id'));

    if(newEmployeesByLocationId.containsKey((String)emp.get('LocationId'))) {
        newEmployeesByLocationId.get((String)emp.get('LocationId')).add(newEmployee);
    } else{
        newEmployeesByLocationId.put((String)emp.get('LocationId'), new List<wdctest__Employee__c>{newEmployee});
    }
}

//build map of locationId => floorId
Map<String, String> floorIdByLocationId = new Map<String, String>();
for(sObject flr : newFloors) {
    floorIdByLocationId.put((String)flr.get('wdcLocation__c'), flr.Id);
}

List<wdctest__Employee__c> newEmployees = new List<wdctest__Employee__c>();
for(String locId : newEmployeesByLocationId.keySet()) {
    String floorId;
    if(floorIdByLocationId.containsKey(locId)) {
        floorId = floorIdByLocationId.get(locId);
    } else if(newFloorsByParentLocationId.containsKey(locId)) {
        floorId = (String)newFloorsByParentLocationId.get(locId).get(0).get('Id');
    }

    for(wdctest__Employee__c emp : newEmployeesByLocationId.get(locId)) {
        emp.put('wdctest__Floor__c', floorId);
        newEmployees.add(emp);
    }
}
insert newEmployees;