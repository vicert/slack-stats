== Slack Statistics

The purpose of this application is to colect users and number of messages for each user from Slack. The data is displayed in application home page. 
Application is colecting the data througth scheduled tasks. There are two implementation of the jobs:
 - Sidekiq
 - Delayed Job



* Ruby v2.1.5
* Rails v4.2.3
 
###System dependencies

In order to execute Sidekiq job, it is necesary to have Redis running on localhost:6379.

* Configuration
First, it is necessary to configure the Slack token by filling: 
```
config.x.slack_key
```
property for desired environment  ( development.rb, in production.rb or test.rb)


In order to set up which job to be executed (Sidekiq or DejayedJob) and time of execution it is necessary to update /config/initializers/task_scheduler.rb file:

Example where DelayedJob is active:

```ruby
    #It will execute the task every 55 min
    scheduler.every("55s") do
      Delayed::Job.enqueue SlackData::CollectSlackUsersJob.new("slack_users")
    end

    scheduler.every("50s") do
      Delayed::Job.enqueue SlackData::CollectSlackMessagesJob.new("slack_messages")
    end
```

Example where Sidekiq is active:

```ruby
    #It will execute task every 55 min
    scheduler.every("55s") do
      SlackWorker.perform_async(:slack)
    end
```



For DelayedJob worker to start, execute: <tt>rake jobs:work</tt> in console

For Sidekiq worker to start, execute: <tt>bundle exec sidekiq</tt>


* Database creation
	
	The application is using sqlite database.
	Execute <tt>rake db:migrate RAILS_ENV=<env></tt> to setup the database.
	

* Deployment instructions
	Execute <tt>rails s</tt> to start the application.
	
Following are important URLs:
 - localhost:3000 - Page with users and number of messages can be seen here
 - localhost:3000/sidekiq - Sidekiq queuq status
 - localhost:3000/delayed_job/overview - DelayedJob status
 - localhost:3000/job_scores - DelayedJob jobs statistics are displayed on this page