# README

To test:
========
1) Login User with user name

2) Start adding events


How did you approach this challenge?
====================================
Login - Implemented some simple login without password as a just a gateway of User to sign-in to the system to register events

Clock-in/ Out 
- Made the assumption that only clock-out time can be edited, for just controlling edits only on one time. This is added to just bring in a different use case in the workflow.
- For more flexibility, any event can be deleted.

Test Cases
==========
- I have preserved the all business logic with test cases, you would see controller tests if time permits


What schema design did you choose and why?
==========================================
 Chose Postgres relational DB with `one User has_many Events`
 Reason being, pretty sstraight forward use case of has_many relationship and no dynamic structure of the entities


If you were given another day to work on this, how would you spend it?
======================================================================
1) More test cases like controllers
2) Deal with time zones
2) Proper login functionality
3) Beautiful UI

If you were given another day to work on this, how would you spend it?
======================================================================
1) Extend this to make User set `schedules`. Each User can have their pre-defined schedules, shifts
2) Lot to do UI side, making it intuitive
3) Find work patterns to build some analytics around.
4) Have trail of edits made
5) Make it into API that can be used for any mobile app.



