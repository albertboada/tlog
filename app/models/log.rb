class Log < ActiveRecord::Base
  belongs_to :project

  def spent(format = nil)
    if self.finish
      finish = self.finish
    else
      finish = Time.now
    end

    puts 'Start'
    puts self.start.to_s
    puts 'Finish'
    puts finish.to_s

    seconds_diff = (start - finish).to_i.abs

    if format
      self.class.format_timediff(seconds_diff, format)
    else
      seconds_diff
    end
  end

  def self.format_timediff(seconds_diff, format)
    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    format.gsub! '%hours%', hours.to_s
    format.gsub! '%minutes%', minutes.to_s
    format.gsub! '%seconds%', seconds.to_s
  end

end