// Delete test data create by ./dx-utils/load_test_data.sh

List<SObject> locations = database.query('select id, visitoraddressid from Location');

// first set VisitorAddressId to null in each Location record - removes circular dependency that prevents a delete
for (Sobject location : locations) {
	location.put('VisitorAddressId', null);
}

upsert locations;

// delete all records from each object
delete [select id from Address];
delete [select id from EmployeeCrisisAssessment];
delete [select id from Employee];
delete [select id from Crisis];
delete [select id from Individual];
delete [select id from InternalOrganizationUnit];
delete [select id from Location];
