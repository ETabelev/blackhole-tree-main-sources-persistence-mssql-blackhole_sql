CREATE TABLE [CUSTOMER_READ_STORE].[CUSTOMER_MASTER] (
    [CustomerMasterId]  UNIQUEIDENTIFIER CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_CustomerID] DEFAULT (newsequentialid()) NOT NULL,
    [CustomerKey]       UNIQUEIDENTIFIER NOT NULL,
    [ClientId]          UNIQUEIDENTIFIER NOT NULL,
    [ClientOrgKey]      UNIQUEIDENTIFIER NOT NULL,
    [ClientKey]         UNIQUEIDENTIFIER NOT NULL,
    [CustomerName]      NVARCHAR (255)   NULL,
    [Src_CustomerKey]   NVARCHAR (255)   NULL,
    [CustomerType]      NVARCHAR (255)   NULL,
    [AppExtensions]     NVARCHAR (MAX)   NULL,
    [ProductExtensions] NVARCHAR (MAX)   NULL,
    [ScienceExtensions] NVARCHAR (MAX)   NULL,
    [ClientExtensions]  NVARCHAR (MAX)   NULL,
    [Labels]            NVARCHAR (4000)  NULL,
    [CreatedBy]         NVARCHAR (255)   CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDate]       DATETIME         CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_CreatedDate] DEFAULT (getutcdate()) NULL,
    [UpdatedBy]         NVARCHAR (255)   CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_UpdatedBy] DEFAULT (suser_sname()) NULL,
    [UpdatedDate]       DATETIME         CONSTRAINT [DF_CUSTOMER_READ_STORE_CUSTOMER_UpdatedDate] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_CUSTOMER_READ_STORE_CUSTOMER_MASTER_CustomerMasterId] PRIMARY KEY CLUSTERED ([CustomerMasterId] ASC),
    CONSTRAINT [FK_CUSTOMER_READ_STORE_CUSTOMER_MASTER_ClientID] FOREIGN KEY ([ClientId]) REFERENCES [CLIENT_READ_STORE].[CLIENT] ([ClientId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_CUSTOMER_READ_STORE_CUSTOMER_CustomerKey]
    ON [CUSTOMER_READ_STORE].[CUSTOMER_MASTER]([CustomerKey] ASC)
    INCLUDE([ClientOrgKey], [Src_CustomerKey], [CustomerType]);


GO


CREATE TRIGGER 
/*
Purpose: Trigger to update UpdatedDate and UpdatedBy fields.
       
Modifications:

    Date:   14-jUN-2021 elena.tabelev@symend.com
    Change Description: Created

*/ [CUSTOMER_READ_STORE].[TR_U_CUSTOMER_MASTER] ON [CUSTOMER_READ_STORE].[CUSTOMER_MASTER]
   AFTER UPDATE
AS
BEGIN

   UPDATE   t
   SET      UpdatedDate = GETUTCDATE()
          , UpdatedBy = SUSER_SNAME()
   FROM     CUSTOMER_READ_STORE.CUSTOMER AS t
            JOIN inserted AS i ON t.CustomerMasterID = i.CustomerMasterID
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer Entity', @level0type = N'SCHEMA', @level0name = N'CUSTOMER_READ_STORE', @level1type = N'TABLE', @level1name = N'CUSTOMER_MASTER';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer Unique Identifier', @level0type = N'SCHEMA', @level0name = N'CUSTOMER_READ_STORE', @level1type = N'TABLE', @level1name = N'CUSTOMER_MASTER', @level2type = N'COLUMN', @level2name = N'CustomerKey';

