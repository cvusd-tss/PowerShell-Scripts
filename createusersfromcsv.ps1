$Admin = "admin_user"
$AdminPassword = "admin_password"
$Directory = "c-vusd.org"
$NewUserPassword = "Welcome1"
$CsvFilePath = "C:\file.csv"

$SecPass = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ($Admin, $SecPass)
Connect-AzureAD -Credential $cred

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = $NewUserPassword

$NewUsers = import-csv -Path $CsvFilePath

Foreach ($NewUser in $NewUsers) {

    $FirstName = (Get-Culture).TextInfo.ToTitleCase($NewUser.ToLower()."FIRST")
    $LastName = (Get-Culture).TextInfo.ToTitleCase($NewUser.ToLower()."LAST")

    $FirstInitial = $FirstName.substring(0,1)
    $FirstInitial = $FirstInitial.ToLower()

    $LastNameLower = $LastName.ToLower()

    $JobTitle = (Get-Culture).TextInfo.ToTitleCase($NewUser.ToLower()."JOB_TITLE")
    
    $UPN = $FirstInitial + $LastNameLower + "@" + $Directory
    $DisplayName = $FirstName + " " + $LastName
    
    New-AzureADUser -UserPrincipalName $UPN -AccountEnabled $true -DisplayName $DisplayName -GivenName $FirstName -Surname $LastName -JobTitle $JobTitle -PasswordProfile $PasswordProfile
}