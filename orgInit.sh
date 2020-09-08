sfdx force:org:create -f config/project-scratch-def.json  -a WDCScratchOrg -s -d 7


#Command Center managed package
#v3.2
#Get new version from http://work.force.com/workplacecommandcenter
sfdx force:package:install -p 04t5w000005mOu4 -w 50

#Command Center un-managed package
#Get new version from http://work.force.com/employeewellnesssurveysamples
#v3.1
sfdx force:package:install -p 04t5w000005dhbI -w 50


#Deactivating Appiphony app until error is fixed
#Install un-managed packages from Appiphony for their sample Building Management App
# https://github.com/appiphony/building-management-app
sfdx force:package:install -p 04t5w000004Lpu3 -w 50
sfdx force:package:install -p 04t4S000000hXF3 -w 50

#Perm sets have some fields from managed package so package needs to be installed first

#SOurce code has a permission set with workplace license
#This will auto assign WOrkplace license to the user
sfdx force:source:push

#For deploy to non-scratch org
#sfdx force:source:deploy -m ApexClass,CustomObject,LightningComponentBundle,CustomField,StaticResource,SecuritySettings,ApexTrigger,CustomApplication,ContentAsset,FlexiPage,CustomTab,CustomObject


#Perm sets have some fields from managed package so package needs to be installed first
sfdx force:user:permset:assign -n Workplace_Command_Center_Standard_PermSet_Admin_Full_Access_Cloned

#Custom Permission set to grant access to Location.Status__c that is in managed package
sfdx force:user:permset:assign -n Workplace_Command_Center_Admin_Custom


#Permission Sets
#Workplace Admin
sfdx force:user:permset:assign -n b2w_Admin
#Workplace Global Operations Executive
sfdx force:user:permset:assign -n b2w_OperationsExecutive
#Workplace Operations
sfdx force:user:permset:assign -n b2w_Operations

#All AddOn Permission Sets
#sfdx force:user:permset:assign -n b2w_OperationsExecutiveAddOn
#sfdx force:user:permset:assign -n b2w_Workplace_Operations_Addon
#sfdx force:user:permset:assign -n b2w_Workplace_Command_Center_Access
#sfdx force:user:permset:assign -n b2w_AdminAddOn
#sfdx force:user:permset:assign -n b2w_GlobalOperationsExecutiveAddOn
#sfdx force:user:permset:assign -n b2w_GlobalOperationsAddOn


#Appiphony app permission set
#sfdx force:user:permset:assign -n  Command_Center_Appiphony_App_Admin

sfdx force:data:tree:import -p ./testdata/InternalOrganizationUnit-Employee-EmployeeCrisisAssessment-plan.json

sfdx force:apex:execute -f ./dx-utils/apex-scripts/updateLocationVisitorAddressId.apex

#Post install file from Appiphony app
#sfdx force:apex:execute -f ./dx-utils/apex-scripts/convertData.apex

#Extra steps like resetting password for scartch org (if needed)
sfdx force:apex:execute -f ./dx-utils/apex-scripts/demo-setup.apex

#Permission set assignments - These were generated via demo-setup.apex file
#These may not work sa above script seems async
#In that case, assign these 3 manually after the org is created.
sfdx force:user:permset:assign -n Workplace_Admin_Access_Group
sfdx force:user:permset:assign -n Workplace_Command_Center_Access
sfdx force:user:permset:assign -n Workplace_Admin_Objects

sfdx force:org:open 
