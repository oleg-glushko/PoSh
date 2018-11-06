# In Lync 2013 / Skype for Business 2015 if an IVR menu has more than 2 nested
# levels and/or 4 elements on any specific level you can manage it only by the
# PowerShell commandlets. This script gives you examples of how to create a
# new IVR & make some changes to it.

$ServiceID = "service:ApplicationServer:yourpool.your.site"
$IVRName = "Call Center"
$IVRSIPAddress = 'sip:ivr.call.center@your.site'
$IVRPhoneNumber = '+3010'

# Work schedule, from 00:00 until 23:59
$Hours = New-CsRgsTimeRange -Name "FullDay" -OpenTime "00:00" -CloseTime "23:59"
New-CsRgsHoursOfBusiness -Parent $ServiceID -Name $IVRName -Custom $true `
    -MondayHours1 $Hours -TuesdayHours1 $Hours -WednesdayHours1 $Hours `
    -ThursdayHours1 $Hours -FridayHours1 $Hours -SaturdayHours1 $Hours `
    -SundayHours1 $Hours
$HoursOfBusiness = get-CsRgsHoursOfBusiness -Name $IVRName

# The call's cancel action for out of business hours
$TerminateCall = New-CsRgsCallAction -Action Terminate

# Getting queues into variables (it's assumed they were created beforehand)
$ivr_1_1_q = Get-CsRgsQueue -Name "ivr_1_1_q"
$ivr_1_2_q = Get-CsRgsQueue -Name "ivr_1_2_q"
$ivr_1_3_q = Get-CsRgsQueue -Name "ivr_1_3_q"
$ivr_1_4_q = Get-CsRgsQueue -Name "ivr_1_4_q"
$ivr_1_5_q = Get-CsRgsQueue -Name "ivr_1_5_q"
$ivr_1_6_q = Get-CsRgsQueue -Name "ivr_1_6_q"
$ivr_1_7_q = Get-CsRgsQueue -Name "ivr_1_7_q"
$ivr_2_1_q = Get-CsRgsQueue -Name "ivr_2_1_q"
$ivr_2_2_q = Get-CsRgsQueue -Name "ivr_2_2_q"
$ivr_2_3_q = Get-CsRgsQueue -Name "ivr_2_3_q"
$ivr_2_4_q = Get-CsRgsQueue -Name "ivr_2_4_q"
$ivr_3_q = Get-CsRgsQueue -Name "ivr_3_q"
$ivr_4_q = Get-CsRgsQueue -Name "ivr_4_q"
$ivr_5_1_q = Get-CsRgsQueue -Name "ivr_5_1_q"
$ivr_5_2_q = Get-CsRgsQueue -Name "ivr_5_2_q"
$ivr_5_3_q = Get-CsRgsQueue -Name "ivr_5_3_q"
$ivr_5_4_q = Get-CsRgsQueue -Name "ivr_5_4_q"
$ivr_5_5_q = Get-CsRgsQueue -Name "ivr_5_5_q"
$ivr_5_6_q = Get-CsRgsQueue -Name "ivr_5_6_q"
$ivr_6_1_q = Get-CsRgsQueue -Name "ivr_6_1_q"
$ivr_6_2_q = Get-CsRgsQueue -Name "ivr_6_2_q"
$ivr_0_q = Get-CsRgsQueue -Name "ivr_0_q"

# Import audio prompts, files should exist in appropriate paths, in a WAV format, A-LAW, 8 bit, Mono
$AudioFileRoot = Import-CsRgsAudioFile -Identity $ServiceID -FileName "ivr_callcenter_rootv4.wav" `
    -Content (Get-Content c:\ivr\ivr_callcenter_rootv4.wav -Encoding byte -ReadCount -0)
