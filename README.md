# Useful (or not) PowerShell scripts
See also my PoSh implementations of Grokking Algorithms [examples](https://github.com/egonSchiele/grokking_algorithms) (lessons 1-9).

## SkypeForBusiness
Tools for administering Skype for Business service
- ADGroup2PolicyMembership.ps1 — put AD group members to corresponding Skype for Business policy groups and clean all others.
- CleanAlwaysOnLogs.ps1 — evenly clean Skype for Business Always On logs cache.
- CreateIVR.ps1 — some examples of how to create and modify an IVR menu.
- UpdateCRLs.ps1 — update CRL lists to avoid [Event 4098 floodings](https://itbasedtelco.wordpress.com/2016/06/14/s4b-front-end-servers-event-4097-flooding/)

## SystemCenter
Tools for different Microsoft System Center services
- CopySUGApproves.ps1 — Configuration Manager script to transfer updates' approves from wave to wave.
- FindFreeNumberRunbook.ps1 — Orchestrator template to manage a phone number assignment based on the user's OU location (1st line of support delegation).
