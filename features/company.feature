Feature: Company

	Scenario: Accept the end of month as pay base date
		Given I as admin edit company info
		When I set pay base date to the end of month
		Then I should get payment based on the date