Feature: Editing a Course
	In order to know who I am teaching
	As a teacher
	I want to be able to see who is in my course

Background:
	Given a user is signed up as "test@example.com" with password "password"
	Given a user is signed up as "teacher@cal.edu" with password "password"

	Given the following courses exist:
	| id | title |
	| 1234567 | testcourse |

	Given the following users exist:
	| id | username | email | password | password_confirmation |
	| 100 | alice | alice@cal.edu | password | password |
	| 200 | bob | bob@cal.edu | password | password |
	| 300 | charlie | charlie@cal.edu | password | password |
	| 400 | diane | diane@cal.edu | password | password |
	| 500 | emily | emily@cal.edu | password | password |

	Given user "teacher@cal.edu" is enrolled as a teacher in "testcourse"
	Given user "alice@cal.edu" is enrolled as a student in "testcourse"
	Given user "bob@cal.edu" is enrolled as a student in "testcourse"

Scenario: Not logged in user tries to edit
When I try to visit the edit page for "testcourse"
Then I should see that I need to be logged in to edit

Scenario: User that not a teacher tries to edit
Given I am logged in as "test@example.com" with password "password"
When I try to visit the edit page for "testcourse"
Then I should see that I do not have permission to edit

Scenario: Teacher tries to edit
Given I am logged in as "teacher@cal.edu" with password "password"
When I try to visit the edit page for "testcourse"
Then I should see "alice@cal.edu" enrolled
Then I should see "bob@cal.edu" enrolled
Then I should not see "charlie@cal.edu" enrolled

Scenario: Teacher tries to drop a student
Given I am logged in as "teacher@cal.edu" with password "password"
When I try to visit the edit page for "testcourse"
And I check drop "alice@cal.edu"
And I submit the course edit
Then I should not see "alice@cal.edu" enrolled
Then I should see "bob@cal.edu" enrolled
Then I should not have any email errors

Scenario: Teacher tries to add a student
Given I am logged in as "teacher@cal.edu" with password "password"
When I try to visit the edit page for "testcourse"
And I try to add "charlie@cal.edu"
And I submit the course edit
Then I should see "alice@cal.edu" enrolled
Then I should see "bob@cal.edu" enrolled
Then I should see "charlie@cal.edu" enrolled
Then I should not have any email errors

Scenario: Teacher tries to add 2 students
Given I am logged in as "teacher@cal.edu" with password "password"
When I try to visit the edit page for "testcourse"
And I try to add "charlie@cal.edu" and "diane@cal.edu" at the same time
And I submit the course edit
Then I should see "alice@cal.edu" enrolled
Then I should see "bob@cal.edu" enrolled
Then I should see "charlie@cal.edu" enrolled
Then I should see "diane@cal.edu" enrolled
Then I should not have any email errors

Scenario: Teacher tries to add email that does not belong to a student to the course
Given I am logged in as "teacher@cal.edu" with password "password"
When I try to visit the edit page for "testcourse"
And I try to add "cardinal@stanfurd.edu"
And I submit the course edit
Then I should see "alice@cal.edu" enrolled
Then I should see "bob@cal.edu" enrolled
Then I should see "cardinal@stanfurd.edu" could not be found

Scenario: Teacher tries to add 2 incorrect emails and a correct one
Given I am logged in as "teacher@cal.edu" with password "password"
When I try to visit the edit page for "testcourse"
And I try to add "charlie@stanfurd.edu" and "diane@stanfurd.edu" at the same time
And I try to add "charlie@cal.edu"
And I submit the course edit
Then I should see "charlie@cal.edu"
Then I should see "charlie@stanfurd.edu" could not be found
Then I should see "diane@stanfurd.edu" could not be found
