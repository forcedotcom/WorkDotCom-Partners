// Updates Location#VisitorAddressId using Address records
// This apex iterates across all addresses and locations
// updating Location#VisitorAddressId with the Address#Id
// when an Address#ParentId is equal to a Location#Id

List<SObject> addresses = database.query('select id, parentId from Address');
List<SObject> locations = database.query('select id, visitoraddressid from Location');

for (Sobject location : locations) {
    for (SObject address : addresses) {
        Object parentId = address.get('ParentId');
        if (parentId == location.get('Id')) {
            location.put('VisitorAddressId', address.get('Id'));
        }
    }
}

upsert locations;
