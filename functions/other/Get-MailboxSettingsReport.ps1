﻿function Get-MailboxSettingsReport
{
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[psobject]
		$Mailboxes,
		
		[Parameter(Position = 1, Mandatory = $true)]
		[string]
		$CertFileName,
		
		[Parameter(Mandatory = $True)]
		[Security.SecureString]
		$password
	)
	Begin
	{
		$rptCollection = @()
		$AccessToken = Get-AppOnlyToken -CertFileName $CertFileName -password $password
		$HttpClient = Get-HTTPClient($Mailboxes[0])
		foreach ($MailboxName in $Mailboxes)
		{
			$rptObj = "" | Select-Object MailboxName, Language, Locale, TimeZone, AutomaticReplyStatus
			$EndPoint = Get-EndPoint -AccessToken $AccessToken -Segment "users"
			$RequestURL = $EndPoint + "('$MailboxName')/MailboxSettings"
			$Results = Invoke-RestGet -RequestURL $RequestURL -HttpClient $HttpClient -AccessToken $AccessToken -MailboxName $MailboxName
			$rptObj.MailboxName = $MailboxName
			$rptObj.Language = $Results.Language.DisplayName
			$rptObj.Locale = $Results.Language.Locale
			$rptObj.TimeZone = $Results.TimeZone
			$rptObj.AutomaticReplyStatus = $Results.AutomaticRepliesSetting.Status
			$rptCollection += $rptObj
		}
		Write-Output  $rptCollection
		
	}
}