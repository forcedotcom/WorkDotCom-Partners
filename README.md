# Setup work.com scratch org

- Clone this project locally: 
  - git clone https://github.com/forcedotcom/WorkDotCom-Partners
- Run orgInit.sh file: Check https://github.com/forcedotcom/WorkDotCom-Partners/blob/master/orgInit.sh for commands
  - ./orgInit.sh


This should create a work.com along with test data.

- Open "Command Center" app to view default dashboard
- Check Setup guide to configure Command Center


- Note extra permissionsets in force-app/main/default/permissionsets
- Those will also be assigned to user
- Most of those are the same permission from setup guide so you can skip those steps and get right into configuration
-- Do not use these in an active org with real user data without reviewing all the permissions


# Test Data Scripts

You can run data scripts using dx-utils/load_test_data.sh file if you don't want to create entire project.

You will need "testdata" and "dx-utils/apex-scripts" directories and run following commands.

#Location.Status__c is NOT included in this data set which is part of Command Center Managed package
sfdx force:data:tree:import -p ./testdata/InternalOrganizationUnit-Employee-EmployeeCrisisAssessment-plan.json

sfdx force:apex:execute -f ./dx-utils/apex-scripts/updateLocationVisitorAddressId.apex


## Notes about Test Data

Test data is for following objects
- Location (Core)
- Employee (Core)
- EmployeeCrisisAssessment (Core)
- Internal Organization Unit (Core)
