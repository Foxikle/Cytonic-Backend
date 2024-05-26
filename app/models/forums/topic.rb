# frozen_string_literal: true
#
module Forums::Topic
  # Official Communications
  NEWS_AND_ANNOUCEMENTS = Forums::TopicImpl.new("NEWS_AND_ANNOUCEMENTS", "News and Annoucements")
  DEVLOGS = Forums::TopicImpl.new("DEVLOGS", "Development Diaries")

  ## Staff contact
  PUNISHMENT_APPEALS = Forums::TopicImpl.new("PUNISHMENT_APPEALS", "Mute & Ban Appeals")
  BUG_REPORTS = Forums::TopicImpl.new("BUG_REPORTS", "Bug & Exploit Reports")

  ## Games
  GILDED_GORGE = Forums::TopicImpl.new("GILDED_GORGE", "Gilded Gorge")

  ## Placeholder
  NONE = Forums::TopicImpl.new("NONE", "")

  def self.is_allowed_to_make?(role)
    case role
    when Role::OWNER, Role::ADMIN
      [NEWS_AND_ANNOUCEMENTS, DEVLOGS, BUG_REPORTS, PUNISHMENT_APPEALS, GILDED_GORGE]
    else
      [BUG_REPORTS, PUNISHMENT_APPEALS, GILDED_GORGE]
    end
  end

  def self.is_allowed_to_view?(role)
    case role
    when Role::OWNER, Role::ADMIN, Role::MODERATOR
      [NEWS_AND_ANNOUCEMENTS, DEVLOGS, BUG_REPORTS, PUNISHMENT_APPEALS, GILDED_GORGE]
    else
      [NEWS_AND_ANNOUCEMENTS, DEVLOGS, GILDED_GORGE]
    end
  end

  def self.is_private?(topic)
    case topic
    when BUG_REPORTS, PUNISHMENT_APPEALS
      true
    else
      false
    end
  end

  def self.find(id)
    case id
    when "NEWS_AND_ANNOUCEMENTS"
      NEWS_AND_ANNOUCEMENTS
    when "DEVLOGS"
      DEVLOGS
    when "PUNISHMENT_APPEALS"
      PUNISHMENT_APPEALS
    when "BUG_REPORTS"
      BUG_REPORTS
    when "GILDED_GORGE"
      GILDED_GORGE
    else
      NONE
    end
  end

end
