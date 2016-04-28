DECLARE @OldOrganizationId uniqueidentifier, @NewOrganizationId uniqueidentifier

 -- The Old OrganizationId
  SET @OldOrganizationId = (SELECT TOP(1) OrganizationId FROM OrganizationBase)

 -- The New OrganizationId
  SET @NewOrganizationId = (SELECT NEWID())

 --PRINT @OldOrganizationId
  --PRINT @NewOrganizationId

 -- Table with all Found Columns with the OrganizationId
  DECLARE @FoundOrganizationIds TABLE (Id bigint identity(1,1), TableName nvarchar(max), ColumnName nvarchar(max), ColumnValue nvarchar(max))
  
  -- Table with all uniqueidentifier Columns in the Database
  DECLARE  @FoundUniqueIdentifierColumns TABLE(Id bigint identity(1,1), TableName nvarchar(max), ColumnName nvarchar(max))
  
  -- Search for all uniqueidentifier Columns in the Database 
  INSERT INTO @FoundUniqueIdentifierColumns
  SELECT
    col.TABLE_NAME, col.COLUMN_NAME 
  FROM 
   INFORMATION_SCHEMA.TABLES tbl INNER JOIN 
   INFORMATION_SCHEMA.COLUMNS col ON tbl.TABLE_NAME = col.TABLE_NAME
  WHERE 
   tbl.TABLE_TYPE = 'BASE TABLE' AND 
   col.DATA_TYPE IN ('uniqueidentifier')

 DECLARE @ColumnCount bigint
  SET @ColumnCount = (SELECT COUNT(*) FROM @FoundUniqueIdentifierColumns)
  -- PRINT CAST(@ColumnCount as nvarchar)
  
  DECLARE @Iterator bigint
  SET @Iterator = 1
  
  -- Look through all found uniqueidentifier for the Old OrganizationId Columns and Save the TableName/ColumnName in @FoundOrganizationIds
  WHILE @Iterator <= @ColumnCount
   BEGIN
    DECLARE @execsql nvarchar(max)
    DECLARE @TableName nvarchar(max)
    DECLARE @ColumnName nvarchar(max)
    
    SET @TableName = (SELECT TableName FROM @FoundUniqueIdentifierColumns WHERE Id = @Iterator)
    SET @ColumnName = (SELECT ColumnName FROM @FoundUniqueIdentifierColumns WHERE Id = @Iterator)
    
    --PRINT(@TableName)
    --PRINT(@@ColumnName)
    
    SET @execsql = 'SELECT DISTINCT ' + CHAR(39) + @TableName + CHAR(39) + ','
    SET @execsql = @execsql + CHAR(39) + @ColumnName + CHAR(39) + ','
    SET @execsql = @execsql + @ColumnName 
    SET @execsql = @execsql + ' FROM ' 
    SET @execsql = @execsql + @TableName 
    SET @execsql = @execsql + ' WHERE '
    SET @execsql = @execsql + @ColumnName 
    SET @execsql = @execsql + ' = ' + CHAR(39) + CAST(@OldOrganizationId as varchar(50)) + CHAR(39)
    
    INSERT INTO @FoundOrganizationIds (TableName, ColumnName, ColumnValue)
    -- PRINT (@execsql)
    EXEC (@execsql)
    
    SET @Iterator = @Iterator + 1   
   END

 -- SELECT * FROM @FoundOrganizationIds

 DECLARE @ColumnIterator bigint, @ColumnTotal bigint
  SET @ColumnIterator = 1
  SET @ColumnTotal = (SELECT COUNT(id) FROM @FoundOrganizationIds)
  
  PRINT (@ColumnTotal)
  
  -- INSERT New Organization in the OrganizationTable with the new OrganizationId (Copy of the Old Organization but with the new Id)
  INSERT INTO [dbo].[OrganizationBase]
            ([OrganizationId]
            ,[Name]
      ,[UserGroupId]
      ,[PrivilegeUserGroupId]
      ,[FiscalPeriodType]
      ,[FiscalCalendarStart]
      ,[DateFormatCode]
      ,[TimeFormatCode]
      ,[CurrencySymbol]
      ,[WeekStartDayCode]
      ,[DateSeparator]
      ,[FullNameConventionCode]
      ,[NegativeFormatCode]
      ,[NumberFormat]
      ,[IsDisabled]
      ,[DisabledReason]
      ,[KbPrefix]
      ,[CurrentKbNumber]
      ,[CasePrefix]
      ,[CurrentCaseNumber]
      ,[ContractPrefix]
      ,[CurrentContractNumber]
      ,[QuotePrefix]
      ,[CurrentQuoteNumber]
      ,[OrderPrefix]
      ,[CurrentOrderNumber]
      ,[InvoicePrefix]
      ,[CurrentInvoiceNumber]
      ,[UniqueSpecifierLength]
      ,[CreatedOn]
      ,[ModifiedOn]
      ,[FiscalYearFormat]
      ,[FiscalPeriodFormat]
      ,[FiscalYearPeriodConnect]
      ,[LanguageCode]
      ,[SortId]
      ,[DateFormatString]
      ,[TimeFormatString]
      ,[PricingDecimalPrecision]
      ,[ShowWeekNumber]
      ,[NextTrackingNumber]
      ,[TagMaxAggressiveCycles]
      ,[TokenKey]
      ,[SystemUserId]
      ,[CreatedBy]
      ,[GrantAccessToNetworkService]
      ,[AllowOutlookScheduledSyncs]
      ,[AllowMarketingEmailExecution]
      ,[SqlAccessGroupId]
      ,[CurrencyFormatCode]
      ,[FiscalSettingsUpdated]
      ,[ReportingGroupId]
      ,[TokenExpiry]
      ,[ShareToPreviousOwnerOnAssign]
      ,[AcknowledgementTemplateId]
      ,[ModifiedBy]
      ,[IntegrationUserId]
      ,[TrackingTokenIdBase]
      ,[BusinessClosureCalendarId]
      ,[AllowAutoUnsubscribeAcknowledgement]
      ,[AllowAutoUnsubscribe]
      ,[Picture]
      --,[VersionNumber]
      ,[TrackingPrefix]
      ,[MinOutlookSyncInterval]
      ,[BulkOperationPrefix]
      ,[AllowAutoResponseCreation]
      ,[MaximumTrackingNumber]
      ,[CampaignPrefix]
      ,[SqlAccessGroupName]
      ,[CurrentCampaignNumber]
      ,[FiscalYearDisplayCode]
      ,[SiteMapXml]
      ,[IsRegistered]
      ,[ReportingGroupName]
      ,[CurrentBulkOperationNumber]
      ,[SchemaNamePrefix]
      ,[IgnoreInternalEmail]
      ,[TagPollingPeriod]
      ,[TrackingTokenIdDigits]
      ,[NumberGroupFormat]
      ,[LongDateFormatCode]
      ,[UTCConversionTimeZoneCode]
      ,[TimeZoneRuleVersionNumber]
      ,[CurrentImportSequenceNumber]
      ,[ParsedTablePrefix]
      ,[V3CalloutConfigHash]
      ,[IsFiscalPeriodMonthBased]
      ,[LocaleId]
      ,[ParsedTableColumnPrefix]
      ,[SupportUserId]
      ,[AMDesignator]
      ,[CurrencyDisplayOption]
      ,[MinAddressBookSyncInterval]
      ,[IsDuplicateDetectionEnabledForOnlineCreateUpdate]
      ,[FeatureSet]
      ,[BlockedAttachments]
      ,[IsDuplicateDetectionEnabledForOfflineSync]
      ,[AllowOfflineScheduledSyncs]
      ,[AllowUnresolvedPartiesOnEmailSend]
      ,[TimeSeparator]
      ,[CurrentParsedTableNumber]
      ,[MinOfflineSyncInterval]
      ,[AllowWebExcelExport]
      ,[ReferenceSiteMapXml]
      ,[IsDuplicateDetectionEnabledForImport]
      ,[CalendarType]
      ,[SQMEnabled]
      ,[NegativeCurrencyFormatCode]
      ,[AllowAddressBookSyncs]
      ,[ISVIntegrationCode]
      ,[DecimalSymbol]
      ,[MaxUploadFileSize]
      ,[IsAppMode]
      ,[EnablePricingOnCreate]
      ,[IsSOPIntegrationEnabled]
      ,[PMDesignator]
      ,[CurrencyDecimalPrecision]
      ,[MaxAppointmentDurationDays]
      ,[EmailSendPollingPeriod]
      ,[RenderSecureIFrameForEmail]
      ,[NumberSeparator]
      ,[PrivReportingGroupId]
      ,[BaseCurrencyId]
      ,[MaxRecordsForExportToExcel]
      ,[PrivReportingGroupName]
      ,[YearStartWeekCode]
      ,[IsPresenceEnabled]
      ,[IsDuplicateDetectionEnabled]
      ,[RecurrenceExpansionJobBatchInterval]
      ,[DefaultRecurrenceEndRangeType]
      ,[HashMinAddressCount]
      ,[RequireApprovalForUserEmail]
      ,[RecurrenceDefaultNumberOfOccurrences]
      ,[ModifiedOnBehalfBy]
      ,[RequireApprovalForQueueEmail]
      ,[AllowEntityOnlyAudit]
      ,[IsAuditEnabled]
      ,[RecurrenceExpansionSynchCreateMax]
      ,[GoalRollupExpiryTime]
      ,[BaseCurrencyPrecision]
      ,[FiscalPeriodFormatPeriod]
      ,[AllowClientMessageBarAd]
      ,[InitialVersion]
      ,[HashFilterKeywords]
      ,[NextCustomObjectTypeCode]
      ,[ExpireSubscriptionsInDays]
      ,[OrgDbOrgSettings]
      ,[PastExpansionWindow]
      ,[EnableSmartMatching]
      ,[MaxRecordsForLookupFilters]
      ,[BaseCurrencySymbol]
      ,[ReportScriptErrors]
      ,[RecurrenceExpansionJobBatchSize]
      ,[FutureExpansionWindow]
      ,[GetStartedPaneContentEnabled]
      ,[SampleDataImportId]
      ,[BaseISOCurrencyCode]
      ,[GoalRollupFrequency]
      ,[CreatedOnBehalfBy]
      ,[HashDeltaSubjectCount]
      ,[HashMaxCount]
      ,[FiscalYearFormatYear]
      ,[FiscalYearFormatPrefix]
      ,[PinpointLanguageCode]
      ,[FiscalYearFormatSuffix]
      ,[IsUserAccessAuditEnabled]
      ,[UserAccessAuditingInterval]
      ,[AllowUserFormModePreference]
      ,[QuickFindRecordLimitEnabled]
      ,[UseReadForm]
      ,[YammerGroupId]
      ,[IsDefaultCountryCodeCheckEnabled]
      ,[MetadataSyncLastTimeOfNeverExpiredDeletedObjects]
      ,[YammerOAuthAccessTokenExpired]
      ,[UseSkypeProtocol]
      ,[DefaultCountryCode]
      ,[MetadataSyncTimestamp]
      ,[YammerNetworkPermalink]
      ,[YammerPostMethod]
      ,[EnableBingMapsIntegration])
  SELECT 
     @NewOrganizationId,
     [Name]
      ,[UserGroupId]
      ,[PrivilegeUserGroupId]
      ,[FiscalPeriodType]
      ,[FiscalCalendarStart]
      ,[DateFormatCode]
      ,[TimeFormatCode]
      ,[CurrencySymbol]
      ,[WeekStartDayCode]
      ,[DateSeparator]
      ,[FullNameConventionCode]
      ,[NegativeFormatCode]
      ,[NumberFormat]
      ,[IsDisabled]
      ,[DisabledReason]
      ,[KbPrefix]
      ,[CurrentKbNumber]
      ,[CasePrefix]
      ,[CurrentCaseNumber]
      ,[ContractPrefix]
      ,[CurrentContractNumber]
      ,[QuotePrefix]
      ,[CurrentQuoteNumber]
      ,[OrderPrefix]
      ,[CurrentOrderNumber]
      ,[InvoicePrefix]
      ,[CurrentInvoiceNumber]
      ,[UniqueSpecifierLength]
      ,[CreatedOn]
      ,[ModifiedOn]
      ,[FiscalYearFormat]
      ,[FiscalPeriodFormat]
      ,[FiscalYearPeriodConnect]
      ,[LanguageCode]
      ,[SortId]
      ,[DateFormatString]
      ,[TimeFormatString]
      ,[PricingDecimalPrecision]
      ,[ShowWeekNumber]
      ,[NextTrackingNumber]
      ,[TagMaxAggressiveCycles]
      ,[TokenKey]
      ,[SystemUserId]
      ,[CreatedBy]
      ,[GrantAccessToNetworkService]
      ,[AllowOutlookScheduledSyncs]
      ,[AllowMarketingEmailExecution]
      ,[SqlAccessGroupId]
      ,[CurrencyFormatCode]
      ,[FiscalSettingsUpdated]
      ,[ReportingGroupId]
      ,[TokenExpiry]
      ,[ShareToPreviousOwnerOnAssign]
      ,[AcknowledgementTemplateId]
      ,[ModifiedBy]
      ,[IntegrationUserId]
      ,[TrackingTokenIdBase]
      ,[BusinessClosureCalendarId]
      ,[AllowAutoUnsubscribeAcknowledgement]
      ,[AllowAutoUnsubscribe]
      ,[Picture]
      --,[VersionNumber]
      ,[TrackingPrefix]
      ,[MinOutlookSyncInterval]
      ,[BulkOperationPrefix]
      ,[AllowAutoResponseCreation]
      ,[MaximumTrackingNumber]
      ,[CampaignPrefix]
      ,[SqlAccessGroupName]
      ,[CurrentCampaignNumber]
      ,[FiscalYearDisplayCode]
      ,[SiteMapXml]
      ,[IsRegistered]
      ,[ReportingGroupName]
      ,[CurrentBulkOperationNumber]
      ,[SchemaNamePrefix]
      ,[IgnoreInternalEmail]
      ,[TagPollingPeriod]
      ,[TrackingTokenIdDigits]
      ,[NumberGroupFormat]
      ,[LongDateFormatCode]
      ,[UTCConversionTimeZoneCode]
      ,[TimeZoneRuleVersionNumber]
      ,[CurrentImportSequenceNumber]
      ,[ParsedTablePrefix]
      ,[V3CalloutConfigHash]
      ,[IsFiscalPeriodMonthBased]
      ,[LocaleId]
      ,[ParsedTableColumnPrefix]
      ,[SupportUserId]
      ,[AMDesignator]
      ,[CurrencyDisplayOption]
      ,[MinAddressBookSyncInterval]
      ,[IsDuplicateDetectionEnabledForOnlineCreateUpdate]
      ,[FeatureSet]
      ,[BlockedAttachments]
      ,[IsDuplicateDetectionEnabledForOfflineSync]
      ,[AllowOfflineScheduledSyncs]
      ,[AllowUnresolvedPartiesOnEmailSend]
      ,[TimeSeparator]
      ,[CurrentParsedTableNumber]
      ,[MinOfflineSyncInterval]
      ,[AllowWebExcelExport]
      ,[ReferenceSiteMapXml]
      ,[IsDuplicateDetectionEnabledForImport]
      ,[CalendarType]
      ,[SQMEnabled]
      ,[NegativeCurrencyFormatCode]
      ,[AllowAddressBookSyncs]
      ,[ISVIntegrationCode]
      ,[DecimalSymbol]
      ,[MaxUploadFileSize]
      ,[IsAppMode]
      ,[EnablePricingOnCreate]
      ,[IsSOPIntegrationEnabled]
      ,[PMDesignator]
      ,[CurrencyDecimalPrecision]
      ,[MaxAppointmentDurationDays]
      ,[EmailSendPollingPeriod]
      ,[RenderSecureIFrameForEmail]
      ,[NumberSeparator]
      ,[PrivReportingGroupId]
      ,[BaseCurrencyId]
      ,[MaxRecordsForExportToExcel]
      ,[PrivReportingGroupName]
      ,[YearStartWeekCode]
      ,[IsPresenceEnabled]
      ,[IsDuplicateDetectionEnabled]
      ,[RecurrenceExpansionJobBatchInterval]
      ,[DefaultRecurrenceEndRangeType]
      ,[HashMinAddressCount]
      ,[RequireApprovalForUserEmail]
      ,[RecurrenceDefaultNumberOfOccurrences]
      ,[ModifiedOnBehalfBy]
      ,[RequireApprovalForQueueEmail]
      ,[AllowEntityOnlyAudit]
      ,[IsAuditEnabled]
      ,[RecurrenceExpansionSynchCreateMax]
      ,[GoalRollupExpiryTime]
      ,[BaseCurrencyPrecision]
      ,[FiscalPeriodFormatPeriod]
      ,[AllowClientMessageBarAd]
      ,[InitialVersion]
      ,[HashFilterKeywords]
      ,[NextCustomObjectTypeCode]
      ,[ExpireSubscriptionsInDays]
      ,[OrgDbOrgSettings]
      ,[PastExpansionWindow]
      ,[EnableSmartMatching]
      ,[MaxRecordsForLookupFilters]
      ,[BaseCurrencySymbol]
      ,[ReportScriptErrors]
      ,[RecurrenceExpansionJobBatchSize]
      ,[FutureExpansionWindow]
      ,[GetStartedPaneContentEnabled]
      ,[SampleDataImportId]
      ,[BaseISOCurrencyCode]
      ,[GoalRollupFrequency]
      ,[CreatedOnBehalfBy]
      ,[HashDeltaSubjectCount]
      ,[HashMaxCount]
      ,[FiscalYearFormatYear]
      ,[FiscalYearFormatPrefix]
      ,[PinpointLanguageCode]
      ,[FiscalYearFormatSuffix]
      ,[IsUserAccessAuditEnabled]
      ,[UserAccessAuditingInterval]
      ,[AllowUserFormModePreference]
      ,[QuickFindRecordLimitEnabled]
      ,[UseReadForm]
      ,[YammerGroupId]
      ,[IsDefaultCountryCodeCheckEnabled]
      ,[MetadataSyncLastTimeOfNeverExpiredDeletedObjects]
      ,[YammerOAuthAccessTokenExpired]
      ,[UseSkypeProtocol]
      ,[DefaultCountryCode]
      ,[MetadataSyncTimestamp]
      ,[YammerNetworkPermalink]
      ,[YammerPostMethod]
      ,[EnableBingMapsIntegration]
   FROM 
   [dbo].[OrganizationBase] 
   WHERE 
   OrganizationId = @OldOrganizationId
   
  -- Loop through the Found Columns and Update them with the new OrganizationId
  WHILE @ColumnIterator <= @ColumnTotal
   BEGIN
    DECLARE @CurrentTable nvarchar(max)
    DECLARE @CurrentColumn nvarchar(max)
    
    SET @CurrentTable = (SELECT TableName FROM @FoundOrganizationIds WHERE Id = @ColumnIterator)
    SET @CurrentColumn = (SELECT ColumnName FROM @FoundOrganizationIds WHERE Id = @ColumnIterator)
    
    --PRINT (@CurrentTable)
    --PRINT (@CurrentColumn)
    
    -- Skip the OrganizationBase table now, since we have allready added the new OrganizationId 
    IF @CurrentTable <> 'OrganizationBase'
     BEGIN
      DECLARE @UpdateScript nvarchar(max)
      SET @UpdateScript = ' UPDATE ' + @CurrentTable + ' SET ' + @CurrentColumn + ' = ' + CHAR(39) + CAST(@NewOrganizationId as varchar(50)) + CHAR(39) + ' WHERE ' + @CurrentColumn + ' = ' + CHAR(39) + CAST(@OldOrganizationId as varchar(50))+ CHAR(39)
      -- PRINT (@UpdateScript)
      EXEC (@UpdateScript)
     END 
    SET @ColumnIterator = @ColumnIterator + 1
   END
  
  -- Delete the Old Organization from the OrganizationBase
  DELETE FROM OrganizationBase WHERE OrganizationId = @OldOrganizationId