$AudioFile1 = Import-CsRgsAudioFile -Identity $ServiceID -FileName "ivr_callcenter_1v2.wav" `
    -Content (Get-Content c:\ivr\ivr_callcenter_1v2.wav -Encoding byte -ReadCount -0)
$AudioFile2 = Import-CsRgsAudioFile -Identity $ServiceID -FileName "ivr_callcenter_2v1.wav" `
    -Content (Get-Content c:\ivr\ivr_callcenter_2v1.wav -Encoding byte -ReadCount -0)
$AudioFile5 = Import-CsRgsAudioFile -Identity $ServiceID -FileName "ivr_callcenter_5v1.wav" `
    -Content (Get-Content c:\ivr\ivr_callcenter_5v1.wav -Encoding byte -ReadCount -0)
$AudioFile6 = Import-CsRgsAudioFile -Identity $ServiceID -FileName "ivr_callcenter__6v2.wav" `
    -Content (Get-Content c:\ivr\ivr_callcenter_6v2.wav -Encoding byte -ReadCount -0)

# Nested elements of the IVR menu (they'll be linked below in the root menu creation process)
# Menu 1 - Accounting department
$Action1_1 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_1_1_q.Identity
$Answer1_1 = New-CsRgsAnswer -Action $Action1_1 -DtmfResponse 1
$Action1_2 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_1_2_q.Identity
$Answer1_2 = New-CsRgsAnswer -Action $Action1_2 -DtmfResponse 2
$Action1_3 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_1_3_q.Identity
$Answer1_3 = New-CsRgsAnswer -Action $Action1_3 -DtmfResponse 3
$Action1_4 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_1_4_q.Identity
$Answer1_4 = New-CsRgsAnswer -Action $Action1_4 -DtmfResponse 4
$Action1_5 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_1_5_q.Identity
$Answer1_5 = New-CsRgsAnswer -Action $Action1_5 -DtmfResponse 5
$Action1_6 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_1_6_q.Identity
$Answer1_6 = New-CsRgsAnswer -Action $Action1_6 -DtmfResponse 6
$Action1_7 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_1_7_q.Identity
$Answer1_7 = New-CsRgsAnswer -Action $Action1_7 -DtmfResponse 7

# Menu 2 - Credit controllers
$Action2_1 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_2_1_q.Identity
$Answer2_1 = New-CsRgsAnswer -Action $Action2_1 -DtmfResponse 1
$Action2_2 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_2_2_q.Identity
$Answer2_2 = New-CsRgsAnswer -Action $Action2_2 -DtmfResponse 2
$Action2_3 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_2_3_q.Identity
$Answer2_3 = New-CsRgsAnswer -Action $Action2_3 -DtmfResponse 3
$Action2_4 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_2_4_q.Identity
$Answer2_4 = New-CsRgsAnswer -Action $Action2_4 -DtmfResponse 4

# Menu 5 - HR department
$Action5_1 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_5_1_q.Identity
$Answer5_1 = New-CsRgsAnswer -Action $Action5_1 -DtmfResponse 1
$Action5_2 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_5_2_q.Identity
$Answer5_2 = New-CsRgsAnswer -Action $Action5_2 -DtmfResponse 2
$Action5_3 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_5_3_q.Identity
$Answer5_3 = New-CsRgsAnswer -Action $Action5_3 -DtmfResponse 3
$Action5_4 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_5_4_q.Identity
$Answer5_4 = New-CsRgsAnswer -Action $Action5_4 -DtmfResponse 4
$Action5_5 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_5_5_q.Identity
$Answer5_5 = New-CsRgsAnswer -Action $Action5_5 -DtmfResponse 5
$Action5_6 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_5_6_q.Identity
$Answer5_6 = New-CsRgsAnswer -Action $Action5_6 -DtmfResponse 6

# Menu 6 - Economists
$Action6_1 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_6_1_q.Identity
$Answer6_1 = New-CsRgsAnswer -Action $Action6_1 -DtmfResponse 1
$Action6_2 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_6_2_q.Identity
$Answer6_2 = New-CsRgsAnswer -Action $Action6_2 -DtmfResponse 2


