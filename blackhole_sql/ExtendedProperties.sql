EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ClientOrgKey GUID Client Domain Unique Key', @level0type = N'SCHEMA', @level0name = N'CLIENT_READ_INTERFACE', @level1type = N'VIEW', @level1name = N'CLIENT_vw', @level2type = N'COLUMN', @level2name = N'ClientOrgKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CustomerKey GUID Customer Domain Unique Key', @level0type = N'SCHEMA', @level0name = N'CUSTOMER_READ_INTERFACE', @level1type = N'VIEW', @level1name = N'CUSTOMER_vw', @level2type = N'COLUMN', @level2name = N'CustomerKey';

