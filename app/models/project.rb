class Project < ActiveRecord::Base
  belongs_to :user
  has_many :logs

  def spent(format = nil)
    spent = 0;
    self.logs.each_with_index do |log, i|
      spent += log.spent;
    end

    if format
      Log::format_timediff(spent, format)
    else
      spent
    end
  end

  def currentlog
    if !self.logs.last || !self.logs.last.finish
      self.logs.last
    else
      nil
    end
  end

end