# Root menu elements, take attention, in all below elements, there's the mandatory 
# texttospeechprompt param which is crucial & shouldn't be omitted!
# Element 1 - go to menu 1
$Prompt1 = New-CsRgsPrompt -AudioFilePrompt $AudioFile1 -texttospeechprompt "."
$Question1 = New-CsRgsQuestion -Prompt $Prompt1 -AnswerList ($Answer1_1, $Answer1_2, `
    $Answer1_3, $Answer1_4, $Answer1_5, $Answer1_6, $Answer1_7)
$Action1 = New-CsRgsCallAction -Action TransferToQuestion -Question $Question1
$Answer1 = New-CsRgsAnswer -Action $Action1 -DtmfResponse 1
 
# Element 2 - go to menu 2
$Prompt2 = New-CsRgsPrompt -AudioFilePrompt $AudioFile2 -texttospeechprompt "."
$Question2 = New-CsRgsQuestion -Prompt $Prompt2 -AnswerList ($Answer2_1, $Answer2_2, `
    $Answer2_3, $Answer2_4)
$Action2 = New-CsRgsCallAction -Action TransferToQuestion -Question $Question2
$Answer2 = New-CsRgsAnswer -Action $Action2 -DtmfResponse 2

# Element 3 - transfer to the clearing
$Action3 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_3_q.Identity
$Answer3 = New-CsRgsAnswer -Action $Action3 -DtmfResponse 3 

# Element 4 - transfer to the HR agent
$Action4 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_4_q.Identity
$Answer4 = New-CsRgsAnswer -Action $Action4 -DtmfResponse 4

# Element 5 - go to menu 5
$Prompt5 = New-CsRgsPrompt -AudioFilePrompt $AudioFile5 -texttospeechprompt "."
$Question5 = New-CsRgsQuestion -Prompt $Prompt5 -AnswerList ($Answer5_1, $Answer5_2, `
    $Answer5_3, $Answer5_4, $Answer5_5, $Answer5_6)
$Action5 = New-CsRgsCallAction -Action TransferToQuestion -Question $Question5
$Answer5 = New-CsRgsAnswer -Action $Action5 -DtmfResponse 5

# Element 6 - go to menu 6
$Prompt6 = New-CsRgsPrompt -AudioFilePrompt $AudioFile6 -texttospeechprompt "."
$Question6 = New-CsRgsQuestion -Prompt $Prompt6 -AnswerList ($Answer6_1, $Answer6_2)
$Action6 = New-CsRgsCallAction -Action TransferToQuestion -Question $Question6
$Answer6 = New-CsRgsAnswer -Action $Action6 -DtmfResponse 6

# Element 0 - transfer to the office manager
$Action0 = New-CsRgsCallAction -Action TransferToQueue -QueueID $ivr_0_q.Identity
$Answer0 = New-CsRgsAnswer -Action $Action0 -DtmfResponse 0


# Root menu, take a note of the 'texttospeechprompt' param, it is mandatory in
# Skype for Business 2015 otherwise your menu wouldn't play a prompt! In Lync 2013
# you can safely omit it.
$PromptDefault = New-CsRgsPrompt -AudioFilePrompt $AudioFileRoot -texttospeechprompt "."
$QuestionDefault = New-CsRgsQuestion -Prompt $PromptDefault -AnswerList ($Answer1, $Answer2,`
     $Answer3, $Answer4, $Answer5, $Answer6, $Answer0)
$ActionDefault = New-CsRgsCallAction -Action TransferToQuestion -Question $QuestionDefault

