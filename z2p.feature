# ! From Zero2Production blog

Feature: Email Newsletter

    Scenario: Subscribe to Newsletter
        Given I am subscribed to the newsletter
        When new content is published on the blog
        Then I want to receive email updates

    Scenario: Unsubscribe to Newletter
        Given I am subscribed to the newsletter
        When I unsubscribe from the newsletter
        Then I should no longer receive email updates

    Scenario: Send email update to subscribers
        Given I am the blog auther
        When Start to type your When step here
