sfdx force:org:create -f config/project-scratch-def.json  -a WDCScratchOrg -s -d 7


#Command Center managed package
sfdx force:package:install -p 04t5w000004iySq -k astrolovescodey -w 50

#Command Center un-managed package
sfdx force:package:install -p 04t5w000005Is02 -k astrolovescodey -w 50
#SOurce code has a permission set with workplace license
#This will auto assign WOrkplace license to the user
sfdx force:source:push



#Perm sets have some fields from managed package so package needs to be installed first
sfdx force:user:permset:assign -n Workplace_Command_Center_Standard_PermSet_Admin_Full_Access_Cloned


#Permission Sets
#Workplace Admin
sfdx force:user:permset:assign -n b2w_Admin
#Workplace Global Operations
sfdx force:user:permset:assign -n b2w_GlobalOperations
#Workplace Operations
sfdx force:user:permset:assign -n b2w_Operations

#All AddOn Permission Sets
sfdx force:user:permset:assign -n b2w_OperationsExecutiveAddOn
sfdx force:user:permset:assign -n b2w_Workplace_Operations_Addon
sfdx force:user:permset:assign -n b2w_Workplace_Command_Center_Access
sfdx force:user:permset:assign -n b2w_AdminAddOn
sfdx force:user:permset:assign -n b2w_GlobalOperationsExecutiveAddOn
sfdx force:user:permset:assign -n b2w_GlobalOperationsAddOn

#Custom Permission set to grant access to Location.Status__c that is in managed package
sfdx force:user:permset:assign -n Workplace_Command_Center_Location_Admin


#Location.Status__c is NOT included in this data set
sfdx force:data:tree:import -p ./testdata/InternalOrganizationUnit-Employee-EmployeeCrisisAssessment-plan.json

sfdx force:apex:execute -f ./dx-utils/apex-scripts/updateLocationVisitorAddressId.apex

sfdx force:org:open 