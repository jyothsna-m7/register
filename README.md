# README

To test:
========
1) Login User with user name

2) Start adding events

3) As UI is not intuitive, please look for red/ green flash messages on top of the page and note that times are UTC


How did you approach this challenge?
====================================
Login - Implemented some simple login without password as a just a gateway of User to sign-in to the system to register events

Clock-in/ Out 
- Made the assumption that only clock-out time can be edited. This is added to just bring in a different use case in the workflow.
- For more flexibility, any event can be deleted.


Test Cases
==========
- I have shielded all business logic with test cases, you would see controller tests if time permits


What schema design did you choose and why?
==========================================
 Chose Postgres relational DB with `one User has_many Events`
 Reason being, pretty sstraight forward use case of has_many relationship and no dynamic structure of the entities


If you were given another day to work on this, how would you spend it?
======================================================================
0) Better forms in the UI
1) More test cases like controllers, views
2) Deal with time zones
2) Proper login functionality
3) Beautiful UI


If you were given another month to work on this, how would you spend it?
======================================================================
1) Extend this to make User set `schedules`. Each User can have their pre-defined schedules, shifts etc
2) Lot to do UI side, making it intuitive, make some ajax calls to do these updates
3) Find User work times patterns to build some analytics around.
4) Have trail of edits made
5) Make it into API that can be used for any mobile app.

I would definitely want to change, but time did not permit:
===========================================================
1) Put Time zone to EDT on Heroku! You can see from my commits that I tried. But there is a discrepancy with Heroku server time. This is one best reason of using a docker for catching these kind of server setup issues.

2) Not happy using default_scope on order by events desc even though small app like this should not see any difference
3) write more test cases
