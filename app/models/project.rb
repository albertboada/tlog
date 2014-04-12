class Project < ActiveRecord::Base
    default_scope :order => 'id ASC'

    belongs_to :user
    has_many :logs#, :order => 'id ASC'

    #
    #
    #
    def spent(format = nil)
        spent = 0
        self.logs.each_with_index do |log, i|
            spent += log.spent
        end

        if format
            Log::format_timediff(spent, format)
        else
            spent
        end
    end

    #
    #
    #
    def currentlog
        #if !self.logs.last || !self.logs.last.finish
        #  self.logs.last
        #else
        #  nil
        #end
        self.logs.where(:finish => nil).order('start ASC').last
    end

    #
    # In order to properly calculate a Project's Day Statistics, this function assumes that:
    #     - Project's Logs are sorted by `start` date, from oldest to newest
    #     - There is NO OVERLAPPING between Logs, which is ensured by Log model's validations
    #
    def daystats
        stats = []

        curr_date                      = nil
        curr_log                       = nil
        start_datetime_for_curr_date   = nil # important that we keep the exact start date of each day's first log
        total_spent_time_for_curr_date = 0

        self.logs.each_with_index do |log, i|
            curr_log = log # save log for outside the loop. when loop ends, should contain last log of all
            log_start_date = log.start.to_date

            if i == 0
                curr_date = log_start_date
                start_datetime_for_curr_date = log.start
            end

            #
            # If day-change, add the previously fully-calculated day-stats to the
            # `stats` array, before starting with the new-day stats calculations
            #
            if log_start_date != curr_date
                _log = Log.new
                _log.start  = start_datetime_for_curr_date
                _log.finish = _log.start + total_spent_time_for_curr_date

                stats << _log

                #
                # Init new day calculations
                #
                curr_date = log_start_date
                start_datetime_for_curr_date = log.start
                total_spent_time_for_curr_date = 0
            end

            #if date != log.finish.to_date #logs spanning more than 1 day
            #  _time = 0
            #  start_datetime  = log.start
            #  finish_datetime = log.start.to_date.to_time
            #  while finish_datetime != log.finish
            #    _time = finish_datetime - start_datetime
            #
            #    _log = Log.new
            #    _log.start  = start_datetime
            #    _log.finish = finish_datetime
            #
            #    stats << _log
            #
            #    start_datetime  = finish_datetime
            #    finish_datetime = finish_datetime + 1.days
            #    if finish_datetime > log.finish
            #      finish_datetime = log.finish
            #    end
            #  end
            #else
            total_spent_time_for_curr_date += log.spent
            #end
        end

        last_log = curr_log

        #
        # Add the last day-stats to the `stats` array
        #
        if self.logs
            _log = Log.new
            if last_log.finish
                _log.start  = start_datetime_for_curr_date
                _log.finish = _log.start + total_spent_time_for_curr_date
            else # hack if last log is still not finished so we can know the last day is still open
                now = Time.now.change(:usec => 0)
                _log.start  = now - total_spent_time_for_curr_date
            end
            stats << _log
        end

        stats
    end

end
