/* For this query to run the AwemeIM.db database must be attached to your working  
messages table. The messages table directory has a 19 digit long filename and the database within the directory is named db.sqlite. You have to attach one of the  
tables to the other in order for this query to run as-is. This query was tested in DB Browser for SQLite  
verion 3.12.2. 
For details see: https://dfir.pubpub.org/pub/h6vyh33u/release/1 and/or https://systoolsgroup.com/updates/retrieve-messages-from-tiktok/
By: S. Rickard     
Forked from: Alexis Brignoni
For details see blog post here: https://abrignoni.blogspot.com/2018/11/finding-tiktok-messages-in-ios.html
	Twitter: @AlexisBrignoni  
	Blog: abrignoni.blogspot.com  
*/

SELECT
TIMMessageORM.belongingConversationIdentifier AS "Conversation Identifier",
AwemeIM.AwemeContactsV6.nickname AS "Sender",
TIMMessageORM.sender AS "Sender ID",
datetime (TIMMessageORM.localCreatedAt, 'UNIXEPOCH', 'lOCALTIME') AS "Timestamp (Local)",
CASE 
	WHEN TIMMessageORM.serverCreatedAt > 0 
	THEN datetime (TIMMessageORM.serverCreatedAt, 'UNIXEPOCH', 'LOCALTIME')
	Else 'Message Not Sent from Device'
END AS "Server Timestamp",
TIMMessageORM.content AS "Message",
TIMMessageORM.contentPb AS "Attachments",
TIMMessageORM.scene,
CASE 
	WHEN TIMMessageORM.deleted = 0 then "No"
	When TIMMessageORM.deleted = 1 then "Yes"
End AS "Deleted Message",
TIMMessageORM.type AS "Message Type"
FROM TIMMessageORM
LEFT JOIN AwemeIM.AwemeContactsV6 on AwemeContactsV6.uid=TIMMessageORM.sender
Order by TIMMessageORM.localCreatedAt ASC
