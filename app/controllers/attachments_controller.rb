# require 'RMagick'

class AttachmentsController < ApplicationController
  protect_from_forgery :except => [:save]

  def index
    @attachments = Attachment.paginate(:page => params[:page], :per_page => 20).order('created_at DESC')
  end

  def show
    @attachment = Attachment.find(params[:id])
    session[:attachments] = [@attachment.id]
  end

  def download
    @attachment = Attachment.find(params[:id])
    unless session[:attachments] && (session[:attachments].include? (@attachment.id))
      flash[:notice] = I18n.t("permissions.permission_denied")
      redirect_to root_path
      return
    end
    
    send_data @attachment.ucloud_file, filename: (@attachment.original_filename.blank? ? @attachment.filepath : @attachment.original_filename),
      type: @attachment.contenttype,
      disposition: 'attachment'
  end
  
  def picture
    @attachment = Attachment.find(params[:id])

    unless session[:attachments] && (session[:attachments].include? (@attachment.id))
      flash[:notice] = I18n.t("permissions.permission_denied")
      redirect_to root_path
      return
    end

    path = @attachment.filepath

    if params[:w] && params[:h]
      width = params[:w].to_i
      height = params[:h].to_i

      path = "#{width}x#{height}/#{@attachment.id}"
      contentType = 'image/png'

      unless Attachment.ucloud_exist? path
        img = Magick::Image::from_blob(@attachment.ucloud_file(@attachment.filepath)).first
        img.format = "PNG"
        img.auto_orient!
        blob = img.resize_to_fit(width,height).to_blob { self.quality = 90 }
        Attachment.upload_from_blob blob, path
      end
    end
    contentType ||= @attachment.contenttype =~ /^image/ ? @attachment.contenttype : 'image/png'
    blob ||= @attachment.ucloud_file path
    send_data blob, filename: path,
      type: contentType,
      # :disposition => (@attachment.contenttype =~ /^image/ ? 'inline' : 'attachment')
      disposition: 'inline'
  end

  def new
    @attachment = Attachment.new
  end

  def save
    @attachment = Attachment.new(params[:attachment])

    if current_employee
      @attachment.employee = current_employee
    else
      @attachment.employee = Employee.find(1)
    end

    if @attachment.save
      redirect_to :attachments, notice: I18n.t("common.messages.created", :model => Attachment.model_name.human)
    else
      render 'new'
    end
  end

  def edit
    @attachment = Attachment.find(params[:id])
  end

  def create
    @attachment = Attachment.new(params[:attachment])
    @attachment.save!
    redirect_to @attachment
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    @attachment = Attachment.find(params[:id])
    @attachment.update_attributes!(params[:attachment])
    redirect_to @attachment
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to :attachments
  end

  def delete
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to :back
  end

  def changeseq
    @attachment = Attachment.find(params[:id])
    tmp = 0
    unless params[:to].to_i == 0
      @a2 = Attachment.find(params[:to].to_i)
      logger.info "attachment 1 = #{@attachment.seq}, 2 = #{@a2.seq}"

      if @attachment.seq.blank?
        @attachment.seq = @attachment.id + 1#@a2.id
      end
      if @a2.seq.blank?
        @a2.seq = @a2.id + 1
      end

      tmp = @a2.seq
      @a2.seq = @attachment.seq
      @attachment.seq = tmp

      @a2.save
      @attachment.save
    end

    redirect_to :back

  end
end
