function Update-EXRExcelRange {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [string]
        $MailboxName,
		
        [Parameter(Position = 1, Mandatory = $false)]
        [psobject]
        $AccessToken,

        [Parameter(Position = 2, Mandatory = $false)]
        [psobject]
        $OneDriveFilePath,
		
        [Parameter(Position = 3, Mandatory = $true)]
        [psobject]
        $WorkSheetName,

        [Parameter(Position = 4, Mandatory = $false)]
        [String]
        $RangeTo,
		
        [Parameter(Position = 5, Mandatory = $false)]
        [String]
        $RangeFrom,
		
        [Parameter(Position = 6, Mandatory = $false)]
        [String]
        $Values,

        [Parameter(Position = 7, Mandatory = $false)]
        [String]
        $formula,  

        [Parameter(Position = 8, Mandatory = $false)]
        [String]
        $numberFormat  

    )
    Begin {
        if ($AccessToken -eq $null) {
            $AccessToken = Get-ProfiledToken -MailboxName $MailboxName  
            if ($AccessToken -eq $null) {
                $AccessToken = Get-EXRAccessToken -MailboxName $MailboxName       
            }                 
        }
        if ([String]::IsNullOrEmpty($MailboxName)) {
            $MailboxName = $AccessToken.mailbox
        } 
        $HttpClient = Get-HTTPClient -MailboxName $MailboxName
        $HttpClient = Get-HTTPClient -MailboxName $MailboxName
        $EndPoint = Get-EndPoint -AccessToken $AccessToken -Segment "users"
        $RequestURL = $EndPoint + "('$MailboxName')/drive/root:" + $OneDriveFilePath
        $JSONOutput = Invoke-RestGet -RequestURL $RequestURL -HttpClient $HttpClient -AccessToken $AccessToken -MailboxName $MailboxName
        $ItemURI = (((Get-EndPoint -AccessToken $AccessToken -Segment "users") + "('$MailboxName')/drive") + "/items('" + $JSONOutput.Id + "')") + "/workbook/worksheets('" + $WorkSheetName + "')/range(address='" + $RangeTo + ":" + $RangeFrom + "')"
        $JSONPost = "{`r`n" 
        $JSONPost += "`"values`": " + $Values + "`r`n"
        $JSONPost += "`r`n}"
        $JSONOutput = Invoke-RestPatch -RequestURL $ItemURI -HttpClient $HttpClient -AccessToken $AccessToken -MailboxName $MailboxName -Content $JSONPost
       	return $JSONOutput
    }
}
