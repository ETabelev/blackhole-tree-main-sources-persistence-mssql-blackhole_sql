


CREATE VIEW
/*
Purpose: Test view as the interface for GraphQL
     
Users:  GraphQL API

Usage:	SELECT * from CUSTOMER_READ_INTERFACE.CUSTOMER_vw

Modifications:

    Date:   10-Jun-2021 elena.table@symend.com
    Jira:   https://symend.atlassian.net/browse/FAB-50
    Change Description: Created

*/
[CUSTOMER_READ_INTERFACE].[CUSTOMER_vw]
AS
SELECT  c.CustomerKey
	  , CASE WHEN p.CustomerPersonId IS NULL THEN np.CustomerName ELSE CONCAT(p.FirstName, ' ', p.LastName) END CustomerName
	  , np.BrandName
      , c.Src_CustomerKey
      , c.CustomerType
      , c.AppExtensions CustomerAppExtension
      , c.Labels CustomerLabels
      , ca.AccountKey
      , ca.AccountNumber
      , ca.City
      , ca.ProvinceState
      , ca.Country
      , ca.AppExtensions AccountAppExtension
      , ca.Labels AccountLabels
      , c.ClientKey
      , cl.ClientOrgKey
      , cl.OrganizationName ClientOrgName
FROM    CUSTOMER_READ_STORE.CUSTOMER_MASTER c
        LEFT OUTER JOIN CUSTOMER_READ_STORE.CUSTOMER_PERSON p ON c.CustomerMasterId = p.CustomerMasterId
		LEFT OUTER JOIN CUSTOMER_READ_STORE.CUSTOMER_NONPERSON np ON c.CustomerMasterId = np.CustomerMasterId
        INNER JOIN CLIENT_READ_STORE.CLIENT cl ON cl.ClientID = c.ClientID
        LEFT JOIN CUSTOMER_READ_STORE.CUSTOMER_ACCOUNT ca ON ca.CustomerMasterId = c.CustomerMasterId;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer Entity', @level0type = N'SCHEMA', @level0name = N'CUSTOMER_READ_INTERFACE', @level1type = N'VIEW', @level1name = N'CUSTOMER_vw';

