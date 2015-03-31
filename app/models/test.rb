class Test < ActiveRecord::Base

  def self.none
     self.find_by(description: "None") || self.find_by(description: "none")
  end
  
  def self.informal
     self.find_by(description: "Informal") || self.find_by(description: "informal")
  end
  
  def self.formal
     self.find_by(description: "Formal") || self.find_by(description: "formal")
  end
  
end
