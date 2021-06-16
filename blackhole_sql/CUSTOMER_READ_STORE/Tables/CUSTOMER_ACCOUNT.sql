CREATE TABLE [CUSTOMER_READ_STORE].[CUSTOMER_ACCOUNT] (
    [CustomerAccountId] UNIQUEIDENTIFIER CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_ACCOUNT_CustomerID] DEFAULT (newsequentialid()) NOT NULL,
    [AccountKey]        UNIQUEIDENTIFIER NOT NULL,
    [CustomerMasterId]  UNIQUEIDENTIFIER NOT NULL,
    [CustomerKey]       UNIQUEIDENTIFIER NULL,
    [ClientOrgKey]      UNIQUEIDENTIFIER NOT NULL,
    [AccountNumber]     NVARCHAR (255)   NOT NULL,
    [City]              NVARCHAR (255)   NOT NULL,
    [ProvinceState]     NVARCHAR (255)   NULL,
    [Country]           NVARCHAR (255)   NOT NULL,
    [AppExtensions]     NVARCHAR (MAX)   NULL,
    [ProductExtensions] NVARCHAR (MAX)   NULL,
    [ScienceExtensions] NVARCHAR (MAX)   NULL,
    [ClientExtensions]  NVARCHAR (MAX)   NULL,
    [Labels]            NVARCHAR (4000)  NULL,
    [CreatedBy]         NVARCHAR (255)   CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_ACCOUNT_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDate]       DATETIME         CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_ACCOUNT_CreatedDate] DEFAULT (getutcdate()) NULL,
    [UpdatedBy]         NVARCHAR (255)   CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_ACCOUNT_UpdatedBy] DEFAULT (suser_sname()) NULL,
    [UpdatedDate]       DATETIME         CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_ACCOUNT_UpdatedDate] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_CUSTOMER_READ_STORE_CUSTOMER_ACCOUNT_CustomerAccountId] PRIMARY KEY CLUSTERED ([CustomerAccountId] ASC),
    CONSTRAINT [FK_CUSTOMER_READ_STORE_CUSTOMER_ACCOUNT_CustomerMasterId] FOREIGN KEY ([CustomerMasterId]) REFERENCES [CUSTOMER_READ_STORE].[CUSTOMER_MASTER] ([CustomerMasterId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_CUSTOMER_READ_STORE_CUSTOMER_ACCOUNT_AccountKey]
    ON [CUSTOMER_READ_STORE].[CUSTOMER_ACCOUNT]([AccountKey] ASC)
    INCLUDE([ClientOrgKey], [CustomerKey], [AccountNumber]);


GO
CREATE TRIGGER 
/*
Purpose: Trigger to update UpdatedDate and UpdatedBy fields.
       
Modifications:

    Date:   14-jUN-2021 elena.tabelev@symend.com
    Change Description: Created

*/ [CUSTOMER_READ_STORE].[TR_U_CUSTOMER_ACCOUNT] ON CUSTOMER_READ_STORE.CUSTOMER_ACCOUNT
   AFTER UPDATE
AS
BEGIN

   UPDATE   t
   SET      UpdatedDate = GETUTCDATE()
          , UpdatedBy = SUSER_SNAME()
   FROM     CUSTOMER_READ_STORE.CUSTOMER_ACCOUNT AS t
            JOIN inserted AS i ON t.CustomerAccountID = i.CustomerAccountID
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Account Entity', @level0type = N'SCHEMA', @level0name = N'CUSTOMER_READ_STORE', @level1type = N'TABLE', @level1name = N'CUSTOMER_ACCOUNT';

