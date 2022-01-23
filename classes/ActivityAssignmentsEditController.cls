public with sharing class ActivityAssignmentsEditController {

	public SObject ThePageContext {get; set;}
	public string ThePageObjectType {get; set;}
	public string MenuContext {get; set;}
	public string FilterIdsJson {get; set;}
	public string TheJsonClassificationsMap {get; private set;}
	public integer GroupStartDateOffset {get; set;}
	public boolean ShowScopingActivities {get{return KimbleOneSetting.ShowScopingActivitiesInAssignmentsViews;}}

	public boolean CanCreateAssignments {get; set;}

	//TODO Obsolete - #15905
	public UIControl__c ShowHistoricAssignments {get; set;}

	public UIControl__c HideHistoricAssignments {get; set;}
	public UIControl__c ShowLostAssignments {get; set;}
	public boolean EnableLostAssignmentsFilter {get; set;}
	public transient list<FilterCriterion> TheFilterCriteria {get; private set;}

	public transient decimal DayToRevenueEntryConversionFactor {get; private set;}

	public boolean ShowLocation {get{return [SELECT COUNT() FROM Location__c] > 1;}}

	public boolean ShowMaxUsage {get{return KimbleOneSetting.DisplayAssignmentMaxUsage;}}

	public list<ResourcedActivity__c> TheResourcedActivities {get; set;}

	public String TheResourcedActivityIdNameMapJson {get; set;}

	public boolean showActivityRow {get; set;}

	public string TheUsageBehaviourRulesJson {get; set;}

	public ActivityAssignmentsEditController ()
	{
	   // Id could be DeliveryGroup or DeliveryProgram or Resource
		Id passedId = Apexpages.currentPage().getParameters().get('id');

		string offset = Apexpages.currentPage().getParameters().get('startDateoffset');

		if (offset != null && offset != '')
			GroupStartDateOffset = integer.valueOf(offset);
		else
			GroupStartDateOffset = 0;

		list<Id> contextIds = new list<Id>();

		ThePageObjectType = passedId.getSObjectType().getDescribe().getName();

		string ThePageContextSoql = string.format('SELECT Id, Name FROM {0} WHERE Id = :passedId', new string[]{
				ThePageObjectType
		});

		ThePageContext = database.query(HelperService.ParseDBQuery(ThePageContextSoql));

		TheResourcedActivities = new list<ResourcedActivity__c>();
		map<Id,ResourcedActivity> TheResourcedActivityIdNameMap = new map<Id,ResourcedActivity>();
		
		CanCreateAssignments = SObjectType.ActivityAssignment__c.createable;

		showActivityRow = KimbleOneSetting.ShowActivityGroupingInBulkAssgnmnts;

		if (passedId.getSObjectType() == DeliveryGroup__c.getSObjectType()) {
			MenuContext = 'DeliveryGroup';
			contextIds.add(passedId);

		} else if (passedId.getSObjectType() == DeliveryProgram__c.getSObjectType()) {
			MenuContext = 'DeliveryProgram';
			contextIds.add(passedId);

		} else if (passedId.getSObjectType() == Resource__c.getSObjectType()) {
			MenuContext = 'Resource';
			contextIds.add(passedId);
			CanCreateAssignments = false;
			showActivityRow = false;

		} else if (passedId.getSObjectType() == BusinessUnit__c.getSObjectType()) {
			MenuContext = 'BusinessUnit';
			contextIds.add(passedId);
			CanCreateAssignments = false;
			showActivityRow = false;

		} else if (passedId.getSObjectType() == ResourcedActivity__c.getSObjectType()) {
			MenuContext = 'ResourcedActivity';
			contextIds.add(passedId);
			showActivityRow = false;

		} else if (passedId.getSObjectType() == DeliveryPortfolio__c.getSObjectType()) {
			MenuContext = 'DeliveryPortfolio';

			for(DeliveryPortfolioDeliveryGroup__c dpdg : [SELECT DeliveryGroup__c FROM DeliveryPortfolioDeliveryGroup__c WHERE DeliveryPortfolio__c = :passedId])
			{
				contextIds.add(dpdg.DeliveryGroup__c);
			}
		}

		string passedFilterId = Apexpages.currentPage().getParameters().get('filterId');

		list<Id> theFilterIds = new list<Id>();

		if (passedFilterId != null && passedFilterId != '')
			theFilterIds.add(passedFilterId);
		else
			theFilterIds.addAll(contextIds);

		FilterIdsJson = json.serialize(theFilterIds);

		if (CanCreateAssignments)
		{
			list<ResourcedActivity__c> activities = [SELECT Id, Name, FullName__c, DeliveryElement__r.DeliveryElementOperatedWith__c, AllowNewRevenueCostItems__c
														FROM ResourcedActivity__c
														WHERE (DeliveryGroup__c IN :theFilterIds 
															OR Id IN :theFilterIds 
															OR DeliveryGroup__r.DeliveryProgram__c IN :theFilterIds 
															OR DeliveryElement__r.DeliveryElementOperatedWith__r.ResourcedActivity__c IN :theFilterIds
															OR DeliveryElement__r.DeliveryElementOperatedWith__r.DeliveryGroup__r.DeliveryProgram__c IN :theFilterIds
															OR DeliveryElement__r.DeliveryElementOperatedWith__r.DeliveryGroup__c IN :theFilterIds)
														AND DeliveryElement__r.ProbabilityCodeEnum__c != :ForecastStatusProbabilityCodeEnum.P0];

			activities.sort();

			map<Id, UserRecordAccess> activityAccess = UserService.GetUserRecordAccess(new list<Id>(new map<Id, ResourcedActivity__c>(activities).keyset()));

			for (ResourcedActivity__c activity : activities)
			{
				if (activityAccess.containsKey(activity.Id) && activityAccess.get(activity.Id).HasEditAccess)
				{
					if(activity.AllowNewRevenueCostItems__c == true)
						TheResourcedActivities.add(activity);
				}

				if(activity.DeliveryElement__r.DeliveryElementOperatedWith__c == null || ShowScopingActivities)
					TheResourcedActivityIdNameMap.put(activity.Id,new ResourcedActivity(activity));
			}
		}
		
		TheResourcedActivityIdNameMapJson = json.serialize(TheResourcedActivityIdNameMap);
		
		map<integer, GanttViewProperties.StyleClassification> mp = new map<integer, GanttViewProperties.StyleClassification>();

		for (ActivityAssignmentClass__c cls : [SELECT Id, Name, Priority__c, StyleClass__c, IncludeInAggregateUtilisationPercentage__c, IncludeInAvailabilityScorePercentage__c FROM ActivityAssignmentClass__c ORDER BY Priority__c])
		{
			mp.put(integer.valueof(cls.Priority__c), new GanttViewProperties.StyleClassification(cls));
		}

		TheJsonClassificationsMap = json.serialize(mp);

		MyActivityAssignmentPreference__c resourceAssignmentsPref = MyActivityAssignmentPreference__c.getInstance();

		HideHistoricAssignments = new UIControl__c(InputCheckbox__c = !resourceAssignmentsPref.ShowHistoricAssignments__c);

		ShowLostAssignments = new UIControl__c(InputCheckbox__c = false);

		string assignmentDeletionCriteria = KimbleOneSetting.AssignmentDeletionCriteria;
		EnableLostAssignmentsFilter = (assignmentDeletionCriteria != null && assignmentDeletionCriteria != '');

		TheFilterCriteria = new list<FilterCriterion>();

		for(SearchCriterion__c criteria : [SELECT Id, FieldName__c FROM SearchCriterion__c WHERE ContextType__r.Enum__c = :ContextTypeEnum.ActivityAssignment ORDER BY DisplaySequence__c])
		{
			TheFilterCriteria.add(new FilterCriterion(criteria.FieldName__c, ApexPages.currentPage().getParameters().get(criteria.FieldName__c) != null));
		}

		map<string, UsageBehaviourRule> behaviourRulesMap = new map<string, UsageBehaviourRule>();

		for (UsageBehaviourRule__c rule : UsageBehaviourRuleService.GetAllUsageBehaviourRules().values())
		{
			behaviourRulesMap.put(rule.Id, new UsageBehaviourRule(rule));
		}

		TheUsageBehaviourRulesJson = json.serialize(behaviourRulesMap);

		DayToRevenueEntryConversionFactor = KimbleOneSetting.AverageBusinessDaysPerMonth;
	}

	public boolean UseResourceEnhancedLookup
	{
		get
		{
			ResourcePreference__c pref = ResourcePreference__c.getInstance();

			if (pref == null)return false;

			return pref.UseEnhancedLookup__c;
		}
	}

	public boolean UseLocationEnhancedLookup
	{
		get
		{
			LocationPreference__c pref = LocationPreference__c.getInstance();

			if (pref == null) return false;

			return pref.UseEnhancedLookup__c;
		}
	}

	public list<SelectOption> TheFieldOptions
	{
		get
		{
			if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.Resource__c.Name && !UseResourceEnhancedLookup)
			{
				list<SelectOption> options = new list<SelectOption>();
				options.add(new SelectOption('', Label.None));

				// Only return Resources with an End Date after the earliest Open Tracking Period, across all Business Unit Groups,	as they can't be assigned in Closed Tracking Periods.

				TimePeriod__c earliestTrackingPeriod = TimePeriodService.GetEarliestOpenReportingTrackingPeriod();

				date startDate = earliestTrackingPeriod.StartDate__c;

				string resourceSoql = 'SELECT Id, Name FROM Resource__c WHERE (EndDate__c = null OR EndDate__c >= :startDate) ';

				resourceSoql += ResourceService.GetAssignableResourcesSoql();

				resourceSoql += ' ORDER BY Name asc LIMIT 500';

				for(Resource__c resource : database.query(HelperService.ParseDBQuery(resourceSoql)))
				{
					options.add(new SelectOption(resource.Id, resource.Name));
				}

				return options;
			}
			else if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.UsageBehaviourRule__c.Name) {

				list<SelectOption> options = new list<SelectOption>();

				if (TheClickedRecordId != null) {

					ActivityAssignment__c a = [SELECT ResourcedActivity__r.DeliveryElement__r.Product__r.ProductDomain__c, ResourcedActivity__r.ResourcedActivityType__r.Enum__c FROM ActivityAssignment__c WHERE Id = :TheClickedRecordId][0];

					string activityType = a.ResourcedActivity__r.ResourcedActivityType__r.Enum__c;

					for (UsageBehaviourRule__c rule : [
							SELECT Id, Name
							FROM UsageBehaviourRule__c
							WHERE ResourcedActivityType__r.Enum__c = :activityType
							AND (ProductDomain__c = :a.ResourcedActivity__r.DeliveryElement__r.Product__r.ProductDomain__c OR ProductDomain__c = NULL)
							ORDER BY DisplaySequence__c
					]) {
						options.add(new SelectOption(rule.Id, rule.Name));
					}
				}

				return options;
			}
			else if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.ActivityRole__c.Name) {

				//find activity roles
				list<SelectOption> options = new list<SelectOption>();

				if (TheClickedRecordId != null) {

					ActivityAssignment__c a = [SELECT ResourcedActivity__r.ResourcedActivityType__r.Enum__c, ActivityRole__c FROM ActivityAssignment__c WHERE Id = :TheClickedRecordId][0];

					string activityType = a.ResourcedActivity__r.ResourcedActivityType__r.Enum__c;

					for (ActivityRole__c role : [SELECT Id, Name, IsActive__c FROM ActivityRole__c WHERE ResourcedActivityType__r.Enum__c = :activityType ORDER BY Name]) {
						if(role.IsActive__c == true || (a != null && a.ActivityRole__c == role.Id)) options.add(new SelectOption(role.Id, role.Name));
					}
				}

				return options;
			}
			else if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.Location__c.Name){
				list<Location__c> locations = [SELECT Id, Name FROM Location__c ORDER BY Name];

				// if only 0 or 1 locations defined then don't show this field
				if (locations.size() < 2) return new list<SelectOption>();

				list<SelectOption> options = new list<SelectOption>();

				options.add(new SelectOption('', ''));

				for(Location__c loc : locations)
				{
					options.add(new SelectOption(loc.Id, loc.Name));
				}

				return options;
			}
			else {
				return new list<SelectOption>();
			}
		}
	}

	public list<SelectOption> TheChangeOptions
	{
		get
		{
			list<SelectOption> options = new list<SelectOption>();

			options.add(new SelectOption(QuickActions.UpdateValue.name(), system.label.RevenueRateAbsoluteValueLabel));

			if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.InvoicingCurrencyForecastRevenueRate__c.Name || TheFieldName == SObjectType.ActivityAssignment__c.Fields.EntryRemainingUsage__c.Name)
			{
				if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.InvoicingCurrencyForecastRevenueRate__c.Name)
				{
					options.add(new SelectOption(QuickActions.IncreaseByPercent.name(), system.label.RevenueRatePercentageIncreaseLabel));
					options.add(new SelectOption(QuickActions.DecreaseByPercent.name(), system.label.RevenueRatePercentageDecreaseLabel));
				}

				options.add(new SelectOption(QuickActions.IncreaseByValue.name(), system.label.RevenueRateActualIncreaseLabel));
				options.add(new SelectOption(QuickActions.DecreaseByValue.name(), system.label.RevenueRateActualDecreaseLabel));
			}

			if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.StartDate__c.Name)
			{
				options.add(new SelectOption(QuickActions.ShiftStartDateTo.name(), system.label.MoveStartToDate));
				options.add(new SelectOption(QuickActions.ShiftStartDateByDays.name(), system.label.MoveStartDateByDays));
			}

			return options;
		}
	}

	public string TheMatchOnLabels
	{
		get
		{
			map<string, string> matchOnLabels = new map<string, string>();

			matchOnLabels.put(SObjectType.ActivityAssignment__c.Fields.InvoicingCurrencyForecastRevenueRate__c.Name, system.Label.AssignmentMatchOnRevenueRate);
			matchOnLabels.put(SObjectType.ActivityAssignment__c.Fields.InvoicingCostRate__c.Name, system.Label.AssignmentMatchOnCostRate);
			matchOnLabels.put(SObjectType.ActivityAssignment__c.Fields.EntryRemainingUsage__c.Name, system.Label.AssignmentMatchOnRemainingUsage);
			matchOnLabels.put(SObjectType.ActivityAssignment__c.Fields.ActivityRole__c.Name, system.Label.AssignmentMatchOnRole);
			matchOnLabels.put(SObjectType.ActivityAssignment__c.Fields.UsageBehaviourRule__c.Name, system.Label.AssignmentMatchOnUsageBehaviour);

			return json.serialize(matchOnLabels);
		}
	}

	public integer NumberOfSelectedRecords {get; set;}
	public Id TheClickedRecordId {get; set;}
	public ActivityAssignment__c TheAssignmentToUpdate {get; set;}
	public UIControl__c StartDateOffset {get; set;}
	public string EarliestOpenPeriodDate {get; set;}

	public string TheFieldName {get; set;}
	public string TheFieldLabel {get; set;}

	public string ClassNames {get; set;}
	public string FieldType {get; set;}
	public boolean ShowEffectiveDateField {get; set;}

	public void InitialiseAssignmentUpdateField()
	{
		TheFieldName = Apexpages.currentPage().getParameters().get('fieldName');
		NumberOfSelectedRecords = integer.valueOf(Apexpages.currentPage().getParameters().get('count'));
		TheClickedRecordId = Apexpages.currentPage().getParameters().get('assignmentId');

		TheAssignmentToUpdate = new ActivityAssignment__c();

		Schema.DescribeFieldResult field = HelperService.GetField(SObjectType.ActivityAssignment__c.Name, TheFieldName).getDescribe();

		string soql = GetAssignmentSelect(false);

		ActivityAssignment__c theClickedAssignment = (ActivityAssignment__c) database.query(HelperService.ParseDBQuery(soql + ' WHERE Id = :TheClickedRecordId'))[0];

		TheFieldLabel = field.getLabel();
		ShowEffectiveDateField = (TheFieldName == SObjectType.ActivityAssignment__c.Fields.InvoicingCostRate__c.Name);

		if (ShowEffectiveDateField) {

			EarliestOpenPeriodDate = DateService.ToUTCString(TimePeriodService.GetEarliestOpenForecastingPeriod(theClickedAssignment.ResourcedActivityOperatedWith__r.BusinessUnitGroup__c).StartDate__c);

			list<AssignmentForecastCostRate> costRates = AssignmentForecastCostRate.DeserializeFromJson(theClickedAssignment.TemporalForecastCostRate__c);

			theClickedAssignment.InvoicingCostRate__c = costRates[costRates.size()-1].CostRate * UnitTypeService.ConvertRate(theClickedAssignment.ResourcedActivityOperatedWith__r.ForecastUnitType__c, theClickedAssignment.ResourcedActivityOperatedWith__r.InvoicingUnitType__c, theClickedAssignment.HoursPerDay__c);
		}

		if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.InvoicingCurrencyForecastRevenueRate__c.Name) {
			UnitType__c revUnitType = ResourcedActivityService.GetRevenueEntryUnitType(theClickedAssignment.ResourcedActivityOperatedWith__r);
			TheFieldLabel += (' (' + theClickedAssignment.InvoicingCurrencyIsoCode__c + ' / ' + revUnitType.Name) + ')';

			//manufacture forecast rate to be rate in display units - this conversion is reversed on save
			theClickedAssignment.InvoicingCurrencyForecastRevenueRate__c = theClickedAssignment.InvoicingCurrencyForecastRevenueRate__c * UnitTypeService.ConvertRate(theClickedAssignment.ResourcedActivityOperatedWith__r.ForecastUnitType__c, revUnitType.Id, theClickedAssignment.HoursPerDay__c);
		}

		if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.InvoicingCostRate__c.Name) TheFieldLabel += (' (' + theClickedAssignment.CurrencyISOCode + ' / ' + theClickedAssignment.ResourcedActivityOperatedWith__r.InvoicingUnitType__r.Suffix__c) + ')';

		if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.StartDate__c.Name) StartDateOffset = new UIControl__c(InputInteger__c = 0);

		ClassNames = '';

		if (TheFieldName == SObjectType.ActivityAssignment__c.Fields.Resource__c.Name)
			ClassNames += ' kimbleSearch SearchResources ';

		FieldType = field.getType().name();

		if (NumberOfSelectedRecords < 2)
		{
			TheAssignmentToUpdate = theClickedAssignment;
		}

		ApexPages.getMessages().clear();
	}

	private static string GetAssignmentSelect(boolean includeCandidates) {
		string fieldsetName = HelperService.Namespace + 'AssignmentKeyFields';

		list<string> fieldSetFields = new list<string>();

		if (KimbleOneSetting.ShowAssignmentMarginInDelivery && SObjectType.ActivityAssignment__c.Fields.TemporalForecastCostRate__c.IsAccessible()) fieldSetFields.add(SObjectType.ActivityAssignment__c.Fields.AssignmentMarginPercentage__c.Name);

		if (KimbleOneSetting.AssignmentKeyFieldsFieldsetEnabled) {
			for (Schema.FieldSetMember f : SObjectType.ActivityAssignment__c.FieldSets.getMap().get(fieldsetName).getFields()) {
				Schema.DescribeFieldResult fld = HelperService.GetField(SObjectType.ActivityAssignment__c.Name, f.getFieldPath()).getDescribe();

				if (!fld.isUpdateable()) continue;

				if (fld.getType() == DisplayType.REFERENCE && fld.getReferenceTo()[0].getDescribe().Name != SObjectType.WorkflowInstance__c.Name) {
					fieldSetFields.add(fld.getRelationshipName() + '.Name');
				} else {
					fieldSetFields.add(f.getFieldPath());
				}
			}
		}

		set<string> coreFields = new set<string>{'Id', SObjectType.ActivityAssignment__c.fields.ResourcedActivity__c.Name, SObjectType.ActivityAssignment__c.fields.ActivityAssignment__c.Name, SObjectType.ActivityAssignment__c.fields.CurrencyIsoCode.Name, SObjectType.ActivityAssignment__c.fields.ResourceInitials__c.Name, SObjectType.ActivityAssignment__c.fields.ProbabilityCode__c.getRelationshipName() + '.' + SObjectType.ReferenceData__c.fields.Enum__c.Name,
												SObjectType.ActivityAssignment__c.fields.TimeEntryCount__c.Name, SObjectType.ActivityAssignment__c.fields.EarliestExpenseItemDate__c.Name, SObjectType.ActivityAssignment__c.fields.Resource__c.getRelationshipName() + '.Name', SObjectType.ActivityAssignment__c.fields.ResourcedActivity__c.getRelationshipName() + '.Name',
												SObjectType.ActivityAssignment__c.fields.ActivityRole__c.getRelationshipName() + '.Name', SObjectType.ActivityAssignment__c.fields.Location__c.getRelationshipName() + '.Name', SObjectType.ActivityAssignment__c.fields.InvoicingCurrencyForecastRevenueRate__c.Name, SObjectType.ActivityAssignment__c.fields.InvoicingCurrencyISOCode__c.Name,
												SObjectType.ActivityAssignment__c.fields.ActivityAssignmentType__c.getRelationshipName() + '.' +  SObjectType.ActivityAssignmentType__c.fields.Enum__c.Name,
												SObjectType.ActivityAssignment__c.fields.ResourcedActivityOperatedWith__c.getRelationshipName() + '.' + SObjectType.ResourcedActivity__c.fields.InvoicingUnitType__c.getRelationshipName() + '.' +  SObjectType.UnitType__c.fields.Suffix__c.Name, SObjectType.ActivityAssignment__c.fields.ResourcedActivityOperatedWith__c.getRelationshipName() + '.' + SObjectType.ResourcedActivity__c.fields.ForecastUnitType__c.getRelationshipName() + '.' +  SObjectType.UnitType__c.fields.Suffix__c.Name,
												SObjectType.ActivityAssignment__c.fields.ResourcedActivityOperatedWith__c.getRelationshipName() + '.' + SObjectType.ResourcedActivity__c.fields.RevenueEntryUnitType__c.getRelationshipName() + '.' +  SObjectType.UnitType__c.fields.Suffix__c.Name,
												SObjectType.ActivityAssignment__c.fields.StartDate__c.Name, SObjectType.ActivityAssignment__c.fields.ForecastP3EndDate__c.Name, SObjectType.ActivityAssignment__c.fields.EntryRemainingUsage__c.Name, SObjectType.ActivityAssignment__c.fields.MaximumUsage__c.Name, SObjectType.ActivityAssignment__c.fields.IsUsageProfiled__c.Name, SObjectType.ActivityAssignment__c.fields.UsageBehaviourRule__c.getRelationshipName() + '.Name',
												SObjectType.ActivityAssignment__c.fields.InvoicingCostRate__c.Name,
												SObjectType.ActivityAssignment__c.fields.TemporalForecastCostRate__c.Name,
				                                SObjectType.ActivityAssignment__c.fields.HoursPerDay__c.Name,
												SObjectType.ActivityAssignment__c.fields.BaselineUtilisationPercentage__c.Name,
												SObjectType.ActivityAssignment__c.fields.ResourcedActivityOperatedWith__c.getRelationshipName() + '.Name',
												SObjectType.ActivityAssignment__c.fields.ResourcedActivity__c.getRelationshipName() + '.' + SObjectType.ResourcedActivity__c.fields.FullName__c.Name,
												SObjectType.ActivityAssignment__c.fields.ResourcedActivityOperatedWith__c.getRelationshipName() + '.' + SObjectType.ResourcedActivity__c.fields.FullName__c.Name,
												SObjectType.ActivityAssignment__c.fields.ResourcedActivity__c.getRelationshipName() + '.' + SObjectType.ResourcedActivity__c.fields.ResourcedActivityType__c.Name,
												HelperService.NamespaceFieldPath('ResourcedActivityOperatedWith__r.CostBehaviourRule__r.CanEditCostRate__c'),
												HelperService.NamespaceFieldPath('ResourcedActivityOperatedWith__r.RevenueBehaviourRule__r.AcceptRevenueChanges__r.Enum__c'),
												HelperService.NamespaceFieldPath('ResourcedActivityOperatedWith__r.BusinessUnitGroup__c'),
				                                HelperService.NamespaceFieldPath('ResourcedActivityOperatedWith__r.ForecastUnitType__r.Enum__c'),
												HelperService.NamespaceFieldPath('ResourcedActivityOperatedWith__r.InvoicingUnitType__r.Enum__c'),
				                                HelperService.NamespaceFieldPath('ResourcedActivityOperatedWith__r.RevenueEntryUnitType__r.Enum__c'),
				                                HelperService.NamespaceFieldPath('ResourcedActivityOperatedWith__r.ForecastUnitType__r.Name'),
				                                HelperService.NamespaceFieldPath('ResourcedActivityOperatedWith__r.InvoicingUnitType__r.Name'),
				                                HelperService.NamespaceFieldPath('ResourcedActivityOperatedWith__r.RevenueEntryUnitType__r.Name'),
												SObjectType.ActivityAssignment__c.fields.ActivityAssignment__c.getRelationshipName() + '.' + SObjectType.ActivityAssignment__c.fields.ActivityAssignmentType__c.getRelationshipName() + '.' +  SObjectType.ActivityAssignmentType__c.fields.Enum__c.Name};

		string soql = 'SELECT ';

		coreFields.addAll(fieldSetFields);

		soql += string.join(new list<string>(coreFields), ',') + ',';

		if (includeCandidates) {
			soql += ' (SELECT Id, ' + SObjectType.ActivityAssignment__c.fields.Resource__c.getRelationshipName() + '.Name' + ', ' + SObjectType.ActivityAssignment__c.fields.ResourcedActivity__c.getRelationshipName() + '.Name' + ', ' + SObjectType.ActivityAssignment__c.fields.ActivityRole__c.getRelationshipName() + '.Name' + ', ' + SObjectType.ActivityAssignment__c.fields.Location__c.getRelationshipName() + '.Name' + ', ' +
					' ' + SObjectType.ActivityAssignment__c.fields.InvoicingCurrencyForecastRevenueRate__c.Name + ', ' + SObjectType.ActivityAssignment__c.fields.InvoicingCurrencyISOCode__c.Name + ', ' +
					'' + SObjectType.ActivityAssignment__c.fields.ResourcedActivityOperatedWith__c.getRelationshipName() + '.' + SObjectType.ResourcedActivity__c.fields.InvoicingUnitType__c.getRelationshipName() + '.' +  SObjectType.UnitType__c.fields.Suffix__c.Name + ', ' + SObjectType.ActivityAssignment__c.fields.ResourcedActivityOperatedWith__c.getRelationshipName() + '.' + SObjectType.ResourcedActivity__c.fields.RevenueEntryUnitType__c.getRelationshipName() + '.' +  SObjectType.UnitType__c.fields.Suffix__c.Name + ', ' + SObjectType.ActivityAssignment__c.fields.ResourcedActivityOperatedWith__c.getRelationshipName() + '.' + SObjectType.ResourcedActivity__c.fields.ForecastUnitType__c.getRelationshipName() + '.' +  SObjectType.UnitType__c.fields.Suffix__c.Name + ', ' + SObjectType.ActivityAssignment__c.fields.StartDate__c.Name + ', ' + SObjectType.ActivityAssignment__c.fields.ForecastP3EndDate__c.Name + ', ' +
					'' + SObjectType.ActivityAssignment__c.fields.EntryRemainingUsage__c.Name + ', ' + SObjectType.ActivityAssignment__c.fields.UsageBehaviourRule__c.getRelationshipName() + '.Name' + ', ' + SObjectType.ActivityAssignment__c.fields.InvoicingCostRate__c.Name + ', ' + SObjectType.ActivityAssignment__c.fields.BaselineUtilisationPercentage__c.Name +
					' FROM ActivityAssignments__r WHERE CandidateStatus__r.Enum__c = :proposed) ';
		}

		soql += 'LastModifiedDate FROM ActivityAssignment__c ';

		return soql;
	}

	@RemoteAction
	public static GetAssignmentsByIdResult GetAssignmentsById(list<string> assignmentIds)
	{
		GetAssignmentsByIdResult result = new GetAssignmentsByIdResult();

		string soql = GetAssignmentSelect(true);

		string proposed = AssignmentCandidateStatusEnum.Proposed;

		result.TheAssignments = database.query(HelperService.ParseDBQuery(soql + ' WHERE Id IN :assignmentIds'));
		result.RecordLostReasonAssignments = ActivityAssignmentService.RecordLostReasonForAssignment((new map<Id, ActivityAssignment__c>(result.TheAssignments)).keyset());

		return result;
	}

	public class GetAssignmentsByIdResult
	{
		public list<ActivityAssignment__c> TheAssignments {get; set;}
		public set<Id> RecordLostReasonAssignments {get; set;}
	}

	@RemoteAction
	public static GetAssignmentsResult GetAssignments(list<string> filterIds, boolean showHistoricAssignments, boolean showLostAssignments, list<ResourcedActivityGantt.AssignmentFilter> filters)
	{
		GetAssignmentsResult result = new GetAssignmentsResult();

		string fieldsetName = HelperService.Namespace +  'AssignmentKeyFields';

		result.TheFieldSets = new map<string, AssignmentField>();

		if (KimbleOneSetting.ShowAssignmentMarginInDelivery && SObjectType.ActivityAssignment__c.Fields.TemporalForecastCostRate__c.IsAccessible()) {
			result.TheFieldSets.put(SObjectType.ActivityAssignment__c.Fields.AssignmentMarginPercentage__c.Name, new AssignmentField(SObjectType.ActivityAssignment__c.Fields.AssignmentMarginPercentage__c, false));
		}

		if (KimbleOneSetting.AssignmentKeyFieldsFieldsetEnabled) {
			for (Schema.FieldSetMember f : SObjectType.ActivityAssignment__c.FieldSets.getMap().get(fieldsetName).getFields()) {
				Schema.DescribeFieldResult field = HelperService.GetField(SObjectType.ActivityAssignment__c.Name, f.getFieldPath()).getDescribe();

				if (!field.isUpdateable() || f.getFieldPath().contains('.')) continue;

				if (field.getType() == DisplayType.REFERENCE && field.getReferenceTo()[0].getDescribe().Name != SObjectType.WorkflowInstance__c.Name) {
					result.TheFieldSets.put(field.getRelationshipName() + '.Name', new AssignmentField(field, field.isUpdateable()));
				} else {
					result.TheFieldSets.put(f.getFieldPath(), new AssignmentField(field, field.isUpdateable()));
				}
			}
		}

		string soql = GetAssignmentSelect(true);

		date earliestAssignmentEndDate;

		soql += ' WHERE (ResourcedActivityOperatedWith__r.DeliveryElement__r.DeliveryGroup__c IN :filterIds OR ResourcedActivityOperatedWith__c IN :filterIds' +
				' OR ResourcedActivityOperatedWith__r.DeliveryElement__r.DeliveryGroup__r.DeliveryProgram__c IN :filterIds' +
				' OR Resource__c IN :filterIds' +
				' OR Resource__r.BusinessUnit__c IN :filterIds) ' +
				' AND (ActivityAssignment__c = null OR ActivityAssignment__r.ActivityAssignmentType__r.Enum__c = :appliedModel) ' +
				' AND ActivityAssignmentType__r.Enum__c != :templated ' +
				' AND ActivityAssignmentType__r.Enum__c != :activatedModel ' +
				' AND ResourcedActivity__r.AllowNewRevenueCostItems__c = true ';

		if(!showLostAssignments)
		{
			soql += ' AND ' + Schema.SObjectType.ActivityAssignment__c.Fields.ProbabilityCode__c.Name + ' != :p0 ';
		}

		if(!showHistoricAssignments)
		{
			earliestAssignmentEndDate = TimePeriodService.GetEarliestOpenTrackingPeriod().StartDate__c.addMonths(-2);
			soql += ' AND ForecastP3EndDate__c >= :earliestAssignmentEndDate';
		}

		for (ResourcedActivityGantt.AssignmentFilter filter : filters)
		{
			soql += filter.GetSoqlCriterion();
		}

		soql += ' ORDER BY ResourcedActivity__r.DeliveryElement__r.StartDate__c, ResourcedActivity__r.' + HelperService.GetObjectOrderByField(SObjectType.ResourcedActivity__c.Name) + ', Resource__r.' + HelperService.GetObjectOrderByField(SObjectType.Resource__c.Name) + ', StartDate__c LIMIT 1001';

		System.debug(logginglevel.error,soql);

		string P0 = ForecastStatusProbabilityCodeEnum.P0Id;
		string proposed = AssignmentCandidateStatusEnum.Proposed;
		string templated = ActivityAssignmentTypeEnum.Templated;
		string appliedModel = ActivityAssignmentTypeEnum.AppliedModel;
		string activatedModel = ActivityAssignmentTypeEnum.ActivatedModel;

		//Need to build list of assignment decorators
		list<ActivityAssignment__c> returnedActivityAssignments = new list<ActivityAssignment__c>();
		result.TheAssignments = new list<ActivityAssignment__c>();
		try {
			returnedActivityAssignments = database.query(HelperService.ParseDBQuery(soql));
		}
		catch (Exception e)
		{
			Raise.ErrorInService('Error in dynamic assignment query: ' + soql);
		}

		set<Id> activityIds = new set<Id>();
		result.ResourceAccessMap = new map<string, boolean>();

		Id prevActivityId = null;

		// the assignments should be added to the list in parent child order to aid the display
		// first iterate the collection and build a) a map keyed by parent containing a list of children
		// and b) a list of parents/normal assignments
		// we then iterate list b) adding each entry followed immediately by and children of that parent
		map<Id, list<ActivityAssignment__c>> parentAndChildMap = new map<Id, list<ActivityAssignment__c>>();
		list<ActivityAssignment__c> theParentAssignments = new list<ActivityAssignment__c>();
		for (ActivityAssignment__c theAssignment : returnedActivityAssignments)
		{
			if(theAssignment.ActivityAssignment__c != null)
			{
				if(!parentAndChildMap.containsKey(theAssignment.ActivityAssignment__c)) parentAndChildMap.put(theAssignment.ActivityAssignment__c, new list<ActivityAssignment__c>());
				parentAndChildMap.get(theAssignment.ActivityAssignment__c).add(theAssignment);
			}
			else
			{
				theParentAssignments.add(theAssignment);
			}

			if (theAssignment.ActivityAssignments__r != null && theAssignment.ActivityAssignments__r.size() > 0) {
				for (ActivityAssignment__c a : theAssignment.ActivityAssignments__r) {
					result.ResourceAccessMap.put(a.Resource__c, false);
				}
			}

			result.ResourceAccessMap.put(theAssignment.Resource__c, false);
		}

		for (ActivityAssignment__c theAssignment : theParentAssignments)
		{
			activityIds.add(theAssignment.ResourcedActivity__c);

			if (prevActivityId != null && theAssignment.ResourcedActivity__c != prevActivityId) result.ShowActivity = true;

			prevActivityId = theAssignment.ResourcedActivity__c;

			result.TheAssignments.add(theAssignment);

			if(parentAndChildMap.containsKey(theAssignment.Id))
			{
				for (ActivityAssignment__c theChildAssignment : parentAndChildMap.get(theAssignment.Id))
				{
					result.TheAssignments.add(theChildAssignment);
				}
			}
		}

		ResourceService.PopulateCanEditAssignmentsMap(result.ResourceAccessMap);

		result.ActivityAccessMap = UserService.GetUserRecordAccess(new list<Id>(activityIds));

		result.RecordLostReasonAssignments = ActivityAssignmentService.RecordLostReasonForAssignment((new map<Id, ActivityAssignment__c>(result.TheAssignments)).keyset());

		return result;
	}

	public class GetAssignmentsResult
	{
		public list<ActivityAssignment__c> TheAssignments {get; set;}
		public map<string, AssignmentField> TheFieldSets {get; set;}
		public map<Id, UserRecordAccess> ActivityAccessMap {get; set;}
		public set<Id> RecordLostReasonAssignments {get; set;}
		public map<string, boolean> ResourceAccessMap {get; set;}
		public boolean ShowActivity {get; set;}
	}

	public class AssignmentField
	{
		public AssignmentField(Schema.DescribeFieldResult fld, boolean isUpdateable)
		{
			Label = fld.getLabel();
			DisplayType = fld.getType().name();
			FieldName = fld.getName();
			IsEditable = isUpdateable;
			IsWorkflow = false;

			if (fld.getType() == Schema.DisplayType.REFERENCE)
			{
				if (fld.getReferenceTo()[0].getDescribe().Name == SObjectType.WorkflowInstance__c.Name) {
					IsWorkflow = true;
				}
			}
		}

		public string Label {get; set;}
		public string FieldName {get; set;}
		public string DisplayType {get; set;}
		public boolean IsEditable {get; set;}
		public boolean IsWorkflow {get; set;}
	}

	public enum QuickActions {UpdateValue, IncreaseByPercent, IncreaseByValue, DecreaseByPercent, DecreaseByValue, ShiftStartDateTo, ShiftStartDateByDays}

	@RemoteAction
	public static SaveAssignmentResult SaveAssignments(list<Id> assignmentIds, string fieldName, string actionEnum, object value)
	{
		UnitOfWork uow = UnitOfWork.Create();

		SaveAssignmentResult result = new SaveAssignmentResult();

		result.Problems = new list<Problem>();

		list<ActivityAssignment__c> assignmentsToUpdate = new list<ActivityAssignment__c>();

		Schema.DescribeFieldResult field = HelperService.GetField(SObjectType.ActivityAssignment__c.Name, fieldName).getDescribe();

		if(value instanceof String && value == '') value = null;

		try
		{
			map<Id, sObject> assignments = ActivityAssignmentDecorator.GetAssignmentsById(new set<Id>(assignmentIds), true);

			set<Id> resourceIds = new set<Id>();
			set<Id> activityIds = new set<Id>();

			//Split into jobs - 1 job per resourced activity and 100 assignments
			//run first job immediately

			for (sObject ass : assignments.values())
			{
				ActivityAssignment__c a = (ActivityAssignment__c) ass;

				resourceIds.add(a.Resource__c);
				activityIds.add(a.ResourcedActivity__c);
			}

			ResourceService.PopulateResourceCache(resourceIds);
			ResourcedActivityService.PopulateResourcedActivityCache(activityIds);

			AssignmentProperties properties;

			//if updating revenue then pre-load revenue rules
			if (fieldName == SObjectType.ActivityAssignment__c.Fields.InvoicingCurrencyForecastRevenueRate__c.Name || fieldName == SObjectType.ActivityAssignment__c.Fields.InvoicingCostRate__c.Name)
			{
				properties = new AssignmentProperties(assignmentIds);
			}

			for (sObject ass : assignments.values())
			{
				ActivityAssignmentDecorator assignment = new ActivityAssignmentDecorator((ActivityAssignment__c) ass);

				try {
					if (fieldName == SObjectType.ActivityAssignment__c.Fields.Resource__c.Name) {

						if (!assignment.CanEditResource) {
							Raise.RecoverableErrorInService(assignment.TheAssignment.Id, string.format(Label.ProblemSavingAssignment, new string[]{assignment.TheAssignment.Name}) + Label.AssignmentSaveCannotUpdateResource);
						}
						assignment.AssignResource((Id) value);

					} else if (fieldName == SObjectType.ActivityAssignment__c.Fields.ActivityRole__c.Name) {

						assignment.SetRole(value == null?null:(Id) value);

					} else if (fieldName == SObjectType.ActivityAssignment__c.Fields.Location__c.Name) {

						assignment.SetLocation(value == null?null:(Id) value);

					} else if (fieldName == SObjectType.ActivityAssignment__c.Fields.InvoicingCostRate__c.Name) {

						AssignmentCostRateChange costChange = (AssignmentCostRateChange) JSON.deserialize(string.valueOf(value), AssignmentCostRateChange.class);

						if(assignment.HasSupplierCostRate || !assignment.TheActivity.TheOperatingActivity.CostBehaviourRule__r.CanEditCostRate__c || !SObjectType.ActivityAssignment__c.Fields.TemporalForecastCostRate__c.Updateable) {
							Raise.RecoverableErrorInService(assignment.TheAssignment.Id, string.format(Label.ProblemSavingAssignment, new string[]{
									assignment.TheAssignment.Name
							}) + Label.CostRateIsReadonly);
						}

						//Value is passed in Invoicing Units
						assignment.TheAssignment.ForecastCostRate__c = (costChange.value) * UnitTypeService.ConvertRate(assignment.TheActivity.TheOperatingActivity.InvoicingUnitType__c, assignment.TheActivity.TheOperatingActivity.ForecastUnitType__c, assignment.TheAssignment.HoursPerDay__c);
						assignment.TheAssignment.ForecastCostRateEffectiveDate__c = DateService.FromUTCString(costChange.EffectiveDate);

					} else if (fieldName == SObjectType.ActivityAssignment__c.Fields.InvoicingCurrencyForecastRevenueRate__c.Name) {
						if (!assignment.TheActivity.HasRevenue) {
							Raise.RecoverableErrorInService(assignment.TheAssignment.Id, string.format(Label.ProblemSavingAssignment, new string[]{
									assignment.TheAssignment.Name
							}) + Label.AssignmentNoRevenue);
						}

						if (!SObjectType.ActivityAssignment__c.Fields.TemporalForecastRevenueRate__c.Updateable) {
							Raise.RecoverableErrorInService(assignment.TheAssignment.Id, string.format(Label.ProblemSavingAssignment, new string[]{
									assignment.TheAssignment.Name
							}) + Label.RevenueRateIsReadonly);
						}

						if (properties.IsInvoiced.contains(assignment.TheAssignment.Id) || properties.IsWrittenOff.contains(assignment.TheAssignment.Id) || properties.IsInClosedPeriod.contains(assignment.TheAssignment.Id)) {
							Raise.RecoverableErrorInService(assignment.TheAssignment.Id, string.format(Label.ProblemSavingAssignment, new string[]{
									assignment.TheAssignment.Name
							}) + Label.RevenueInvoicedWrittenOffClosed);
						}

						//Capped Usage / Capped Usage exceeded - revenue rate change effective date for notional revenue
						decimal val = decimal.valueOf(string.valueOf(value));

						val = val * UnitTypeService.ConvertRate(ResourcedActivityService.GetRevenueEntryUnitType(assignment.TheActivity.TheOperatingActivity).Id, assignment.TheActivity.TheOperatingActivity.ForecastUnitType__c, assignment.TheAssignment.HoursPerDay__c);

						if (actionEnum == QuickActions.IncreaseByPercent.name()) {
							assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c = (assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c + assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c * val / 100).setScale(2);
						} else if (actionEnum == QuickActions.DecreaseByPercent.name()) {
							assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c = (assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c - assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c * val / 100).setScale(2);
						} else if (actionEnum == QuickActions.IncreaseByValue.name()) {
							assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c = (assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c + val).setScale(2);
						} else if (actionEnum == QuickActions.DecreaseByValue.name()) {
							assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c = (assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c - val).setScale(2);
						} else {
							assignment.TheAssignment.InvoicingCurrencyForecastRevenueRate__c = val;
						}
					}
					else if (fieldName == SObjectType.ActivityAssignment__c.Fields.StartDate__c.Name) {
						if (actionEnum == QuickActions.ShiftStartDateTo.name()) {
							assignment.ChangeStartDate(DateService.FromUTCString(string.valueof(value)));
						}
						if (actionEnum == QuickActions.ShiftStartDateByDays.name()) {
							assignment.ChangeStartDate(assignment.TheAssignment.StartDate__c.addDays(integer.valueOf(value)));
						}
						else {
							assignment.TheAssignment.StartDate__c = DateService.FromUTCString(string.valueof(value));
						}
					}
					else if (field.getType() == DisplayType.DATE) {
						assignment.TheAssignment.put(fieldName, DateService.FromUTCString(string.valueof(value)));
					} else if (fieldName == SObjectType.ActivityAssignment__c.Fields.EntryRemainingUsage__c.Name) {
						decimal val = decimal.valueOf(string.valueOf(value));

						if (actionEnum == QuickActions.IncreaseByValue.name()) {
							assignment.TheAssignment.EntryRemainingUsage__c = (assignment.TheAssignment.EntryRemainingUsage__c + val).setScale(2);
						} else if (actionEnum == QuickActions.DecreaseByValue.name()) {
							assignment.TheAssignment.EntryRemainingUsage__c = (assignment.TheAssignment.EntryRemainingUsage__c - val).setScale(2);
						} else {
							assignment.TheAssignment.EntryRemainingUsage__c = val;
						}
					} else if (field.getType() == DisplayType.INTEGER || field.getType() == DisplayType.LONG || field.getType() == DisplayType.DOUBLE || field.getType() == DisplayType.PERCENT || field.getType() == DisplayType.CURRENCY) {
						assignment.TheAssignment.put(fieldName, decimal.valueOf(string.valueOf(value)));
					} else {
						assignment.TheAssignment.put(fieldName, value);
					}

					assignment.CalculateUsagePattern();

					assignmentsToUpdate.add(assignment.TheAssignment);
				}
				catch(RecoverableException e)
				{
					result.Problems.add(new Problem(assignment.TheAssignment.Id, assignment.TheAssignment.Name, e.getMessage()));
				}
			}

			UnitOfWork.UpdateWithAccessCheck(assignmentsToUpdate);

			uow.CommitWork();

			//return assignments
			string fieldsetName = HelperService.Namespace + 'AssignmentKeyFields';

			list<string> fieldSetFields = new list<string>();

			if (KimbleOneSetting.ShowAssignmentMarginInDelivery && SObjectType.ActivityAssignment__c.Fields.TemporalForecastCostRate__c.IsAccessible()) fieldSetFields.add(SObjectType.ActivityAssignment__c.Fields.AssignmentMarginPercentage__c.Name);

			for (Schema.FieldSetMember f : SObjectType.ActivityAssignment__c.FieldSets.getMap().get(fieldsetName).getFields()) {
				Schema.DescribeFieldResult fld = HelperService.GetField(SObjectType.ActivityAssignment__c.Name, f.getFieldPath()).getDescribe();

				if (fld.isUpdateable()) fieldSetFields.add(f.getFieldPath());
			}

			string soql = GetAssignmentSelect(true);

			soql += ' WHERE Id IN :assignmentsToUpdate';

			string proposed = AssignmentCandidateStatusEnum.Proposed;

			result.TheAssignments = database.query(HelperService.ParseDBQuery(soql));
		}
		catch (Exception e)
		{
			Handle.ExceptionCaughtInService(e);
		}

		return result;
	}

	public class AssignmentCostRateChange {
		public string EffectiveDate {get; set;}
		public decimal Value {get; set;}
	}

	public class AssignmentProperties {
		public AssignmentProperties(list<Id> assignmentIds) {
			IsInvoiced = new set<Id>();
			IsWrittenOff = new set<Id>();
			IsInClosedPeriod = new set<Id>();

			for (AggregateResult r : [SELECT TimeEntry__r.ActivityAssignment__c Id FROM InvoiceLineItem__c WHERE TimeEntry__r.ActivityAssignment__c IN :assignmentIds GROUP BY TimeEntry__r.ActivityAssignment__c]) {
				IsInvoiced.add(AggregateResultTypeConverter.ToString(r, 'Id'));
			}

			for (AggregateResult r : [SELECT TimeEntry__r.ActivityAssignment__c Id FROM RevenueAdjustmentItem__c WHERE TimeEntry__r.ActivityAssignment__c IN :assignmentIds GROUP BY TimeEntry__r.ActivityAssignment__c]) {
				isWrittenOff.add(AggregateResultTypeConverter.ToString(r, 'Id'));
			}

			for (AggregateResult r : [SELECT ActivityAssignment__c Id FROM TimeEntry__c WHERE ActivityAssignment__c IN :assignmentIds AND TrackingTimePeriod__r.ForecastingTimePeriod__r.Status__c = :TimePeriodStatusEnum.ClosedId GROUP BY ActivityAssignment__c]) {
				isInClosedPeriod.add(AggregateResultTypeConverter.ToString(r, 'Id'));
			}
		}

		public set<Id> IsInvoiced { get; set; }
		public set<Id> IsWrittenOff { get; set; }
		public set<Id> IsInClosedPeriod { get; set; }
	}

	public class SaveAssignmentResult
	{
		public list<Problem> Problems {get; set;}
		public list<ActivityAssignment__c> TheAssignments {get; set;}
	}

	public class Problem
	{
		public Problem(Id i, string n, string mess)
		{
			Id = i;
			Name = n;
			Message = mess;
		}
		public Id Id {get; set;}
		public string Name {get; set;}
		public string Message {get; set;}
	}

	@RemoteAction
	public static list<Option> FindCriterionValues(string criterion, string searchTerm, list<Id> filterIds)
	{
		searchTerm = '%' + searchTerm + '%';

		string theQuery = string.format('SELECT {0}, {1} FROM ActivityAssignment__c WHERE (ResourcedActivityOperatedWith__r.DeliveryElement__r.DeliveryGroup__c IN :filterIds OR ResourcedActivityOperatedWith__c IN :filterIds' +
				' OR ResourcedActivityOperatedWith__r.DeliveryElement__r.DeliveryGroup__r.DeliveryProgram__c IN :filterIds' +
				' OR Resource__c IN :filterIds' +
				' OR Resource__r.BusinessUnit__c IN :filterIds) AND {1} like :searchTerm ORDER BY {1}', new string[]{String.escapeSingleQuotes(criterion), String.escapeSingleQuotes(criterion.replace('__c', '__r.Name'))});

		list<Option> options = new list<Option>();

		//for deduplication
		set<Id> optionIds = new set<Id>();

		for (sObject o : database.query(HelperService.ParseDBQuery(theQuery)))
		{
			string optionIdValue = string.valueOf(HelperService.GetFieldValue(o, criterion));
			if(!optionIds.contains(optionIdValue))
			{
				options.add(new Option(optionIdValue, string.valueOf(HelperService.GetFieldValue(o, criterion.replace('__c', '__r.Name')))));
				optionIds.add(optionIdValue);
			}
		}

		return options;
	}

	public class FilterCriterion
	{
		public FilterCriterion(string assignmentFieldPath, boolean value)
		{
			//Supported Types - String, TextArea, Reference, Boolean
			DescribeFieldResult fld = HelperService.GetField(SObjectType.ActivityAssignment__c.Name, assignmentFieldPath).getDescribe();

			DisplayType = fld.getType().name();

			if (fld.getType() == Schema.DisplayType.Reference)
			{
				Name = HelperService.GetObjectDescribeForObjectAndFieldPath(SObjectType.ActivityAssignment__c.Name, assignmentFieldPath).Label;
			}
			else
			{
				Name = fld.Label;
			}

			Criterion = assignmentFieldPath;
			DefaultValue = value;
		}

		public string Name {get; set;}
		public string Criterion {get; set;}
		public string DisplayType {get; set;}
		public boolean DefaultValue {get; set;}
	}
	
	public class ResourcedActivity
	{
		public ResourcedActivity(ResourcedActivity__c a)
		{
			Name = a.FullName__c;
			Id = a.Id;
			CanCreateAssignments = SObjectType.ActivityAssignment__c.createable && a.AllowNewRevenueCostItems__c == true;
		}

		public string Name {get; set;}
		public string Id {get; set;}
		public boolean CanCreateAssignments {get; set;}
	}
}