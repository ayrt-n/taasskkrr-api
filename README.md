# To-Do List Rails API

## Summary
After reaching the end of the React section of The Odin Project (https://www.theodinproject.com/), I wanted to take an old JavaScript project that I had worked on and update it to use a Rails JSON API backend and React frontend (https://github.com/ayrt-n/to-do-list-client).

The application is a to-do list web application, which allows users to create, read, update, and delete projects and associated to-do lists. Through the web application, users can view tasks associated with projects, view all tasks for the current day, or view all upcoming tasks. 

The application uses Json Web Token (JWT) and a custom implementation of JWT-Devise to manage user permissions.

This repo is for the Rails backend portion of the project.

## Set up
### Using Web Browser (Recommended)

The best way to view the project is live on Github at https://ayrt-n.github.io/to-do-list-client/

Please note that it may take 30-45 seconds for the Heroku dyno to start up if the application has been inactive for awhile.

![homepage](/public/homepage.png)

### Using Local Machine
If you would like to run the web app on your local machine you will first need to install [Ruby](https://guides.rubyonrails.org/v5.0/getting_started.html), [Rails](https://guides.rubyonrails.org/v5.0/getting_started.html), and [PostgreSQL](https://medium.com/geekculture/postgresql-rails-and-macos-16248ddcc8ba).

With all of those installed, you will need to clone this repo along with the frontend (https://github.com/ayrt-n/taasskkrr-api).

Once you have this repo cloned, navigate to the root directory and create and set up the database by running

```rails db:create db:migrate```

Once that is finished, you can start the backend API server by running

```rails s -p 3001```

With the backend going, you can either start making API requests using a service like Postman or curl in the terminal, or start up the React frontend by following the instructions within the associated repo (https://github.com/ayrt-n/taasskkrr).

## Overview
This project provided a solid opportunity to combine everything that I have learned through The Odin Project. Generally, it was a great opportunity to start building full stack web applications which utilized a Rails backend and React frontend to build beautiful, responsive, and interactive user interfaces with a persistent backend API.

From a Rails API point of view the project offered a solid refresher on a number of Rails specific concepts and experience building a Rails API-only application and then integrating that functionality with a separate React frontend user interface.

### Database
The database currently consists of five separate but related tables as follows:

![data schema](/public/db-schema.png)

Users:
- Users consist of a number of variable related to the user details (e.g., email and password), as well as confirmation and authentication tokens used when confirming the users email or resetting their password
- A User has_many (0,..,n) Projects
- A User has_many (0,..,n) Tasks through Projects

Projects:
- Users are able to create projects which are used to organize and split up tasks by either including tasks within a project, or splitting it up further into sections
- Projects consist of a few variables related to an individual Project, including a Title, as well as a flag for whether or not this project is the default "Inbox" project created for all users
- A Project has_many (0,..,n) Sections and Tasks
- A Project belong_to (via a foreign key) a User

Sections:
- Sections are a way of breaking up projects into smaller components and organizing tasks within those sections
- Sections consist of a few variables related to the section, including a Title
- A Section has_many (0,..,n) Tasks
- A Section belongs_to (via a foreign key) a Project

Tasks:
- Tasks are used to keep track of things the user needs to do (the main purpose of a to-do list!)
- Tasks consist of a number of variables related to the task, including: the title, a description, a due date, the priority, and a flag as to whether the task has been completed
- A Task belongs_to (via a foreign key, optional) a Section
- A Task belongs_to (via a foreign key, not optional) a Project

JWTDenylist:
- The JWT Denylist is used to keep track of JWT tokens which are expired/revoked
- The denylist consists of the JTI, which uniquely identifies the JWT token, and an expired_at variable used to help clean up stale tokens

### Additional Functionality / Lessons Learned
Some interesting features and lessons learned include:
- JWT Authentication/Authorization in API applications: The backend uses the Devise and devise-jwt gem to implement JWT authentication and authorization. Once a user is successfully authenticated through a login attempt, the sessions controller will return a JWT with header and payload including the user id, email, and JWT expiration, as well as a signature used to validate the JWT (created by base-64 encoding the header and payload, concatenating the two together, and then running the result through a cryptographic algorithm (HMAC-SHA256) with a secret key). The JWT is then included within the header of all API requests and used to validate the user request

