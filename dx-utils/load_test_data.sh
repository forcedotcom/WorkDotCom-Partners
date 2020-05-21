#!/bin/bash

# Test Data script to load data into the default org
# Default org will be your scratch org or whatever is set with "sfdx force:config:set defaultusername=OrgAlias"

# This runs sfdx force:data:tree:import scripts load data into each object specified by file name
# Example sfdx force:data:tree:import -f Employee__c.json will load data into Employee__c object


echo "Load data into InternalOrganizationUnit, Employee and EmployeeCrisisAssessment"
{ # try
    sfdx force:data:tree:import -p ./testdata/InternalOrganizationUnit-Employee-EmployeeCrisisAssessment-plan.json
    sfdx force:apex:execute -f ./dx-utils/apex-scripts/updateLocationVisitorAddressId.apex

} || { # catch
    echo "Unable to load data "
}



