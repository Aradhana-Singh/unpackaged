public class KimbleOneSetting
{
	public static void EnableTriggers()
	{
		KimbleOneSetting__c setting = KimbleOneSetting__c.getOrgDefaults();
		if (setting == null) setting = new  KimbleOneSetting__c();
		setting.TriggersDisabled__c = false;
		upsert setting;
	}
	public static void DisableTriggers()
	{
		KimbleOneSetting__c setting = KimbleOneSetting__c.getOrgDefaults();
		if (setting == null) setting = new  KimbleOneSetting__c();
		setting.TriggersDisabled__c = true;
		upsert setting;
	}
	public static boolean TriggersEnabled
	{
		get
		{
			//If you change this message you will also need to change Handle.IsRetryJob so that jobs running during upgrade are not run.
			if (KimbleIsUpgrading && !IsUpdateProcess) throw new ApplicationException('System is undergoing maintenance. Please contact Kimble Support.');
			if (isInternalUpdate) return false;
			KimbleOneSetting__c setting = KimbleOneSetting__c.getInstance();
			return (setting.TriggersDisabled__c == false);
		}
	}
	public static boolean IsMasterOrg
	{
		get
		{
			KimbleOneSetting__c setting = KimbleOneSetting__c.getInstance();
			return (setting.IsMasterOrganisation__c == true);
		}
	}
	public static boolean IsUpdateProcess = false;
	private static boolean isInternalUpdate = false;
	public static void InternalUpdate(boolean onOff)
	{
		isInternalUpdate = onOff;
	}
	public static boolean CRMIntegrationEnabled
	{
		get
		{
			KimbleOneSetting__c setting = KimbleOneSetting__c.getInstance();
			return setting.CRMIntegrationEnabled__c;
		}
	}
	public static string CRMIntegrationMode
	{
		get
		{
			KimbleOneConfigSetting__c setting = KimbleOneConfigSetting__c.getInstance();
			return setting.CRMIntegrationMode__c;
		}
	}
	public static boolean KimbleCoachEnabled
	{
		get
		{
			KimbleOneSetting__c setting = KimbleOneSetting__c.getInstance();
			return setting.KimbleCoachEnabled__c;
		}
	}
	public static list<string> NoUserResourceClasses
	{
		get
		{
			KimbleOneSetting__c setting = KimbleOneSetting__c.getInstance();
			return (setting.NoUserResourceClasses__c != null ? setting.NoUserResourceClasses__c.split(',') : new list<string>());
		}
	}
	public static void EnableMaintenanceMode()
	{
		System.debug('Current User: ' + UserInfo.getUserName());
		KimbleOneSetting__c setting = KimbleOneSetting__c.getOrgDefaults();
		if (setting == null) setting = new  KimbleOneSetting__c();
		setting.MaintenanceEnabled__c = true;
		upsert setting;
	}
	public static void DisableMaintenanceMode()
	{
		KimbleOneSetting__c setting = KimbleOneSetting__c.getOrgDefaults();
		if (setting == null) setting = new  KimbleOneSetting__c();
		setting.MaintenanceEnabled__c = false;
		upsert setting;
	}
	public static string CapabilityHierarchyDelimiter
	{
		get
		{
			KimbleOneConfigSetting__c setting = KimbleOneConfigSetting__c.getInstance();
			if (setting == null || setting.CapabilityHierarchyDelimiter__c == null) return ':';
			return setting.CapabilityHierarchyDelimiter__c;
		}
	}
	public static string EmailTemplateLogoURL
	{
		get
		{
			KimbleOneConfigSetting__c setting = KimbleOneConfigSetting__c.getInstance();
			if (setting == null || setting.EmailTemplateLogoURL__c == null) return 'https://www.kimbleapps.com/site/wp-content/uploads/KimbleTemplateLogo.png';
			return setting.EmailTemplateLogoURL__c;
		}
	}
	public static integer EndingSoonTolerance
	{
		get
		{
			KimbleOneConfigSetting__c setting = KimbleOneConfigSetting__c.getInstance();
			if (setting == null || setting.EndingSoonTolerance__c == null) return 14;
			return integer.valueof(setting.EndingSoonTolerance__c);
		}
	}
	public static integer LowRemainingUsageTolerance
	{
		get
		{
			KimbleOneConfigSetting__c setting = KimbleOneConfigSetting__c.getInstance();
			if (setting == null || setting.LowRemainingUsageTolerance__c == null) return 10;
			return integer.valueof(setting.LowRemainingUsageTolerance__c);
		}
	}
	public static integer LowUsageDaysTolerance
	{
		get
		{
			KimbleOneConfigSetting__c setting = KimbleOneConfigSetting__c.getInstance();
			if (setting == null || setting.LowUsageDaysTolerance__c == null) return 30;
			return integer.valueof(setting.LowUsageDaysTolerance__c);
		}
	}
	public static boolean MaintenanceEnabled
	{
		get
		{
			if(Test.isRunningTest()) return true;
			KimbleOneSetting__c setting = KimbleOneSetting__c.getInstance();
			return setting.MaintenanceEnabled__c;
		}
	}
	/* KimbleConfig__c Custom Setting List values */
	public static boolean EngagementSummaryEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementSummary, true);}}
	public static boolean EngagementRevenueSummaryEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementRevenueSummary, true);}}
	public static boolean EngagementMarginSummaryEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementMarginSummary, true);}}
	public static boolean EngagementRealisationRateSummaryEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EngagementRealisationRateSummaryEnabled, false);}}
	public static boolean EngagementFinancialSummaryEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementFinancialSummary, true);}}
	public static boolean EngagementCreditSummaryEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableCreditSummary, true);}}
	public static boolean EngagementEarnedValueSummaryEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementEarnedValueSummary, false);}}
	public static boolean RiskManagementEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableRiskManagement, true);}}
	public static boolean RAIDChatterEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableRAIDChatter, false);}}
	public static boolean IssueManagementEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableIssueManagement, true);}}
	public static boolean EngagementCostSummaryEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementCostSummary, true);}}
	public static boolean EngagementPlanPerformanceEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementPlanPeformanceSummary, true);}}
	public static boolean EngagementPlanMilestonesEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementPlanMilestonesSummary, true);}}
	public static boolean EngagementMilestonesEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementMilestonesSummary, true);}}
	public static boolean EngagementFieldsetSummaryEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementFieldsetSummary, true);}}
	public static boolean EngagementPrintEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEngagementPrint, true);}}
	public static boolean SilentJobsModeEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.SilentJobsModeEnabled, false);}}
	public static boolean SuperBatchModeEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.SuperBatchModeEnabled, false);}}
	public static integer JobBatchLimit { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.JobBatchLimit, integer.valueOf(label.JobBatchLimit));}}
	public static integer UserRecordAccessCheckLimit { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.UserRecordAccessCheckLimit, 200);}}
	public static boolean EnableResourceGroupChildAssignments { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableResourceGroupChildAssignments, false);}}
	public static integer TimesheetAssignmentLimit { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.TimesheetAssignmentLimit, 50);}}
	public static boolean TimesheetPerAssignment {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TimesheetPerAssignment, false);}}
	public static integer TimesheetGridDefaultAssignmentsAge { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.TimesheetGridDefaultAssignmentsAge, 0);}}
	public static boolean ValidateTimeEntryCatsAndTaskOnSave { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ValidateTimeEntryCatsAndTaskOnSave, false);}}
	public static integer ApprovalMaximumNumberOfItems { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ApprovalMaximumNumberOfItems, 1000);}}
	public static boolean ReRouteApprovalRequestsEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ReRouteApprovalRequestsEnabled, true);}}
	public static boolean InPageApproveRejectEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.InPageApproveRejectEnabled, false);}}
	public static boolean RejectCommentsMandatory { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.RejectCommentsMandatory, false);}}
	public static integer AllApprovalsMaximumNumberOfItems { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.AllApprovalsMaximumNumberOfItems, 0);}}
	public static integer AllApprovalsMaximumNumberOfItemsBatch { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.AllApprovalsMaximumNumberOfItemsBatch, 0);}}
	public static boolean ResourceExperienceApprovalEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableResourceExperienceApproval, true);}}
	public static boolean ResourceCapabilityApprovalEnabled {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ResourceCapabilityApprovalEnabled, false);}}
	public static integer ShareActionPageSize { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ShareActionPageSize, 20);}}
	public static integer ShareActionScopeObjectsPageSize { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ShareActionScopeObjectsPageSize, 500);}}
	public static integer MaximumCapabilityRating { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.MaximumCapabilityRating, 5);}} // TODO 1.32 MS - Obsolete remove once 1.31 upgrades complete
	public static integer DefaultCapabilityRating { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.DefaultCapabilityRating, 1);}}
	public static integer CapabilityExpiryWarningMonths { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.CapabilityExpiryWarningMonths, 6);}}
	public static integer CapabilityExpiryToleranceDays { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.CapabilityExpiryToleranceDays, 30);}}
	public static boolean WhatIfIncludeZeroDifference { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.WhatIfIncludeZeroDifference, false);}}
	public static string WhatIfMinMaxTolerance { get {return getStringKimbleConfigValue(KimbleConfigEnum.WhatIfMinMaxTolerance, '0');}}
	public static boolean ProductExtensionEnhancedLookupEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ProductExtensionEnhancedLookupEnabled, true);}}
	public static string TimesheetCalendarDayNameFormat { get {return getStringKimbleConfigValue(KimbleConfigEnum.TimesheetCalendarDayNameFormat, null);}}
	public static string TimesheetGridDayNameFormat { get {return getStringKimbleConfigValue(KimbleConfigEnum.TimesheetGridDayNameFormat, 'D dd');}}
	public static string ConfigCatalogCanvasAppName { get {return getStringKimbleConfigValue(KimbleConfigEnum.ConfigCatalogCanvasAppName, 'KimbleConfigCatalog');}}
	public static string ConfigCatalogEnvironment { get {return getStringKimbleConfigValue(KimbleConfigEnum.ConfigCatalogEnvironment, 'PROD');}}
	public static string HelpPageURL { get {return getStringKimbleConfigValue(KimbleConfigEnum.HelpPageURL, '');}}
	public static boolean EnableAssignmentDemandResourceFilter { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAssignmentDemandResourceFilter, false);}}
	public static boolean ActivityLocationEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ActivityLocationEnabled, false);}}
	public static string DefaultDeliveryGroupStatusPeriod { get {return getStringKimbleConfigValue(KimbleConfigEnum.DefaultDeliveryGroupStatusPeriod, TimesheetDefaultTrackingPeriodEnum.FirstOpenPeriod);}}
	public static boolean KimbleIsUpgrading { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.KimbleIsUpgrading, false);}}
	public static integer MaxGrpAssigmentTemplateDurationMonths { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.MaxGrpAssigmentTemplateDurationMonths, 12);}}
	public static boolean ShowForecastTimeInGridView  { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowForecastTimeInGridView, false);}}
	public static boolean ShowForecastTimeInEnhancedGridView  { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowForecastTimeInEnhancedGridView , true);}}
	public static boolean FTETimeZoneEnabled  { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.FTETimeZoneEnabled, false);}}
	public static boolean TimeAdjustmentsEnabled  { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TimeAdjustmentsEnabled, true);}}
	public static boolean CascadeProposalDateToHighLevelGroups { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.CascadeProposalDateToHighLevelGroups, false);}}
	public static string OperationManagementUnitType {get {return getStringKimbleConfigValue(KimbleConfigEnum.OperationManagementUnitType, 'Day');}}
	public static string OperationManagementPeriodType {get {return getStringKimbleConfigValue(KimbleConfigEnum.OperationManagementPeriodType, 'PeriodModeTracking');}}
	public static boolean AllowElementsGroupedForInvoicing {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.AllowElementsGroupedForInvoicing, false);}}
	public static boolean TravelRequisitionWithItinerary {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TravelRequisitionWithItinerary, true);}}
	public static integer MaxNumberOfInvoiceItems {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.MaxNumberOfInvoiceItems, 400);}}
	public static boolean PreValidateTimesheetsPendingApproval { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.PreValidateTimesheetsPendingApproval, false);}}
	public static boolean ShowCurrentRemainingUsageInTimeEntry { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowCurrentRemainingUsageInTimeEntry, false);}}
	public static boolean GenerateDeliveryGroupReferenceBeforeSave {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.GenerateDeliveryGroupReferenceBeforeSave, false);}}
	public static boolean EnableAutomaticContactCreation {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAutomaticContactCreation, true);}}
	public static boolean ShowPortfolioRiskSummary {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowPortfolioRiskSummary, false);}}
	public static boolean ShowProgramRiskSummary {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowProgramRiskSummary, false);}}
	public static boolean EnablePreSalesAssignmentTemplates {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnablePreSalesAssignmentTemplates, false);}}
	public static boolean EnableBaselineOverride {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableBaselineOverride, false);}}
	public static boolean EnableBaselineTypeAndDescription {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableBaselineTypeAndDescription, false);}}
	public static boolean EnableBaselineProfile {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableBaselineProfile, false);}}
	public static boolean EnableDiscount {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableDiscount, false);}}
	public static integer ActivityResourcesToFetchLimit {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.ActivityResourcesToFetchLimit, 100);}}
	public static integer MarginSummaryCardDecimalPlaces {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.MarginSummaryCardDecimalPlaces, 0);}}
	public static integer FinancialSummaryMarginDecimalPlaces {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.FinancialSummaryMarginDecimalPlaces, 0);}}
	public static integer UnresourcedAssignmentWarningMonths {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.UnresourcedAssignmentWarningMonths, 120);}}
	public static string CandidateAssignmentHandling {get{return getStringKimbleConfigValue(KimbleConfigEnum.CandidateAssignmentHandling, 'DISABLED');}}
	public static boolean CandidateAssignmentHandlingNotification {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.CandidateAssignmentHandlingNotification, false);}}
	public static boolean EnforceObjectTransferInEndTenureWizard {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnforceObjectTransferInEndTenureWizard, true);}}
	public static boolean EnableEducationalHistoryTracking {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEducationalHistoryTracking, true);}}
	public static boolean ShowActivityGroupingInBulkAssgnmnts {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowActivityGroupingInBulkAssgnmnts, false);}}
	public static boolean EnableResourceQuickSearch {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableResourceQuickSearch, false);}}
	public static boolean EnableReportRepo {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableReportRepo, false);}}
	public static boolean IncludeDiscountInRevenue {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.IncludeDiscountInRevenue, false);}}
	public static boolean IncludeDiscountInInvoice {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.IncludeDiscountInInvoice, false);}}
	public static boolean AllowFixedEffortTasksToExceedEffort {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.AllowFixedEffortTasksToExceedEffort, true);}}
	public static boolean SyncTPIAssignmentRates {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.SyncTPIAssignmentRates, false);}}
	public static boolean EnableExpenseCategoryProfileByPeriod {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableExpenseCategoryProfileByPeriod, false);}}
	public static boolean EnableOpportunityWinWithNoProposalItems {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableOpportunityWinWithNoProposalItems, true);}}
	public static boolean EnableManageProposalOnOpportunity {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableManageProposalOnOpportunity, false);}}
	public static boolean DefaultTaskAssignmentImportToTaskLed {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.DefaultTaskAssignmentImportToTaskLed, false);}}
	public static boolean EnableExpenseForecasting {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableExpenseForecasting, true);}}
	public static integer TimeCatUpdateFromTemplateBatchSize {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.TimeCatUpdateFromTemplateBatchSize, 50);}}
	/* Trend Analysis */
	public static boolean TrendAnalysisEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TrendAnalysisEnabled, false);}}
	public static string TrendAnalysisDefaultProbability { get {return getStringKimbleConfigValue(KimbleConfigEnum.TrendAnalysisDefaultProbability, 'P1');}}
	public static string TrendAnalysisDefaultDimension { get {return getStringKimbleConfigValue(KimbleConfigEnum.TrendAnalysisDefaultDimension, getTrendAnalysisDefaultDimensionId());}}
	public static integer TrendAnalysisHistoryNumOfPreviousPeriods { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.TrendAnalysisHistPrevPeriodsNum, 6);}}
	public static integer TrendAnalysisHistoryNumOfFuturePeriods { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.TrendAnalysisHistFuturePeriodsNum, 6);}}
	public static string TrendAnalysisStartOffsetYrsType { get {return getStringKimbleConfigValue(KimbleConfigEnum.TrendAnalysisStartOffsetYrsType, 'FUP');}}
	public static integer TrendAnalysisStartOffsetYrsNum { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.TrendAnalysisStartOffsetYrsNum, 0);}}
	public static string TrendAnalysisEndOffsetYrsType { get {return getStringKimbleConfigValue(KimbleConfigEnum.TrendAnalysisEndOffsetYrsType, 'TODAY');}}
	public static integer TrendAnalysisEndOffsetYrsNum { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.TrendAnalysisEndOffsetYrsNum, 2);}}
	/* Forecast Accuracy and Confidence */
	public static boolean ForecastAnalysisEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ForecastAnalysisEnabled, false);}}
	public static integer ForecastAnalysisHistPeriodsNum { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ForecastAnalysisHistPeriodsNum, 6);}}
	public static integer ForecastAnalysisFuturePeriodsNum { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ForecastAnalysisFuturePeriodsNum, 3);}}
	public static integer ForecastAnalysisAvgTolerance { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ForecastAnalysisAvgTolerance, 20);}}
	public static string ForecastAnalysisDefProbability { get {return getStringKimbleConfigValue(KimbleConfigEnum.ForecastAnalysisDefProbability, 'ALLP');}}
	public static string ForecastAnalysisDefBU { get {return getStringKimbleConfigValue(KimbleConfigEnum.ForecastAnalysisDefBU, 'RES_BU');}}
	public static string ForecastAnalysisDefFact { get {return getStringKimbleConfigValue(KimbleConfigEnum.ForecastAnalysisDefFact, 'Revenue');}}
	public static integer AverageBusinessDaysPerMonth {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.AverageBusinessDaysPerMonth, 21);}}
	public static boolean TargetMarginEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TargetMarginEnabled, true);}}
	public static boolean ExpectedUsageEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ExpectedUsageEnabled, true);}}
	public static boolean DerivedRevenueEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.DerivedRevenueEnabled, false);}}
	public static boolean UsageMarginDerivedRevenueEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.UsageMarginDerivedRevenueEnabled, false);}}
	public static boolean UsageRealisationRateDerivedRvnueEnbld { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.UsageRealisationRateDerivedRvnueEnbld, false);}}
	public static boolean UsageItemEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.UsageItemEnabled, true);}}
	public static string CustCommDefaultApplicationRole { get {return getStringKimbleConfigValue(KimbleConfigEnum.CustCommDefaultApplicationRole, 'Community User');}}
	public static string CustCommDefaultProfile { get {return getStringKimbleConfigValue(KimbleConfigEnum.CustCommDefaultProfile, 'Kimble Customer Community Plus User');}}
	public static string CustCommDefaultUsernamePattern { get {return getStringKimbleConfigValue(KimbleConfigEnum.CustCommDefaultUsernamePattern, '{0}.{1}@'+ UserInfo.getUserEmail().split('@').get(1));}}
	public static string CustCommEngagementShareReason { get {return getStringKimbleConfigValue(KimbleConfigEnum.CustCommEngagementShareReason, 'Customer Delivery Group Share Read');}}
	public static boolean CustCommHideTimesheetRevenue {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.CustCommHideTimesheetRevenue, false);}}
	public static boolean ResourceAggregateGeoLocationEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ResourceAggregateGeoLocationEnabled, false);}}
	public static string ResourceAggregateGanttOverlayField { get {return getStringKimbleConfigValue(KimbleConfigEnum.ResourceAggregateGanttOverlayField, Schema.SObjectType.ActivityAssignment__c.Fields.ResourcedActivity__c.getRelationshipName() + '.' +  Schema.SObjectType.ResourcedActivity__c.Fields.DeliveryGroup__c.getRelationshipName() + '.' +  Schema.SObjectType.DeliveryGroup__c.Fields.Account__c.getRelationshipName() + '.' +  Schema.SObjectType.Account.Fields.Code__c.Name);}}
	public static string ResourceAggregateUnitType {get {return getStringKimbleConfigValue(KimbleConfigEnum.ResourceAggregateUnitType,'Hours');}}
	public static boolean AssignmentCodeEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.AssignmentCodeEnabled, false);}}
	public static string GoogleMapsApiKey { get {return getStringKimbleConfigValue(KimbleConfigEnum.GoogleMapsApiKey, 'AIzaSyBXM7qTR0pLK_VevDinwZIOkxdn1dbaqqc');}}
	public static boolean LocationTrackingEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.LocationTrackingEnabled, false);}}
	public static boolean TimeAndExpenseMobilePermissionsEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TimeAndExpenseMobilePermissionsEnabled, false);}}
	public static boolean TimesheetMobileWebEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TimesheetMobileWebEnabled, false);}}
	public static boolean ExpenseClaimMobileWebEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ExpenseClaimMobileWebEnabled, false);}}
	public static boolean MobileReceiptsOnClaimEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.MobileReceiptsOnClaimEnabled, true);}}
	public static boolean MobileCopyItemsForPreviousClaimEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.MobileCopyItemsForPreviousClaimEnabled, true);}}
	public static boolean MobileReceiptDetectionEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.MobileReceiptDetectionEnabled, true);}}
	public static string MobileDefaultView { get {return getStringKimbleConfigValue(KimbleConfigEnum.MobileDefaultView, 'Timesheet');}}
	public static boolean MobileUtilisationComponentEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.MobileUtilisationComponentEnabled, true);}}
	public static boolean MobileAssignmentSumComponentEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.MobileAssignmentSumComponentEnabled, true);}}
	public static boolean MobileTimeReminderNotificationEnabled{ get {return getBooleanKimbleConfigValue( KimbleConfigEnum.MobileTimeReminderNotificationEnabled, false);}}
	public static boolean MobileClaimPaidNotificationEnabled{ get {return getBooleanKimbleConfigValue( KimbleConfigEnum.MobileClaimPaidNotificationEnabled, false);}}
	public static boolean MobileCopyPreviousPeriodTimeEnabled{ get {return getBooleanKimbleConfigValue( KimbleConfigEnum.MobileCopyPreviousPeriodTimeEnabled, false);}}
	public static boolean TOILEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TOILEnabled, false);}}
	public static boolean RestBreaksEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.RestBreaksEnabled, false);}}
	public static string TriggerLogger { get {return getStringKimbleConfigValue(KimbleConfigEnum.TriggerLogger, '');}}
	public static string UserLogger {get {return getStringKimbleConfigValue(KimbleConfigEnum.UserLogger, '');}}
	public static string UserLoggerContext {get {return getStringKimbleConfigValue(KimbleConfigEnum.UserLoggerContext, '');}}
	public static boolean EventClassLoggerEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EventClassLoggerEnabled, false);}}
	public static boolean NotesAndAttachmentsRelatedListEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.NotesAndAttachmentsRelatedListEnabled, true);}}
	public static boolean FilesRelatedListEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.FilesRelatedListEnabled, false);}}
	public static boolean LightningRelatedListsEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.LightningRelatedListsEnabled, false);}}
	public static string CurrentDate { get {return getStringKimbleConfigValue(KimbleConfigEnum.CurrentDate, '');}}
	public static string CurrentJobProfileName { get {return getStringKimbleConfigValue(KimbleConfigEnum.CurrentJobProfileName, '');}}
	public static boolean GDPREnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.GDPREnabled, false);}}
	public static boolean EnableIR35Assessment { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableIR35Assessment, false);}}
	public static string UpgradeEmailAddress { get {return getStringKimbleConfigValue(KimbleConfigEnum.UpgradeEmailAddress, 'kimbleone.upgrade@kimbleapps.com');}}
	public static boolean EnableTrackingPlanUsageWarnings { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableTrackingPlanUsageWarnings, false);}}
	public static string EventClassEvaluationContext {get {return getStringKimbleConfigValue(KimbleConfigEnum.EventClassEvaluationContext, '');}}
	public static boolean ConfirmProductChangeEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ConfirmProductChange, false);}}
	public static boolean EnablePartialCreditNotes { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnablePartialCreditNotes, false);}}
	public static boolean EnablePartialSupplierCreditNotes { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnablePartialSupplierCreditNotes, false);}}
	public static boolean CanIncludeCreditNoteAdjustment { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.CanIncludeCreditNoteAdjustment, false);}}
	public static boolean UseExpenseIncurredToReimbCcyExRate { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.UseExpenseIncurredToReimbCcyExRate, false);}}
	public static boolean TaxCodeApplicabilitiesEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TaxCodeApplicabilitiesEnabled, false);}}
	public static boolean ShowDeliveryGroupFinSummaryTotals { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowDeliveryGroupFinSummaryTotals, false);}}
	public static boolean ShowDeliveryGroupParentElementTotals { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowDeliveryGroupParentElementTotals, false);}}
	public static boolean ShowDeliveryPortfolioSummaryTotals { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowDeliveryPortfolioSummaryTotals, false);}}
	public static boolean ShowDeliveryProgSummaryTotals { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowDeliveryProgSummaryTotals, false);}}
	public static boolean ShowExpensesOnDeliveryPortfolio { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowExpensesOnDeliveryPortfolio, false);}}
	public static boolean ShowExpensesOnDeliveryProgramme { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowExpensesOnDeliveryProgramme, false);}}
	public static boolean AllowAssignmentToMilestoneLink { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.AllowAssignmentToMilestoneLink, false);}}
	public static string ConcatenateRollupSeparator { get {return getStringKimbleConfigValue(KimbleConfigEnum.ConcatenateRollupSeparator, ',');}}
	public static boolean EnableOwnersWorkItems { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableOwnersWorkItems, false);}}
	public static boolean DefaultOwnerToCurrentUser { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.DefaultOwnerToCurrentUser, false);}}
	public static boolean EnableSettingPlanTaskRemainingEffort {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableSettingPlanTaskRemainingEffort, false);}}
	public static boolean EnableBUCalendarForNewTrackedPlan {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableBUCalendarForNewTrackedPlan, false);}}
	public static boolean DeliveryStartOffsetPanelEnabled {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.DeliveryStartOffsetPanelEnabled, false);}}
	public static boolean EnableDragDropOnAssignmentDemand {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableDragDropOnAssignmentDemand, false);}}
	public static boolean EnableSnipOnAssignmentDemand {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableSnipOnAssignmentDemand, false);}}
	public static boolean EnableAvailabilityScoring {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAvailabilityScoring, false);}}
	public static integer MinimumAvailabilityScore {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.MinimumAvailabilityScore, 10);}}
	public static boolean LaunchReportsInNewTab {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.LaunchReportsInNewTab, false);}}
	public static string AssignmentDeletionCriteria { get {return getStringKimbleConfigValue(KimbleConfigEnum.AssignmentDeletionCriteria, '');}}
	public static string ResourceAggregateMinUsage { get {return getStringKimbleConfigValue(KimbleConfigEnum.ResourceAggregateMinUsage, '0.15');}}
	public static boolean EnableCustomInvoiceTimeAndExpDownloads{get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableCustomInvoiceTimeAndExpDownloads, false);}}
	public static boolean EnableIntegratedCandidateResources { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableIntegratedCandidateResources, false);}}
	public static boolean HideTimesheetRevenueInApproval { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.HideTimesheetRevenueInApproval, false);}}
	public static boolean ShowTimesheetSummaryOnApprovalEmail { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowTimesheetSummaryOnApprovalEmail, false);}}
	public static boolean ImportRejectedTimesheets { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ImportRejectedTimesheets, false);}}
	public static boolean EnableExpenseReimbursementAmountEntry { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableExpenseReimbursementAmountEntry, false);}}
	public static boolean EnableExpenseItemTemplates { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableExpenseItemTemplates, false);}}
	public static boolean EnableRetrospectiveActualRevenue { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableRetrospectiveActualRevenue, false);}}
	public static boolean EnableCumulativePerformanceAnalysis { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableCumulativePerformanceAnalysis, false);}}
	public static boolean EnableAdjustedUsageAnalysis { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAdjustedUsageAnalysis, false);}}
	public static boolean AllowEditElementStatus { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.AllowEditElementStatus, false);}}
	public static boolean UseInLineStylingForEmailTemplates { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.UseInLineStylingForEmailTemplates, false);}}
	public static boolean EnableOverrideOfHeaderAndRowStyles { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableOverrideOfHeaderAndRowStyles, false);}}
	public static boolean EngagementStageSummaryEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EngagementStageSummaryEnabled, false);}}
	public static boolean TargetedStageNavigationEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TargetedStageNavigationEnabled, false);}}
	public static string DefaultPlanningMilestoneVisibilityLevel { get {return getStringKimbleConfigValue(KimbleConfigEnum.DefaultPlanningMilestoneVisibilityLevel, PlanningMilestoneVisibilityLevelEnum.TrackingPlan);}}
	public static string DefaultTaskVisibilityLevel { get {return getStringKimbleConfigValue(KimbleConfigEnum.DefaultTaskVisibilityLevel, TaskVisibilityLevelEnum.TrackingPlan);}}
	public static string PrevPeriodIncompleteTimeHandlingMode { get {return getStringKimbleConfigValue(KimbleConfigEnum.PrevPeriodIncompleteTimeMode, '');}}
	public static boolean PreventCostAndRevenueRateChangeOnApprovedTime { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.PreventCostAndRevenueRateChangeOnApprovedTime, false);}}
	public static boolean WarnForIncompleteTimeInPreviousTrackingPeriod { get {return PrevPeriodIncompleteTimeHandlingMode == 'WARN';}}
	public static boolean PreventSubmissionWhenIncompleteTimeInPreviousTrackingPeriod { get {return PrevPeriodIncompleteTimeHandlingMode == 'PREVENT';}}
	public static string TrackingPeriodLength { get {return getStringKimbleConfigValue(KimbleConfigEnum.TrackingPeriodLength, 'Weekly');}}
	public static boolean MonthlyTrackingEnabled { get {return KimbleOneSetting.TrackingPeriodLength != 'Weekly';}}
	public static string ForecastingPeriodLength { get {return getStringKimbleConfigValue(KimbleConfigEnum.ForecastingPeriodLength, 'Monthly');}}
	public static boolean FourFiveWeeklyForecastingEnabled { get {return KimbleOneSetting.ForecastingPeriodLength != 'Monthly' || (KimbleOneSetting.CustomCalendarType != 'Gregorian' && KimbleOneSetting.CustomCalendarType != 'GregorianWithBreak');}}
	public static boolean EnableEnhancedTimesheet { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEnhancedTimesheet, false);}}
	public static string OtherActivitiesSortPreference {get {return getStringKimbleConfigValue(KimbleCOnfigEnum.OtherActivitiesSortPreference,'BOTTOM');}}
	public static boolean EnableTimeEntryTimers { get {return EnableEnhancedTimesheet && getBooleanKimbleConfigValue(KimbleConfigEnum.EnableTimeEntryTimers, false);}}
	public static boolean PdfToImageConversionEnabled {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.PdfToImageConversionEnabled, true);}}
	public static integer PdfGenerationSettingsCanvasWidth {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.PdfGenerationSettingsCanvasWidth, 800);}}
	public static integer PdfGenerationSettingsCanvasHeight {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.PdfGenerationSettingsCanvasHeight, 1200);}}
	public static string PdfGenerationSettingsCompression {get {return getStringKimbleConfigValue(KimbleConfigEnum.PdfGenerationSettingsCompression, 'FAST');}}
	public static string PdfGenerationSettingsPdfContentType {get {return getStringKimbleConfigValue(KimbleConfigEnum.PdfGenerationSettingsPdfContentType, 'application/pdf');}}
	public static string PdfGenerationSettingsPageType {get {return getStringKimbleConfigValue(KimbleConfigEnum.PdfGenerationSettingsPageType, 'a4');}}
	public static string PdfGenerationSettingsImageQuality {get {return getStringKimbleConfigValue(KimbleConfigEnum.PdfGenerationSettingsImageQuality, '0.2');}}
	public static string PdfGenerationSettingsScale {get {return getStringKimbleConfigValue(KimbleConfigEnum.PdfGenerationSettingsScale, '1.5');}}
	public static integer MobileAttachmentMaxSize {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.MobileAttachmentMaxSize, 8388608);}}
	public static string GoogleGeocodeApiKey { get {return getStringKimbleConfigValue(KimbleConfigEnum.GoogleGeocodeApiKey, 'AIzaSyDFvdsfHUGHlgCIV_VVty5zuxg0Xo02470');}}
	public static boolean EnableEnhancedExpenseClaimEdit { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEnhancedExpenseClaimEdit, false);}}
	public static boolean EnableEnhancedExpenseClaimAutoSave { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEnhancedExpenseClaimAutoSave, EnableEnhancedExpenseClaimEdit);}}
	public static integer MenuFilterSearchThreshold {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.MenuFilterSearchThreshold, 50);}}
	public static integer TimePeriodCalendarThreshold {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.TimePeriodCalendarThreshold, 20);}}
	public static integer ResourceSearchMaxRecords {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ResourceSearchMaxRecords, 200);}}
	public static integer MaxItemsOnExpenseClaim { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.MaxItemsOnExpenseClaim, 0);}}
	public static string DefaultDeliveryGroupMilestoneSort { get {return getStringKimbleConfigValue(KimbleConfigEnum.DefaultDeliveryGroupMilestoneSort, 'Name Ascending');}}
	public static boolean AllowAnnualAnnuities {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.AllowAnnualAnnuities, false);}}
	public static boolean TimesheetGridCopyFromPreviousPeriodEnabled {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TimesheetGridCopyFromPrevPeriodEnabled, false);}}
	public static integer TimesheetCopyAssignmentDays {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.TimesheetCopyAssignmentDays, 6);}}
	public static boolean TimesheetShowAllDaysInCalendarWeek {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.TimesheetShowAllDaysInCalendarWeek, false);}}
	public static string SalesOpportunityNameFormat { get {return getStringKimbleConfigValue(KimbleConfigEnum.SalesOpportunityNameFormat, NameFormatEnum.ShortNameOnly);}}
	public static string DeliveryGroupNameFormat { get {return getStringKimbleConfigValue(KimbleConfigEnum.DeliveryGroupNameFormat, NameFormatEnum.ShortNameOnly);}}
	public static string DeliveryElementNameFormat { get {return getStringKimbleConfigValue(KimbleConfigEnum.DeliveryElementNameFormat, NameFormatEnum.ShortNameOnly);}}
	public static boolean EnableMultipleInvoiceContacts {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableMultipleInvoiceContacts, false);}}
	public static boolean EnableDeliveryGroupLevelInvoiceContacts {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableDeliveryGroupLevelInvContacts, false);}}
	public static boolean InvoiceTaxCalcOffSystem {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.InvoiceTaxCalcOffSystem, false);}}
	public static boolean AssignmentKeyFieldsFieldsetEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.AssignmentKeyFieldsFieldsetEnabled, false);}}
	public static boolean ShowAssignmentMarginInDelivery {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowAssignmentMarginInDelivery, false);}}
	public static boolean DisplayAssignmentMaxUsage {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.DisplayAssignmentMaxUsage, false);}}
	public static boolean ExpenseReceiptEnhancedViewer {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ExpenseReceiptEnhancedViewer, true);}}
	public static string SuggestedTimeMode { get {return getStringKimbleConfigValue(KimbleConfigEnum.SuggestedTimeMode, 'HIDE');}}
	public static boolean HideSuggestedTimeOnceActualExists { get {return SuggestedTimeMode == 'HIDE';}}
	public static boolean ReduceSuggestedTimeOnceActualExists { get {return SuggestedTimeMode == 'REDUCE';}}
	public static boolean PreserveSuggestedTimeOnceActualExists { get {return SuggestedTimeMode == 'PRESERVE';}}
	public static boolean ForecastUsageBatchRemovalEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ForecastUsageBatchRemovalEnabled, false);}}
	public static integer PeriodManagementSummaryBarDecimalPlaces {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.PeriodManagementSummaryBarDecimalPlaces, 0);}}
	public static boolean ResourcePeriodRejectionRevertsTimesheets {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ResourcePeriodRejectionRevertsTimesheets, false);}}
	public static boolean CloneElementEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.CloneElementEnabled, false);}}
	public static boolean SnipWithoutActualsEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.SnipWithoutActualsEnabled, false);}}
	public static boolean EnableApprovalsIfNotAssignedApprover {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableApprovalsIfNotAssignedApprover, false);}}
	public static boolean RevSumFilterEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.RevSumFilterEnabled, true);}}
	public static boolean CstSumFilterEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.CstSumFilterEnabled, true);}}
	public static boolean MarSumFilterEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.MarSumFilterEnabled, true);}}
	public static boolean IcSumFilterEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.IcSumFilterEnabled, true);}}
	public static string AutoGenBatchInvoiceDate {get {return getStringKimbleConfigValue(KimbleConfigEnum.AutoGenBatchInvoiceDate, 'TODAY');}}
	public static boolean CorpCcyCalculatedForAllPeriods {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.CorpCcyCalculatedForAllPeriods, false);}}
	public static boolean EnableInterCompanyAccounting {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableInterCompanyAccounting, false);}}
	public static boolean POSelectionEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.POSelectionEnabled, false);}}
	public static boolean GroupElementsInInvoicingWizard {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.GroupElementsInInvoicingWizard, false);}}
	public static string DeliveryGroupInvoiceBatchMode {get{return getstringKimbleConfigValue(KimbleConfigEnum.DeliveryGroupInvoiceBatchMode, 'DELIVERYGROUP');}}
	public static integer InvoiceableItemBatchSize {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.InvoiceableItemBatchSize, 1000);}}
	public static boolean CreateSupplierRequisitionPerTravelItem {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.CreateSupplierRequisitionPerTravelItem, true);}}
	public static boolean EnableDeliveryGroupUsagePctComplete {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableDeliveryGroupUsagePctComplete, false);}}
	public static boolean ShowSideNavBarOnTimesheetPage {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowSideNavBarOnTimesheetPage, false);}}
	public static boolean TimesheetTotalLessThanExpectedTotal {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.TimesheetTotalLessThanExpectedTotal, false);}}
	public static integer RelatedRiskAgeThresholdInMonths {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.RelatedRiskAgeThresholdInMonths, null);}}
	public static integer CloneElementEnhancedLookupThreshold {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.CloneElementEnhancedLookupThreshold, 3);}}
	public static boolean WorkingAtRiskApprovalEnabled {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.WorkingAtRiskApprovalEnabled, false);}}
	public static boolean IntercompanySummaryEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableIntercompanySummary, false);}}
	public static boolean EnableInGanttScheduling {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableInGanttScheduling, false);}}
	public static boolean EnableQuickAdd {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableQuickAdd, false);}}
	public static boolean EnableEditableUsageView {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEditableUsageView, false);}}
	public static boolean EnableOriginalMonthlyView {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableOriginalMonthlyView, true);}}
	public static boolean EnableAADResourcingStatus {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAADResourcingStatus, false);}}
	public static boolean EnableAADResourcingMgr {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAADResourcingMgr, false);}}
	public static boolean EnableAADResourcingAddDetails {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAADResourcingAddDetails, false);}}
	public static boolean EnableAADResourcingDetails {get{return EnableAADResourcingStatus || EnableAADResourcingMgr || EnableAADResourcingAddDetails;}}
	public static string BillingAccountValidation {get {return getStringKimbleConfigValue(KimbleConfigEnum.BillingAccountValidation, 'BillingAccountIsChild');}}
	public static integer BillingContactEnhancedLookupThreshold {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.BillingContactEnhancedLookupThreshold, 100);}}
	public static integer UserEnhancedLookupThreshold {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.UserEnhancedLookupThreshold, 50);}}
	public static boolean EnableAdhocCreditNotes {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAdhocCreditNotes, false);}}
	public static boolean EnableLoseProposalOnOpportunity {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableLoseProposalOnOpportunity, false);}}
	public static boolean EnableOpenProposalInClosedPeriod {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableOpenProposalInClosedPeriod, false);}}
	public static boolean EnableObjectInRecordLayout {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableObjectInRecordLayout, false);}}
	public static boolean EnableTimeExpensePdfAttSaveOnDispatch {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableTimeExpensePdfAttSaveOnDispatch, false);}}
	public static boolean EnableKimbleLookupUsingSOSL {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableKimbleLookupUsingSOSL, false);}}
	public static string FileTypesToIncludeOnInvoiceEmail {get{return getStringKimbleConfigValue(KimbleConfigEnum.FileTypesToIncludeOnInvoiceEmail, 'csv');}}
	public static integer ResourcePaymentCardStatementAllocPageMaxAssignments {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.ResourcePaymentCardStatementAllocPageMaxAssignments, 20);}}
	public static boolean LoadAllResourceHtmlInGanttView {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.LoadAllResourceHtmlInGanttView, false);}}
	public static string CustomCalendarType {get{return getStringKimbleConfigValue(KimbleConfigEnum.CustomCalendarType, 'Gregorian');}}
	public static string CustomCalendarReferenceDate {get{return getStringKimbleConfigValue(KimbleConfigEnum.CustomCalendarReferenceDate, DateService.ToUTCStringWithPadding(date.newInstance(DateService.Today.Year(), 1, 1)));}}
	public static boolean AssignmentDemandAutoGo {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.AssignmentDemandAutoGo, false);}}
	public static boolean UseGenResCapsOnDemand {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.UseGenResCapsOnDemand, false);}}
	public static string WhatIfAssignmentCostBasisFilter {get {return getStringKimbleConfigValue(KimbleConfigEnum.WhatIfAssignmentCostBasisFilter, '');}}
	public static string WhatIfAssignmentCostExRateFilter {get {return getStringKimbleConfigValue(KimbleConfigEnum.WhatIfAssignmentCostExRateFilter, '');}}
	public static string WhatIfAssignmentRevenueBasisFilter {get {return getStringKimbleConfigValue(KimbleConfigEnum.WhatIfAssignmentRevenueBasisFilter, '');}}
	public static string WhatIfAssignmentRevenueExRateFilter {get {return getStringKimbleConfigValue(KimbleConfigEnum.WhatIfAssignmentRevenueExRateFilter, '');}}
	public static boolean FilterDelegatedApproversWithLicense {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.FilterDelegatedApproversWithLicense, true);}}
	public static integer PortfolioGroupMatchingPageSize {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.PortfolioGroupMatchingPageSize, 50);}}
	public static integer PortfolioDeliveryGroupLimit {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.PortfolioDeliveryGroupLimit, 500);}}
	public static integer RateCardSaveMaxItems {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.RateCardSaveMaxItems, 200);}}
	public static string TimeAdjustmentConfiguration {get {return getStringKimbleConfigValue(KimbleConfigEnum.TimeAdjustmentConfiguration, 'SINGLE');}}
	public static boolean EnableAlternativeProposals {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAlternativeProposals, false);}}
	public static string EnableResourceAssignmentPermissions {get {return getStringKimbleConfigValue(KimbleConfigEnum.EnableResourceAssignmentPermissions, 'INACTIVE');}}
	public static boolean EnableAlternateShippingAddress{get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAlternateShippingAddress,false);}}
	public static boolean EnableManageAllApprovalsPermissions{get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableManageAllApprovalsPermissions,false);}}
	public static boolean RecalcRatesOnAssignmentSnip {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.RecalcRatesOnAssignmentSnip, false);}}
	public static integer GovernorLimitPercentage {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.GovernorLimitPercentage, 95);}}
	public static boolean EnableICUDateFormats {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableICUDateFormats,false);}}
	public static boolean EnablePlanImportWizard {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnablePlanImportWizard,false);}}
	public static boolean EnablePlanImportWizardMergeStep {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnablePlanImportWizardMergeStep,false);}}
	public static boolean OverrideUBRForActualInClosedPeriod{get {return getBooleanKimbleConfigValue(KimbleConfigEnum.OverrideUBRForActualInClosedPeriod, false);}}
	public static string RealisationRateCalculationMethod{get {return getStringKimbleConfigValue(KimbleConfigEnum.RealisationRateCalculationMethod, 'NONE');}}
	public static boolean ShowBillingAccntElmntsInInvoicing{get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowBillingAccntElmntsInInvoicing, false);}}
	public static boolean BulkifyAssLogicOnApproveChildTime{get {return getBooleanKimbleConfigValue(KimbleConfigEnum.BulkifyAssLogicOnApproveChildTime, false);}}
	// Automated Resource Matching, Resource Usage Analysis and Availabilty Searching
	public static boolean ResourceUsageAnalysisEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableResourceUsageAnalysis, false);}}
	public static integer ResourceUsageAnalysisOffsetMths {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ResourceUsageAnalysisOffsetMths, 24);}}
	public static integer AvailabilityFilterMaxRecords {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.AvailabilityFilterMaxRecords, 2000);}}
	public static boolean AutomatedResourceMatchingEnabled {get{return ResourceUsageAnalysisEnabled && getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAutomatedResourceMatching, false);}}
	public static integer AutomatedResourceMatchingMinScore {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.AutomatedResourceMatchingMinScore, 100);}}
	public static integer AutomatedResourceMatchingMinCapScore {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.AutomatedResourceMatchingMinCapScore, 100);}}
	public static integer AutomatedResourceMatchingNumRes {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.AutomatedResourceMatchingNumRes, 1);}}
	public static integer AutoResMatchingMaxInlineCandRes {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.AutoResMatchingMaxInlineCandRes, 3);}}
	public static boolean AutoMatchEnforceCapExpiry {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.AutoMatchEnforceCapExpiry, true);}}
	public static boolean ResourcePeriodForecastInPAEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ResourcePeriodForecastInPAEnabled, false);}}
	/* resource availability scoring */
	public static boolean ResourceAvailabilityScoringEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ResourceAvailabilityScoringEnabled, true);}}
	public static integer ResourceAvailScoreStartOffsetNumMth {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ResourceAvailScoreStartOffsetNumMth, 1);}}
	public static integer ResourceAvailScoreDurationNumMth {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ResourceAvailScoreDurationNumMth, 3);}}
	public static string ResAvailScoreSearchInputLevel {get{return getStringKimbleConfigValue(KimbleConfigEnum.ResAvailScoreSearchInputLevel, 'ORG');}}
	public static boolean DynamicResAvailScoreSearchEnabled {get{return ResourceAvailabilityScoringEnabled && ResAvailScoreSearchInputLevel == 'SEARCH';}}
	/* Express Interest */
	public static boolean ExpressInterestEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableExpressInterest, false);}}
	public static boolean ExpressInterestNegPrefEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ExpressInterestEnableNegPref, true);}}
	public static string ExpressInterestDefCandStatus {get {return getStringKimbleConfigValue(KimbleConfigEnum.ExpressInterestDefCandStatus, 'NOTCLOSED');}}
	public static integer ExpressInterestMaxRecords {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ExpressInterestMaxRecords, 2000);}}
	public static boolean EnableResourceMgr {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableResourceMgr, false);}}
	public static boolean AssignmentQuickReAssignEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.AssignmentQuickReAssignEnabled, true);}}
	public static string ResourceSkillsPlanReviewPoint {get{return getStringKimbleConfigValue(KimbleConfigEnum.ResourceSkillsPlanReviewPoint, 'EndOfAssignment');}}
	public static integer ResourceSkillsPlanReviewPointOffset {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.ResourceSkillsPlanReviewPointOffset, 7);}}
	// dont allow target rating to be enabled - if skillPlans are not enabled ...
	public static Boolean TargetRatingsEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.TargetRatingsEnabled, false) && (ResourceSkillsPlanEnabled);}}
	public static Boolean ResourceSkillsPlanEnabled {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.ResourceSkillsPlanEnabled, false);}}
	public static Integer ResourceSkillsPlanDueDateMonths {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.ResourceSkillsPlanDueDateMonths, 1);}}
	public static Integer ResourceSkillsPlanDaysLimit {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.ResourceSkillsPlanDaysLimit, 30);}}
	public static Boolean EnhancedCapabilityMatching {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnhancedCapabilityMatching, false);}}
	public static Boolean WeightedCapabilityMatching {get{return EnhancedCapabilityMatching && getBooleanKimbleConfigValue(KimbleConfigEnum.WeightedCapabilityMatching, false);}}
	public static Integer DefaultCapabilityWeighting {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.DefaultCapabilityWeighting, 5);}}
	public static string DefaultCapabilityMatchingRule {get{return getStringKimbleConfigValue(KimbleConfigEnum.DefaultCapabilityMatchingRule, CapabilityMatchingRuleEnum.MatchRating);}}
    public static boolean EnforceMandatoryCapabilities {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnforceMandatoryCapabilities, false);}}
	/* Bench Optimisation */
	public static integer DemandSearchMaxRecords {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.DemandSearchMaxRecords, 200);}}
	public static boolean DemandSearchPopulateGrade { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.DemandSearchPopulateGrade, false);}}
	public static string DemandSearchCandStatus {get {return getStringKimbleConfigValue(KimbleConfigEnum.DemandSearchCandStatus, 'NOTCLOSED');}}
	/* Self-Billing */
	public static boolean GenerateSelfBillRefForManualSuppInv { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.GenerateSelfBillRefForManualSuppInv, false);}}
	public static boolean EnableAdhocSelfBillSupplierInvoices {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableAdhocSelfBillSupplierInvoices, false);}}
	public static boolean EnableSupplierSelfBillMultiCurrency {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableSupplierSelfBillMultiCurrency, false);}}
	public static boolean EnableSupplierTaxCodeTaxStatement {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableSupplierTaxCodeTaxStatement, false);}}
	public static boolean EnableSelfBillDefaultBatchApproval {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableSelfBillDefaultBatchApproval, false);}}
	public static string SupplierInvoiceResourceShareReason {get{return getStringKimbleConfigValue(KimbleConfigEnum.SupplierInvoiceResourceShareReason, 'SIR');}}
	public static integer BulkSupplierInvoiceRowLimit {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.BulkSupplierInvoiceRowLimit, Limits.getLimitQueryRows());}}
	//Mobile Delivery component views
	public static integer MobileWebDeliveryGroupListLimit { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.MobileWebDeliveryGroupListLimit, 20);}}
	//Case proposal
	public static string DefaultForecastStatusForCaseProposal { get {return getStringKimbleConfigValue(KimbleConfigEnum.DefaultForecastStatusForCaseProposal, null);}}
	public static boolean EnableDeliveryStagePermissions { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableDeliveryStagePermissions, false);}}
	public static boolean AlwaysCalcResourceCostAndRevRatesAsync { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.AlwaysCalcResourceCostAndRevRatesAsync, false);}}
	public static string DeliveryRiskAssessmentTrigger {get{return getStringKimbleConfigValue(KimbleConfigEnum.DeliveryRiskAssessmentTrigger, 'WIN');}}
	/* enhanced plan management */
	// EnhancedPlansEnabled is used if the executing code wants to know whether or not to actively apply an enhanced plan concept
	public static boolean EnhancedPlansEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEnhancedPlans, false);}}
	public static boolean IncludeUnclassifiedInAggUtilWarning { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.IncludeUnclassifiedInAggUtilWarning, true);}}
	// HasEnhancedPlans is more generic and is true if there ever have been enhanced plans (but it may now be disabled, such as when testing in sandbox)
	// EnhancedPlansWasEnabled is specifically set to true if enhanced plans was enabled and then disabled after enhanced plans have been created
	public static boolean EnhancedPlansWasEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.HasEnhancedPlans, false);}}
	public static boolean HasEnhancedPlans { get {return EnhancedPlansEnabled || EnhancedPlansWasEnabled;}}
	public static boolean HasClassicPlans { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.HasClassicPlans, true);}}
	public static boolean PlanChangeAsEnhancedPlan { get {return EnhancedPlansEnabled && PlanChangeBehaviour == 'EP';}}
	public static string PlanChangeBehaviour {get{return getStringKimbleConfigValue(KimbleConfigEnum.PlanChangeBehaviour, 'EP');}}
	public static integer PopulatePlanInLineThreshold {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.PopulatePlanInLineThreshold, 3000);}}
	public static integer PlanOfPlansTrackingPlanThreshold {get{return getIntegerKimbleConfigValue(KimbleConfigEnum.PlanOfPlansTrackingPlanThreshold, 2);}}
	public static boolean EarnedValueMgmtEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableEarnedValueMgmt, false);}}
	public static boolean ForecastOnPlannedNBD { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ForecastOnPlannedNBD, true);}}
	public static boolean UseTrackingPlanCalendarForGenerics { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.UseTrackingPlanCalendarForGenerics, false);}}
	public static boolean KimbleNotificationsEnabled {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.KimbleNotificationsEnabled, true);}}
	public static boolean ShowOtherAssignmentsForGenericResource {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowOtherAssignmentsForGenericResource, true);}}
	public static boolean SyncUnscheduledAndScheduledUsage {get{return getBooleanKimbleConfigValue(KimbleConfigEnum.SyncUnscheduledAndScheduledUsage, false);}}
	public static boolean IncludeActualInAggregate {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.IncludeActualInAggregate, false);}}
	public static boolean DefaultElementInvoicingCcyToOpportunityCcy {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.DefaultElementInvoicingCcyToOpportunityCcy, false);}}
	public static boolean DefaultRiskModelFromParent {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.DefaultRiskModelFromParent, true);}}
	public static boolean ReForecastOnAvailabilityChange {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ReForecastOnAvailabilityChange, false);}}
	public static boolean UseHourlyCostAndUtilWhenForecasting {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.UseHourlyCostAndUtilWhenForecasting, false);}}
	public static boolean ActualiseAtOvertimeRateWhenMaxExceeded {get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ActualiseAtOvertimeRateWhenMaxExceeded, false);}}
	public static String PrimarySortOrderOfTimeEntries {get {return getStringKimbleConfigValue(KimbleConfigEnum.PrimarySortOrderOfTimeEntries, 'STARTTIME ASC NULLS LAST');}}
	public static String SecondarySortOrderOfTimeEntries {get {return getStringKimbleConfigValue(KimbleConfigEnum.SecondarySortOrderOfTimeEntries, 'ENTRYUNITS ASC NULLS LAST');}}
	public static integer GridAutoSaveIdleTimeThreshold {get {return getIntegerKimbleConfigValue(KimbleConfigEnum.GridAutoSaveIdleTimeThreshold, 20);}}
	//Platform Encryption Settings
	public static string ResourceSortField {get{return getStringKimbleConfigValue(KimbleConfigEnum.ResourceSortField, 'Name');}}
	public static string ResourceSortFieldConfig {get{return getStringKimbleConfigValue(KimbleConfigEnum.ResourceSortFieldConfig, null);}}
	public static string AccountSortField {get{return getStringKimbleConfigValue(KimbleConfigEnum.AccountSortField, 'Name');}}
	public static string AccountSortFieldConfig {get{return getStringKimbleConfigValue(KimbleConfigEnum.AccountSortFieldConfig, null);}}
	public static string DeliveryGroupSortField {get{return getStringKimbleConfigValue(KimbleConfigEnum.DeliveryGroupSortField, 'Name');}}
	public static string DeliveryGroupSortFieldConfig {get{return getStringKimbleConfigValue(KimbleConfigEnum.DeliveryGroupSortFieldConfig, null);}}
	public static string DeliveryElementSortField {get{return getStringKimbleConfigValue(KimbleConfigEnum.DeliveryElementSortField, 'Name');}}
	public static string DeliveryElementSortFieldConfig {get{return getStringKimbleConfigValue(KimbleConfigEnum.DeliveryElementSortFieldConfig, null);}}
	public static string ResourcedActivitySortField {get{return getStringKimbleConfigValue(KimbleConfigEnum.ResourcedActivitySortField, SObjectType.ResourcedActivity__c.Fields.FullName__c.Name);}}
	public static string ResourcedActivitySortFieldConfig {get{return getStringKimbleConfigValue(KimbleConfigEnum.ResourcedActivitySortFieldConfig, null);}}
	public static string ProposalSortField {get{return getStringKimbleConfigValue(KimbleConfigEnum.ProposalSortField, 'Name');}}
	public static string ProposalSortFieldConfig {get{return getStringKimbleConfigValue(KimbleConfigEnum.ProposalSortFieldConfig, null);}}
	public static boolean CodeCoverageEnabled { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.CodeCoverageEnabled, false);}}
	public static boolean DefaultInvoiceBankAccountFromBUAndCcy { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.DefaultInvoiceBankAccountFromBUAndCcy, false);}}
	public static integer PurchaseOrderOverAllocationTolerance { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.PurchaseOrderOverAllocationTolerance, 0);}}
	public static boolean ShowScopingActivitiesInAssignmentsViews { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowScopingActivities, false);}}
	public static integer ContiguousAssignmentsBreakMonths { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ContiguousAssignmentsBreakMonths, 3);}}
	public static integer ContiguousAssignmentsMaximumMonths { get {return getIntegerKimbleConfigValue(KimbleConfigEnum.ContiguousAssignmentsMaximumMonths, 999);}}
	public static boolean EnableInvoicingSettings { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.EnableInvoicingSettings, false);}}
	//caching
	public static string ReferenceDataCacheName {get{return getStringKimbleConfigValueWithEmpty(KimbleConfigEnum.ReferenceDataCacheName, 'RefDataCache');}}
	public static string EventClassCacheName {get{return getStringKimbleConfigValueWithEmpty(KimbleConfigEnum.EventClassCacheName, 'EventClassCache');}}
	public static string InactiveUserCriteria {get{return getStringKimbleConfigValue(KimbleConfigEnum.InactiveUserCriteria, null);}}
	public static boolean ShowInternalDemandBusinessUnit { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowInternalDemandBusinessUnit, false);}}
	public static boolean ShowInternalSupplyBusinessUnit { get {return getBooleanKimbleConfigValue(KimbleConfigEnum.ShowInternalSupplyBusinessUnit, false);}}
	/* KimbleConfig__c Custom Setting List value handlers */
	private static boolean getBooleanKimbleConfigValue(string kimbleConfigEnum, boolean defaultValue)
	{
		KimbleConfig__c mc = KimbleConfig__c.getValues(kimbleConfigEnum);
		return (mc != null && mc.Value__c != null) ? (mc.Value__c.toLowerCase() == 'true') ? true : (mc.Value__c.toLowerCase() == 'false') ? false : defaultValue : defaultValue;
	}
	private static integer getIntegerKimbleConfigValue(string kimbleConfigEnum, integer defaultValue)
	{
		KimbleConfig__c mc = KimbleConfig__c.getValues(kimbleConfigEnum);
		integer returnValue = defaultValue;
		// minus values return false for IsNumeric so instead we have to attempt the cast
		if(mc != null && mc.Value__c != null)
		{
			try {
				returnValue = Integer.ValueOf(mc.Value__c);
			}
			Catch (exception e) {
			  // not an Integer
			}
		}
		return returnValue;
	}
	private static string getStringKimbleConfigValue(string kimbleConfigEnum, string defaultValue)
	{
		KimbleConfig__c mc = KimbleConfig__c.getValues(kimbleConfigEnum);
		return (mc != null && mc.Value__c != null && mc.Value__c != '' ? mc.Value__c : defaultValue);
	}
	private static string getStringKimbleConfigValueWithEmpty(string kimbleConfigEnum, string defaultValue)
	{
		KimbleConfig__c mc = KimbleConfig__c.getValues(kimbleConfigEnum);
		return (mc != null ? mc.Value__c : defaultValue);
	}
	public static void SetKimbleConfigValue(string kimbleConfigEnum, boolean newValue)
	{
		SetKimbleConfigValue(kimbleConfigEnum, String.ValueOf(newValue));
	}
	public static void SetKimbleConfigValue(string kimbleConfigEnum, Integer newValue)
	{
		SetKimbleConfigValue(kimbleConfigEnum, String.ValueOf(newValue));
	}
	public static void SetKimbleConfigValue(string kimbleConfigEnum, string newValue)
	{
		KimbleConfig__c mc = KimbleConfig__c.getValues(kimbleConfigEnum);
		if(mc == null)
		{
			insert new KimbleConfig__c(Name = kimbleConfigEnum, Value__c = newValue);
		}
		else
		{
			mc.Value__c = newValue;
			update mc;
		}
	}
	private static string getTrendAnalysisDefaultDimensionId()
	{
		string dimension;
		list<AnalysisDimension__c> theDimensions = [SELECT Id, Name FROM AnalysisDimension__c WHERE HasBusinessUnit__c = true AND HasGrade__c = false AND HasResourceType__c = false];
		if(theDimensions.size() > 0) dimension = theDimensions.get(0).Id;
		return dimension;
	}
	public static string GetCurrentInstanceString()
	{
		if (system.label.Namespace == 'null') return 'Dev Org';
		string versionNumber = '';
		try
		{
			Version version = System.requestVersion();
			if (version == null)
				versionNumber = 'UNKNOWN';
			else
			{
				string major = (version.major() == null ? 'NULL' : version.major().format());
				string minor = (version.minor() == null ? 'NULL' : version.minor().format());
				string patch = (version.patch() == null ? '0' : version.patch().format());
				versionNumber = string.format('{0}.{1}.{2}', new string[]{major, minor, patch});
			}
		}
		catch (Exception e)
		{
			System.debug(logginglevel.error,e);
			versionNumber = 'ERROR';
		}
		return string.format('{0} {1}', new string[]{versionNumber, UserInfo.getOrganizationName()});
	}
}