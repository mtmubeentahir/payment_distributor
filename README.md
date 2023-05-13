# README

##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby 2.7.1
- Rails 7.0.4
- Sidekiq
- Redis

##### 1. Check out the repository

```bash
git clone https://github.com/mtmubeentahir/payment_distributor.git
```

##### 2. Create database.yml file

Copy the sample database-example.yml file and edit the database configuration as required.

```bash
cp config/database-example.yml config/database.yml
```

##### 3. Create and setup the database

Run the following commands to create and setup the database.
Seeding is important, it will take time to load data into database from the CSV

```ruby
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed   #this is important
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
sidekiq
redis
```

And now you can visit the site with the URL http://localhost:3000

