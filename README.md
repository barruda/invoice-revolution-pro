# README

Welcome to Invoice Revolution Pro. You have two options to start the development environment, with docker-compose or just using a mysql docker container.

With docker-compose installed, run the following command and wait for the migrations to be run and the puma server to be started
```
docker-compose up
```

Without docker-compose
---

0) Install ruby(rbenv or rvm) and run
```
bundle install 
```

1) install mysql (or mariadb) client libs - as needed, maybe optional and change according to your OS
```
sudo apt-get install libmariadb-dev
```

2) Run mysql docker container
```
docker run -p 3306:3306 --name mysql_80 -e MYSQL_ROOT_PASSWORD=password -d mysql:8 mysqld --default-authentication-plugin=mysql_native_password
```

3) Run create db rails task
```
rails db:create
```

4) Run migrations
```
rails db:migrate
```

5) Run application server
``` 
 rails s -b 0.0.0.0 -p 3000
```

6) Use postman(docs folder) supplied collection to use the application, remember to first create a user, then login and use the returned
authentication token on following API calls headers.

---
*business assumptions:*

- users can update any invoice (should be improved)
- a user can report only full payments (I assumed that because all the entities had specific details, but not payments) and to make the scope narrower
---

*tech decisions and assumptions:*

- added a service layer for business rules,  but skipping it on very simple use cases for clarity (but should be respected as the application grows for data manipulation/validation/rules  to preserve controller tier)
- currency is handled as an integer, considering last 2 digits as decimal (Ex.:  1387 = $13,87)
- Used JWT for implementing authentication(for security and session expiration)
- The  user creation is opened (should not be available public as endpoint at least)
- No controllers spec tests, but instead used requests specs as advised by rspec and rails teams. (which tests routes, controller and e2e features)


---
*Roadmap suggested:*

- Throw in more tests, I've given some coverage, but limited to time frame
- Make some refactoring on structure (got a little messy on the development)
- Fix bugs (already found some on review process, but I will not point to you of course :)
- Add factorybot  / shoulda matchers / simplecov gems
- Production Environment (database) and add configurations
- create API errorcodes protocol
- cors enabling for SPA
- Improve logging and troubleshooting (adding more meaningful messages, maybe a JSON format for a ELK stack and timeseries monitoring like Prometheus)
- setup CI/CD (with rubocop/ tests and image generation)
- API documentation (maybe openapi)
