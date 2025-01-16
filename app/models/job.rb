class Job < ApplicationRecord
  belongs_to :account
  has_many :applicants, dependent: :destroy
  has_rich_text :description
  validates_presence_of :title, :status, :job_type, :location

  FILTER_PARAMS = %i[query status sort].freeze

  enum :status, {
    draft: "draft",
    open: "open",
    closed: "closed"
  }

  enum :job_type, {
    full_time: "full_time",
    part_time: "part_time"
  }

  scope :for_account, ->(account_id) do
    where(account_id: account_id)
  end

  scope :for_status, ->(status) do
    status.present? ? where(status: status) : all
  end

  scope :search_by_title, ->(query) do
    query.present? ? where("title like ?", "%#{query}%") : all
  end

  scope :sorted, ->(selection) do
    selection.present? ? apply_sort(selection) : all
  end

  def self.filter(filters)
    search_by_title(filters[:query]).for_status(filters[:status]).sorted(filters[:sort])
  end

  def self.apply_sort(selection)
    return if selection.blank?
    sort, direction = selection.split("-")
    order("#{sort} #{direction}")
  end
end
