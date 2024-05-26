# frozen_string_literal: true

module Forums::Category
  OFFICIAL_COMMUNICATIONS = Forums::CategoryImpl.new("OFFICIAL_COMMUNICATIONS", "Official Communications", "Official news, announcements, and information posted by the Cytonic Staff Team.", [Forums::Topic::NEWS_AND_ANNOUCEMENTS, Forums::Topic::DEVLOGS])
  STAFF_CONTACT = Forums::CategoryImpl.new("STAFF_CONTACT", "Contact the Staff Team", "Submit an appeal or report bugs and exploits.", [Forums::Topic::PUNISHMENT_APPEALS, Forums::Topic::BUG_REPORTS])
  GAMES = Forums::CategoryImpl.new("GAMES", "Games", "Discuss the network's minigames", [Forums::Topic::GILDED_GORGE])
  NONE = Forums::CategoryImpl.new("NONE", "", "", [])
  # Add more when/if we need them


  def self.all
    [OFFICIAL_COMMUNICATIONS, STAFF_CONTACT, GAMES]
  end

  # Determines who is allowed to MAKE posts
  def self.is_allowed_to_make?(role)
    case role
    when Role::OWNER, Role::ADMIN
      [OFFICIAL_COMMUNICATIONS, STAFF_CONTACT, GAMES]
      else
      [STAFF_CONTACT, GAMES]
    end
  end

  def self.is_allowed_to_view?(role)
    case role
    when Role::OWNER, Role::ADMIN, Role::MODERATOR
      [OFFICIAL_COMMUNICATIONS, STAFF_CONTACT, GAMES]
    else
      [OFFICIAL_COMMUNICATIONS, GAMES]
    end
  end

  def self.find(id)
    case id
    when "OFFICIAL_COMMUNICATIONS"
      OFFICIAL_COMMUNICATIONS
    when "STAFF_CONTACT"
      STAFF_CONTACT
    when "GAMES"
      GAMES
    else
      NONE
    end
  end
end
