# frozen_string_literal: true

# == Schema Information
#
# Table name: public.users
#
#  id                     :uuid             not null, primary key
#  email                  :string           not null
#  first_name             :string
#  last_name              :string
#  full_name              :string
#  encrypted_password     :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  super_admin            :boolean          default(FALSE), not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invitations_count      :integer          default(0), not null
#  invited_account_id     :uuid
#  invited_by_id          :uuid
#  discarded_at           :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider_type          :string
#  provider_id            :string
#
class User < ApplicationRecord
  include Discard::Model

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :accounts_users, autosave: true, dependent: :destroy, inverse_of: :user
  has_many :accounts, through: :accounts_users
  has_one_attached :avatar

  has_many :notifications_sent, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy, inverse_of: :sender
  has_many :notifications_received, class_name: "Notification", foreign_key: "recipient_id", dependent: :destroy, inverse_of: :recipient

  # NOTE for the sake of the example seen in app/models/notification.rb
  # You can remove this if users are not notifiables
  has_many :notifications, as: :notifiable, dependent: :destroy

  accepts_nested_attributes_for :accounts_users, reject_if: :all_blank

  validates :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true, length: { in: Devise.password_length }, if: :password_required?
  validates :first_name, presence: true, unless: :being_invited?
  validates :last_name, presence: true, unless: :being_invited?

  before_save :set_full_name

  scope :super_admins, -> { where(super_admin: true) }

  # Send mail through activejob
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def accounts_user(account)
    accounts_users.find_by(account: account)
  end

  def name
    full_name || email
  end

  # Allows features to be flipped for individuals
  def flipper_id
    "User;#{id}"
  end

  def being_invited!(account_id)
    self.invited_account_id = account_id
    @being_invited = true
  end

  def activated?
    invitation_accepted_at.present?
  end

  protected

    def password_required?
      (
        !persisted? ||
        password.present? ||
        password_confirmation.present?
      ) &&
        !being_invited?
    end

  private

    def set_full_name
      self.full_name = [first_name, last_name].join(' ').strip
      self.full_name = nil if full_name.empty?
    end

    def being_invited?
      !!@being_invited
    end
end
