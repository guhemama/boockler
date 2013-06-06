class Book < ActiveRecord::Base
  attr_accessible :title, :status
  
  validates :title, presence: true
  validates :status, inclusion: { in: ['read', 'unread', 'reading', 'next'] }
  
  def self.find_by_status(status)
    where(status: status).order('title ASC')
  end
end
