# Setup work.com scratch org

- Clone this project locally: 
  - git clone https://github.com/forcedotcom/WorkDotCom-Partners.git
- Run orgInit.sh file: Check https://github.com/forcedotcom/WorkDotCom-Partners/blob/master/orgInit.sh for commands
  - ./orgInit.sh


This should create a work.com along with test data.

- Open "Command Center" app to view default dashboard
- Check Setup guide to configure Command Center
- Note extra permissionsets in force-app/main/default/permissionsets
  - Most of those are the same permission from setup guide so you can skip those steps and get right into configuration
  - Let us know if any permission is missing
  - Do not use these in an active org with real user data without reviewing all the permissions


# Feature Dependency check using ISV TE DX Plugin
ISV TE DX plugin has been updated to look for work.com object usage when you add custom fields on those objects. You will be able to see if your package has added any work.com data model dependencies.

To Install or update the plugin: sfdx plugins:install isvte-sfdx-plugin

When executed against a package with depends on Work.com you will see output similar to:

 
=== Installation Warnings

Can be installed in any Edition


Feature and License Dependencies:

  Work.com

More information about this plugin can be found at https://medium.com/inside-the-salesforce-ecosystem/build-better-apps-for-your-customers-with-this-new-dx-plug-in-4877fa0fc305
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
