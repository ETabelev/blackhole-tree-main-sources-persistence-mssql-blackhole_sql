CREATE TABLE [CUSTOMER_READ_STORE].[CUSTOMER_PERSON] (
    [CustomerPersonId] UNIQUEIDENTIFIER CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_CustomerPersonID] DEFAULT (newsequentialid()) NOT NULL,
    [CustomerMasterId] UNIQUEIDENTIFIER NOT NULL,
    [CustomerKey]      UNIQUEIDENTIFIER NOT NULL,
    [ClientOrgKey]     UNIQUEIDENTIFIER NOT NULL,
    [FirstName]        NVARCHAR (255)   NOT NULL,
    [LastName]         NVARCHAR (255)   NOT NULL,
    [BirthDate]        DATE             NULL,
    [CreatedBy]        NVARCHAR (255)   NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        NVARCHAR (255)   NULL,
    [UpdatedDate]      DATETIME         NULL,
    CONSTRAINT [PK_CUSTOMER_READ_STORE_CUSTOMER_PERSON_CustomerPersonID] PRIMARY KEY CLUSTERED ([CustomerPersonId] ASC),
    CONSTRAINT [FK_CUSTOMER_READ_STORE_CUSTOMER_PERSON_CustomerMasterId] FOREIGN KEY ([CustomerMasterId]) REFERENCES [CUSTOMER_READ_STORE].[CUSTOMER_MASTER] ([CustomerMasterId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_CUSTOMER_READ_STORE_CUSTOMER_Person_CustomerKey]
    ON [CUSTOMER_READ_STORE].[CUSTOMER_PERSON]([CustomerKey] ASC)
    INCLUDE([ClientOrgKey], [FirstName], [LastName]);


GO




CREATE TRIGGER 
/*
Purpose: Trigger to update UpdatedDate and UpdatedBy fields.
       
Modifications:

    Date:   14-jUN-2021 elena.tabelev@symend.com
    Change Description: Created

*/ [CUSTOMER_READ_STORE].[TR_U_CUSTOMER_PERSON] ON [CUSTOMER_READ_STORE].[CUSTOMER_PERSON]
   AFTER UPDATE
AS
BEGIN

   UPDATE   t
   SET      UpdatedDate = GETUTCDATE()
          , UpdatedBy = SUSER_SNAME()
   FROM     CUSTOMER_READ_STORE.CUSTOMER AS t
            JOIN inserted AS i ON t.CustomerPersonID = i.CustomerPersonID
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer Person Sub-Entity of Customer', @level0type = N'SCHEMA', @level0name = N'CUSTOMER_READ_STORE', @level1type = N'TABLE', @level1name = N'CUSTOMER_PERSON';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer Unique Identifier', @level0type = N'SCHEMA', @level0name = N'CUSTOMER_READ_STORE', @level1type = N'TABLE', @level1name = N'CUSTOMER_PERSON', @level2type = N'COLUMN', @level2name = N'CustomerKey';

