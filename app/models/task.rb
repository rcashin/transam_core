class Task < ActiveRecord::Base
  
  # Include the unique key mixin
  include UniqueKey

  #------------------------------------------------------------------------------
  # Overrides
  #------------------------------------------------------------------------------
  
  #require rails to use the asset key as the restful parameter. All URLS will be of the form
  # /task/{task_key}/...
  def to_param
    task_key
  end
  
  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------
  after_initialize  :set_defaults

  # Always generate a unique asset key before saving to the database
  before_validation(:on => :create) do
    generate_unique_key(:object_key)
  end
  
  # Associations
  belongs_to :from_organization, :class_name => "Organization", :foreign_key => "from_organization_id"  
  belongs_to :for_organization, :class_name => "Organization", :foreign_key => "for_organization_id"  
  belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"  
  belongs_to :assigned_to, :class_name => "User", :foreign_key => "assigned_to_user_id"  
  belongs_to :priority_type
  
  belongs_to :agency
  belongs_to :user
  belongs_to :to_user
  belongs_to :priority_type
  
  #attr_accessible :from_user_id, :from_organization_id, :priority_type_id, :for_organization_id, :assigned_to_user_id, :subject, :body, :complete_by

  # Validations on core attributes
  validates :object_key,            :presence => true, :uniqueness => true
  validates :from_user_id,          :presence => true
  validates :from_organization_id,  :presence => true
  validates :priority_type_id,      :presence => true
  validates :assigned_to_user_id,   :presence => true
  validates :for_organization_id,   :presence => true
  validates :subject,               :presence => true
  validates :body,                  :presence => true
  validates :complete_by,           :presence => true
   
  default_scope { order('complete_by') }

  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :object_key,
    :from_user_id,
    :from_organization_id, 
    :priority_type_id, 
    :assigned_to_user_id, 
    :for_organization_id,
    :subject,
    :body,
    :complete_by
  ]
  
  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------
    
  def self.allowable_params
    FORM_PARAMS
  end
      
  # Set resonable defaults for a new asset
  def set_defaults
  end    
      
end