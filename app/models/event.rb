class Event < ApplicationRecord
  has_many :attendees
  has_many :users, through: :attendees
  belongs_to :creator, class_name: "User"

  #creatorを参加者に含めない
  def attendees_for(user)
    if user.present?
      # 参加者リストから自分と投稿者を除いた参加者リストを返す
      return attendees.where.not(user: [user, creator])
    else
      return attendees
    end
  end

  #検索用
  def self.search_content(content, method)
    if method == "perfect"
      where(event_name: content)
    elsif method == "partial"
      where("event_name LIKE ?", "%#{content}%")
    else
      all
    end
  end
  #利用停止のUserの投稿は閲覧不可に
  scope :by_active_users, -> { joins(:users).where(users: { user_status: 0 }) }
  scope :upcoming, -> { where("date >= ?", Time.zone.now).order(date: :asc) }
  scope :visible, -> { by_active_users.upcoming }
end
