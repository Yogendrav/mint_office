class Attachment < ActiveRecord::Base
  default_scope :order => 'seq ASC'
  belongs_to  :employee

  belongs_to :owner, :polymorphic => true
  before_save :save_employee

  def save_employee
    self.employee = Person.current_person.employee unless self.employee
  end

  validates_presence_of :filepath, :on => :create, :message => "can't be blank"

  def self.for_me(obj,order = "")
    if order.blank?
      Attachment.all(:conditions=>{:owner_type => obj.class.to_s,
                                    :owner_id => obj.id},
                                    :order => "seq ASC")
    else
      Attachment.all(:conditions=>{:owner_type => obj.class.to_s,
                                  :owner_id => obj.id},
                                  :order => order)
    end
  end

  def self.maximum_seq_for_me(obj)
      Attachment.maximum(:seq, :conditions=>{:owner_type => obj.class.to_s,
                         :owner_id => obj.id})
  end

  def self.save_for(obj, employee, param)
    attachment = Attachment.new(param)
    attachment.save_for(obj, employee)
  end

  def save_for(obj, employee)
    self.owner_type = obj.class.to_s
    self.owner_id = obj.id
    unless employee
      employee = Employee.find(1)
    end
    self.employee = employee
    self.save
  end

  def image?
    if self.contenttype =~ /^image/
      true
    else
      false
    end
  end

  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end
  
  @@ucloud = UcloudStorage.new

  # ucloud part
  def uploaded_file=(upload_file)
    filename = base_part_of(upload_file.original_filename)
    self.original_filename = filename
    filename = Attachment.ucloud_filename(filename)

    # puts upload_file.content_type.chomp

    self.filepath = filename
    self.contenttype = upload_file.content_type.chomp

    @@ucloud.authorize unless @@ucloud.is_authorized?
    Attachment.upload_from_blob upload_file.read, filename
  end

  def self.upload_from_blob (blob, filename)
    @@ucloud.authorize unless @@ucloud.is_authorized?
    p filename
    @@ucloud.upload_blob blob, ENV['UCLOUD_BOX'], filename, 'image/png'
  end

  def self.ucloud_filename(filename)
    timestamp = DateTime.now.strftime("%y%m%d%H%M%S")
    ascii = ''
    if filename =~ %r{^[a-zA-Z0-9_\.\-]*$}
      ascii = filename
    else
      ascii = Digest::MD5.hexdigest(filename)
      # keep the extension if any
      ascii << $1 if filename =~ %r{(\.[a-zA-Z0-9]+)$}
    end

    @@ucloud.authorize unless @@ucloud.is_authorized?
    while Attachment.ucloud_exist? "#{timestamp}_#{ascii}"
      timestamp.succ!
    end
    "#{timestamp}_#{ascii}"
  end

  def self.ucloud_exist?(path)
    @@ucloud.authorize unless @@ucloud.is_authorized?
    @@ucloud.exist? ENV['UCLOUD_BOX'], path
  end

  def ucloud_file(path)
    @@ucloud.authorize unless @@ucloud.is_authorized?
    @@ucloud.get ENV['UCLOUD_BOX'], path do |f|
      return f
    end
  end

end
