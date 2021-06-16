CREATE TABLE [CLIENT_READ_STORE].[CLIENT] (
    [ClientId]          UNIQUEIDENTIFIER CONSTRAINT [DF_CLIENT_READ_STORE_CLIENT_ClientID] DEFAULT (newsequentialid()) NOT NULL,
    [ClientParentId]    UNIQUEIDENTIFIER NULL,
    [ClientOrgKey]      UNIQUEIDENTIFIER NOT NULL,
    [OrganizationName]  NVARCHAR (255)   NULL,
    [AppExtensions]     NVARCHAR (MAX)   NULL,
    [ProductExtensions] NVARCHAR (MAX)   NULL,
    [ScienceExtensions] NVARCHAR (MAX)   NULL,
    [ClientExtensions]  NVARCHAR (MAX)   NULL,
    [Labels]            NVARCHAR (4000)  NULL,
    [CreatedBy]         NVARCHAR (255)   CONSTRAINT [DF_CLIENT_READ_STORE_CLIENT_CreatedBy] DEFAULT (suser_sname()) NULL,
    [CreatedDate]       DATETIME         CONSTRAINT [DF_CLIENT_READ_STORE_CLIENT_CreatedDate] DEFAULT (getutcdate()) NULL,
    [UpdatedBy]         NVARCHAR (255)   CONSTRAINT [DF_CLIENT_READ_STORE_CLIENT_UpdatedBy] DEFAULT (suser_sname()) NULL,
    [UpdatedDate]       DATETIME         CONSTRAINT [DF_CLIENT_READ_STORE_CLIENT_UpdatedDate] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_CLIENT_READ_STORE_CLIENT_ClientId] PRIMARY KEY CLUSTERED ([ClientId] ASC),
    CONSTRAINT [FK_CLIENT_READ_STORE_CLIENT_ClientParentId] FOREIGN KEY ([ClientParentId]) REFERENCES [CLIENT_READ_STORE].[CLIENT] ([ClientId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_CLIENT_READ_STORE_CLIENT_ClientOrgKey]
    ON [CLIENT_READ_STORE].[CLIENT]([ClientOrgKey] ASC)
    INCLUDE([ClientParentId], [OrganizationName]);


GO
CREATE TRIGGER
/*
Purpose: Trigger to update UpdatedDate and UpdatedBy fields.
       
Modifications:

    Date:   14-jUN-2021 elena.tabelev@symend.com
    Change Description: Created

*/
[CLIENT_READ_STORE].[TR_U_CLIENT]
ON [CLIENT_READ_STORE].[CLIENT]
AFTER UPDATE
AS
BEGIN

    UPDATE  t
    SET UpdatedDate = GETUTCDATE ()
      , UpdatedBy = SUSER_SNAME ()
    FROM    CLIENT_READ_STORE.CLIENT AS t
            JOIN inserted AS i ON t.ClientID = i.ClientID;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client Entity Master', @level0type = N'SCHEMA', @level0name = N'CLIENT_READ_STORE', @level1type = N'TABLE', @level1name = N'CLIENT';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Uniquely generated GUID PK', @level0type = N'SCHEMA', @level0name = N'CLIENT_READ_STORE', @level1type = N'TABLE', @level1name = N'CLIENT', @level2type = N'COLUMN', @level2name = N'ClientId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Self-reference FK', @level0type = N'SCHEMA', @level0name = N'CLIENT_READ_STORE', @level1type = N'TABLE', @level1name = N'CLIENT', @level2type = N'COLUMN', @level2name = N'ClientParentId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Redundant denormalized value of CientOrgKey', @level0type = N'SCHEMA', @level0name = N'CLIENT_READ_STORE', @level1type = N'TABLE', @level1name = N'CLIENT', @level2type = N'COLUMN', @level2name = N'ClientOrgKey';

