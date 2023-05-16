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
bundle exec rake db:seed   #this is important, it might take 3 to 5 minutes while processing the CSV
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
sidekiq
redis
```

And now you can visit the site with the URL http://localhost:3000



### UI Walk Through
This page shows the list of merchants. URL http://localhost:3000/merchants
![Screenshot 2023-05-16 at 4 46 24 PM](https://github.com/mtmubeentahir/payment_distributor/assets/20140757/76844fdb-645a-4214-acf5-40a742f85323)

This page shows the list of orders. URL http://localhost:3000/orders
![Screenshot 2023-05-16 at 5 47 31 PM](https://github.com/mtmubeentahir/payment_distributor/assets/20140757/a4f297f8-3605-4c47-bf3b-2fc8388e017f)


This page shows the Disbursment Report. http://localhost:3000/
![Screenshot 2023-05-16 at 4 46 14 PM](https://github.com/mtmubeentahir/payment_distributor/assets/20140757/808ebb6c-387c-4dbd-86ea-81ead3142b13)





