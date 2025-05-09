# frozen_string_literal: true

class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user
  enum :role, owner: "owner", member: "member"
end
