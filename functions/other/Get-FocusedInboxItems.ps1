﻿function Get-FocusedInboxItems
{
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[string]
		$MailboxName,
		
		[Parameter(Position = 1, Mandatory = $false)]
		[psobject]
		$AccessToken
	)
	Begin
	{
		if ($AccessToken -eq $null)
		{
			$AccessToken = Get-AccessToken -MailboxName $MailboxName
		}
		$HttpClient = Get-HTTPClient($MailboxName)
		$EndPoint = Get-EndPoint -AccessToken $AccessToken -Segment "users"
		$RequestURL = $EndPoint + "('$MailboxName')/MailFolders/Inbox/messages/?`$select=ReceivedDateTime,Sender,Subject,IsRead,InferenceClassification`&`$Top=1000`&`$filter=InferenceClassification eq 'Focused'"
		do
		{
			$JSONOutput = Invoke-RestGet -RequestURL $RequestURL -HttpClient $HttpClient -AccessToken $AccessToken -MailboxName $MailboxName
			foreach ($Message in $JSONOutput.Value)
			{
				Write-Output $Message
			}
			$RequestURL = $JSONOutput.'@odata.nextLink'
		}
		while (![String]::IsNullOrEmpty($RequestURL))
		
	}
}
