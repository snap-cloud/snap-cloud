Feature: Project Submission
    As a student
    So that I can complete assignments
    I should be able to submit projects for an assignment

    As a teacher
    So that I can grade students
    I should be able to see projects they've submitted

Background:

    Given the following courses exist:
    | id | title |
    | 1234567 | testcourse |

    Given the following users exist:
    | username | email | password | password_confirmation |
    | teacher | teacher@cal.edu | password | password |
    | alice | alice@cal.edu | password | password |

    Given user "teacher@cal.edu" is enrolled as a teacher in "testcourse"
    Given user "alice@cal.edu" is enrolled as a student in "testcourse"

Scenario: Teacher creates assignment
    Given I am logged in as "teacher@cal.edu" with password "password"
    When I try to visit the edit page for "testcourse"
    And I click the create assignment button
    And I fill in everything to create a new assignment
    Then I should see that I created an assignment

Scenario: Teacher edits assignment
    Given everything this needs
    And I am visit the show page for that assignment
    And I click edit
    Then I should be on the assignment edit page
    Then I should see some stuff from that assignment
    And I change title to "blah"
    Then I click save
    Then I should beon the assignment show page for that assignment
    And I should see "blah"

Scenario: Teacher views assignments for a class
    Given everything this needs
    And I am on the course show page
    Then I should see all the assignments in my given

Scenario: Student views assignments for a class
    Given everything this needs
    And I am on the course show page
    Then I should see all assignments in my given

Scenario: Student submits project to an assignment from a course they are a part of
    Givens some assignments, projects I own, and a course i'm part of
    When I go to course page
    And I click some assignment
    Then I should be on the show assignment page
    Then I should be on the submission page
    And I change the dropdown to pick the project I want to submit
    And click submit

Scenario: Teacher views submissions for an assignment
    Given everything this needs
    When I go to the course page
    And pick an assignment
    Then I should be on the assignment view page
    And I should see all of the submissions for that assignment

Scenario: Student submits project to an assignment from a course they are not a part of
    Given everything this needs
    When I try to visit the submission page for an assignment
    Then I should be redirected to 401

Scenario: Submitting late assignments
    Given everything this needs
    When I am on the show assignment page
    And the assignment has ended
    Then I should not be able to submit a project to it