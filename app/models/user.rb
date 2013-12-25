class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :recoverable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :projects

  def spent(format = nil)
    spent = 0;
    self.projects.each_with_index do |project, i|
      spent += project.spent;
    end

    if format
      Log::format_timediff(spent, format)
    else
      spent
    end
  end

end
