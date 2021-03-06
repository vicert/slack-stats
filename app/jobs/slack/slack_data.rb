module SlackData
  
  #job for collecting users from Slack
  #retrieves users from Slack and stores them into database
  CollectSlackUsersJob = Struct.new(:job_name) do
    
    def perform
      users = StatHelper::fetch_users_from_slack
      StatHelper::insert_users(users)
    end 
    
    def enqueue(job)
      job.save!
      js = JobScore.find_or_initialize_by(job_id: job.id)
      js.update(job_id: job.id, name: job.handler, start_time: Time.now)
    end
    
    def success(job)
      JobScoresHelper::update_job_status(job.id, "success")
    end
    
    def error(job, exception)
      JobScoresHelper::update_job_status(job.id, "error")
    end
    
    def failure(job)
      JobScoresHelper::update_job_status(job.id, "failure")
    end
     
  end
  
  #job for collecting users messages from Slack
  #retrieves messages for each users from Slack and then stores the number of messages into database
  CollectSlackMessagesJob = Struct.new(:job_name) do
    
    def perform
      StatHelper::update_users_messages
    end
    
    def enqueue(job)
      job.save!
      js = JobScore.find_or_initialize_by(job_id: job.id)
      js.update(job_id: job.id, name: job.handler, start_time: Time.now)
    end
    
    def success(job)
      JobScoresHelper::update_job_status(job.id, "success")
    end
    
    def error(job, exception)
      JobScoresHelper::update_job_status(job.id, "error")
    end
    
    def failure(job)
      JobScoresHelper::update_job_status(job.id, "failure")
    end
    
  end
  
end