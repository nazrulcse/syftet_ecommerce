class ContactsController < BaseController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.save
        format.html { redirect_to root_path, notice: "Thanks. Your msg has been sent." }
      else
        format.html { render :new, notice: "Sorry. You should try again." }
      end
    end
  end


  private

  def contact_params
    if params[:contact]
      params[:contact].permit!
    else
      {}
    end
  end


end
