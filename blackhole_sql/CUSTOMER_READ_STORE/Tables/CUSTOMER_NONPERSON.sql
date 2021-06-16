CREATE TABLE [CUSTOMER_READ_STORE].[CUSTOMER_NONPERSON] (
    [CustomerNonPersonId] UNIQUEIDENTIFIER CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_CustomerNonPersonId] DEFAULT (newsequentialid()) NOT NULL,
    [CustomerMasterId]    UNIQUEIDENTIFIER NOT NULL,
    [CustomerKey]         UNIQUEIDENTIFIER NOT NULL,
    [ClientOrgKey]        UNIQUEIDENTIFIER NOT NULL,
    [CustomerName]        NVARCHAR (255)   NOT NULL,
    [BrandName]           NVARCHAR (255)   NOT NULL,
    [CreatedBy]           NVARCHAR (255)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (255)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    CONSTRAINT [PK_CUSTOMER_READ_STORE_CUSTOMER_NONPERSON_CustomerNonPersonId] PRIMARY KEY CLUSTERED ([CustomerNonPersonId] ASC),
    CONSTRAINT [FK_CUSTOMER_READ_STORE_CUSTOMER_NONPERSON_CustomerMasterId] FOREIGN KEY ([CustomerMasterId]) REFERENCES [CUSTOMER_READ_STORE].[CUSTOMER_MASTER] ([CustomerMasterId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_CUSTOMER_READ_STORE_CUSTOMER_NONPERSON_CustomerKey]
    ON [CUSTOMER_READ_STORE].[CUSTOMER_NONPERSON]([CustomerKey] ASC)
    INCLUDE([ClientOrgKey], [CustomerName], [BrandName]);


GO





CREATE TRIGGER 
/*
Purpose: Trigger to update UpdatedDate and UpdatedBy fields.
       
Modifications:

    Date:   14-jUN-2021 elena.tabelev@symend.com
    Change Description: Created

*/ [CUSTOMER_READ_STORE].[TR_U_CUSTOMER_NONPERSON] ON [CUSTOMER_READ_STORE].[CUSTOMER_NONPERSON]
   AFTER UPDATE
AS
BEGIN

   UPDATE   t
   SET      UpdatedDate = GETUTCDATE()
          , UpdatedBy = SUSER_SNAME()
   FROM     CUSTOMER_READ_STORE.CUSTOMER AS t
            JOIN inserted AS i ON t.CustomerNonPersonId = i.CustomerNonPersonId
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer Non-Person Sub-Entity of Customer', @level0type = N'SCHEMA', @level0name = N'CUSTOMER_READ_STORE', @level1type = N'TABLE', @level1name = N'CUSTOMER_NONPERSON';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer Unique Identifier', @level0type = N'SCHEMA', @level0name = N'CUSTOMER_READ_STORE', @level1type = N'TABLE', @level1name = N'CUSTOMER_NONPERSON', @level2type = N'COLUMN', @level2name = N'CustomerKey';

