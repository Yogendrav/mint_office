Feature: HR

	Scenario: Successful addition of a new contact
		Given I as admin need to add a new employee to system
		When I enter name for the contact
		Then I should get the added contact

	Scenario: Successful addition of a new account
		Given I as admin need to add a new employee to system
		When I enter ID and password for the account
		Then I should get the added account

	Scenario: Successful addition of a new employee
		Given I already have added a contact and an account for the employee
		When I choose the contact and the account for the employee
		And I enter start date of employment
		Then I should get the added employee

	Scenario: Successful addition of a new employee
		Given I need to already have added a contact and an account for the employee
		When I choose the contact and the account for the employee
		And I enter start date of employment
		Then I should get the added employee