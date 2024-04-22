# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  has_many :team_profiles, dependent: :destroy
  has_many :teams, through: :team_profiles

  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true
  validates :avatar_url, presence: true

  def current_team
    team_profiles.find_by(role: %i[admin member])&.team
  end

  def belongs_to_any_team?
    team_profiles.where(role: %i[admin member]).exists?
  end

  def belongs_to_team?(team)
    team_profiles.where(team:, role: %i[admin member]).exists?
  end

  def invitations?
    team_profiles.where(role: :invitation).exists?
  end
end