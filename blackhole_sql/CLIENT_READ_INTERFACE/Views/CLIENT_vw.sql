

CREATE VIEW
/*
Purpose: Client view as the interface for GraphQL
     
Users:  GraphQL API

Usage:	SELECT * from [CLIENT_READ_INTERFACE].[CLIENT_vw]

Modifications:

    Date:   10-Jun-2021 elena.table@symend.com
    Jira:   https://symend.atlassian.net/browse/FAB-50
    Change Description: Created

*/
[CLIENT_READ_INTERFACE].[CLIENT_vw]
AS
WITH cte
(ClientID, ClientParentID, ClientOrgKey, OrganizationName, OrganizationParentName, OrganizationPath, AppExtensions, ClientExtensions, ProductExtensions,ScienceExtension,Labels )
AS (
   SELECT   c.ClientID
          , c.ClientParentID
          , c.ClientOrgKey
          , CAST(c.OrganizationName AS NVARCHAR(2000)) OrganizationName
          , CASE
                WHEN ClientParentID IS NULL THEN
                    NULL
                ELSE
                    CAST(c.OrganizationName AS NVARCHAR(2000))
            END OrganizationParentName
          , CAST(c.OrganizationName AS NVARCHAR(2000)) OrganizationPath
          , CAST(c.AppExtensions AS NVARCHAR(MAX)) AppExtensions
		  , CAST(c.ClientExtensions AS NVARCHAR(MAX)) ClientExtensions
		  , CAST(c.ProductExtensions AS NVARCHAR(MAX)) ProductExtensions
		  , CAST(c.ScienceExtensions AS NVARCHAR(MAX)) ScienceExtensions
		  , CAST(c.Labels AS NVARCHAR(4000))  Labels
   FROM [CLIENT_READ_STORE].[CLIENT] c
   WHERE c.ClientParentID IS NULL
   UNION ALL
   SELECT   c.ClientID
          , c.ClientParentID
          , c.ClientOrgKey
          , CAST(c.OrganizationName AS NVARCHAR(2000)) OrganizationName
          , CAST(cte.OrganizationName AS NVARCHAR(2000)) OrganizationParentName
          , CAST(cte.OrganizationPath + N'-->' + c.OrganizationName AS NVARCHAR(2000))
          , CAST(c.AppExtensions AS NVARCHAR(MAX)) AppExtensions
		  , CAST(c.ClientExtensions AS NVARCHAR(MAX)) ClientExtensions
		  , CAST(c.ProductExtensions AS NVARCHAR(MAX)) ProductExtensions
		  , CAST(c.ScienceExtensions AS NVARCHAR(MAX)) ScienceExtensions
		  , CAST(c.Labels AS NVARCHAR(4000))  Labels
   FROM [CLIENT_READ_STORE].[CLIENT] c
        INNER JOIN cte ON c.ClientParentID = cte.ClientID)
SELECT  cte.ClientOrgKey
      , cte.OrganizationName
      , cte.OrganizationParentName
      , cte.OrganizationPath
      , cte.AppExtensions
      , cte.ClientExtensions
      , cte.ProductExtensions
      , cte.ScienceExtension
      , cte.Labels
FROM    cte;



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client Entity', @level0type = N'SCHEMA', @level0name = N'CLIENT_READ_INTERFACE', @level1type = N'VIEW', @level1name = N'CLIENT_vw';

