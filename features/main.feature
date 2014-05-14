Feature: Main

	Scenario: Display difference between half-day and full day in terms of vacation
		Given there are half-day vacations on this month
		When I visit main page
		Then I should distinguish half-day vacation from full-day vacations