# Generate Workflow based on all previous settings
$WF = New-CsRgsWorkflow -Parent $ServiceId -Name $IVRName -Description $IVRName `
    -PrimaryUri $IVRSIPAddress -LineUri "tel:$IVRPhoneNumber" -DisplayNumber $IVRPhoneNumber `
    -Active $true -Anonymous $false -managed $false -enabledforfederation $true `
    -DefaultAction $ActionDefault -language "ru-RU" -BusinessHoursID $HoursOfBusiness.Identity `
    -NonBusinessHoursAction $TerminateCall -HolidayAction $TerminateCall `
    -timezone "Russian Standard Time"

# ==================================================================================
# Now you can modify the IVR menu using the $WF variable, all the following code is
# about making changes & is optional
# ==================================================================================

# Change some root menu settings
$WF.LineUri = "tel:+3999"
$WF.DisplayNumber = "+3999"
Set-CsRgsWorkflow -Instance $WF

# List root menu elements
$WF.DefaultAction.Question
# List root menu answers
$WF.DefaultAction.Question.AnswerList
# List a specific answer of the root menu
$WF.DefaultAction.Question.AnswerList[$i]
# List inherited menu elements
$WF.DefaultAction.Question.AnswerList[$i].Action

# Fetch readable names of queues by their IDs
$RawQueues = $WF.defaultaction.Question.AnswerList[$i].Action.Question.AnswerList | `
    Where-Object {$_.action.action -eq "TransferToQueue"}
foreach ($Queue in $RawQueues)
{
    Write-Host "DTMFResponse: $($Queue.DTMFResponse)"
    Get-CsRgsQueue -Identity $ServiceID | Where-Object
    {
        $Queue.Action.QueueID -eq $_.Identity} | ForEach-Object
        {
            $_.name
        }
}

# Change the audio prompt in the specific menu's element, note that texttospeechprompt is
# mandatory!
$AudioFile1 = Import-CsRgsAudioFile -Identity $ServiceID -FileName "ivr-callcenter-1v3.wav" `
    -Content (Get-Content "c:\ivr\ivr_oco_1v3.wav" -Encoding byte -ReadCount -0)
$Prompt1 = New-CsRgsPrompt -AudioFilePrompt $AudioFile1 -texttospeechprompt "."
$WF.DefaultAction.Question.AnswerList[0].Action.Question.Prompt = $Prompt1
Set-CsRgsWorkflow $WF

# Remove one element from the nested menu 1 (indexed from 0)
$Item = $WF.DefaultAction.Question.AnswerList[0].Action.Question.AnswerList[6]
$WF.DefaultAction.Question.AnswerList[0].Action.Question.AnswerList.remove($Item)
Set-CsRgsWorkflow $WF

# Add one element to the nested menu 6 (indexed from 0), queue & group should be created beforehand
$Query6_3 = Get-CsRgsQueue -Identity $ServiceID -Name "ivr_6_3_q"
$Action6_3 = New-CsRgsCallAction -Action TransferToQueue -QueueID $Query6_3.Identity
$Answer6_3= New-CsRgsAnswer -Action $Action6_3 -DtmfResponse 3
$WF.DefaultAction.Question.AnswerList[5].Action.Question.AnswerList.Add($Answer6_3)
Set-CsRgsWorkflow $WF

# Add the root menu' section
$AudioFile7 = Import-CsRgsAudioFile -Identity $ServiceID -FileName "ivr-callcenter-7v1.wav" `
    -Content (Get-Content "c:\temp\ivr-callcenter-7v1.wav" -Encoding byte -ReadCount -0)
$Prompt7 = New-CsRgsPrompt -AudioFilePrompt $AudioFile7 -texttospeechprompt "."
$Question7 = New-CsRgsQuestion -Prompt $Prompt7
$Action7 = New-CsRgsCallAction -Prompt $Prompt7 -Action TransferToQuestion -Question $Question7
$Answer7 = New-CsRgsAnswer -Action $Action7 -DtmfResponse 7
$WF.DefaultAction.Question.AnswerList.Add($Answer7)
# Before the next step you have to add elements to the new menu, see the previous example
Set-CsRgsWorkflow $WF