function Invoke-EXRParseExtendedProperties{
	   [CmdletBinding()] 
    param( 
		[Parameter(Position=1, Mandatory=$false)] [psobject]$Item
    )  
 	Begin
	{
        if($Item.singleValueExtendedProperties.Count -gt 0){
            foreach($Prop in $Item.singleValueExtendedProperties){
                Switch($Prop.Id){
                    "Binary 0x3019" {
                        Add-Member -InputObject $Item -NotePropertyName "PR_POLICY_TAG" -NotePropertyValue ([System.GUID]([Convert]::FromBase64String($Prop.Value)))
                    }
                    "Binary 0x301B" {
                        $fileTime = [BitConverter]::ToInt64([Convert]::FromBase64String($Prop.Value), 4);
                        $StartTime = [DateTime]::FromFileTime($fileTime)
                        Add-Member -InputObject $Item -NotePropertyName "PR_START_DATE_ETC" -NotePropertyValue $StartTime
                    }
                    "Integer 0x301D" {
                        Add-Member -InputObject $Item -NotePropertyName "PR_RETENTION_FLAGS" -NotePropertyValue $Prop.Value
                    }
                    "Integer 0x301A" {
                        Add-Member -InputObject $Item -NotePropertyName "PR_RETENTION_PERIOD" -NotePropertyValue $Prop.Value
                    }
                    "SystemTime 0x301C" {
                        Add-Member -InputObject $Item -NotePropertyName "PR_RETENTION_DATE" -NotePropertyValue ([DateTime]::Parse($Prop.Value))
                    }
		             "String {403fc56b-cd30-47c5-86f8-ede9e35a022b} Name ComplianceTag" {
                        Add-Member -InputObject $Item -NotePropertyName "ComplianceTag" -NotePropertyValue $Prop.Value
                    }
                }
            }
        }
    }
}