
//Reset the default admin user password because Scratch orgs don't supply password to be able to login directly
User u = [select id,name, LastName, FirstName, username, ProfileId,  alias, email, TimeZoneSidKey, LanguageLocaleKey, EmailEncodingKey, LocaleSidKey
          from User where IsActive=true and Profile.Name='System Administrator' limit 1];
//Email user on password reset so they have the link to login again in case they close their browser.
System.resetPassword (u.Id, true);
