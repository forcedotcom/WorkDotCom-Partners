// Unassign perm sets 
// There is no way to simply select all, so instead we select those without a likely invalid name
List<PermissionSet> permSets = [SELECT Id FROM PermissionSet WHERE Name != 'invalid'];
for (PermissionSet ps : permSets) {
	try {
        delete [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId = :ps.Id];
	} 
	catch(DmlException e) {
    	// any perm set associated with a profile cannot be unassigned, but thats ok because we'll have another step to unassign all custom profiles too
	}
}
