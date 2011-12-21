class HooksController < ApplicationController

  EVENTS = [:processed, :deferred, :delivered, :open, :click, :bounce, :dropped, :spamreport, :unsubscribe]

  # Dispatches the event's hook per the :event param or fail
  def dispatcher
    @event = params[:event]
    @email = params[:email]

    if @event && @email && EVENTS.include?(@event.to_sym)
  		self.send(@event)
    else
      render :nothing => true, :status => 422 and return
    end
  end

  # Updates the LeadMail with the incoming state
  def set_state
    @lead_mail = LeadMail.find_by_email(@email)
    if @lead_mail
      @lead_mail.state = @event
      @lead_mail.save!

      render :nothing => true, :status => 200 and return
    end

    render :nothing => true, :status => 404
  end

  # Updates the LeadMail as opened
  def open
    @lead_mail = LeadMail.find_by_email(@email)
    if @lead_mail
      @lead_mail.opened = true
      @lead_mail.save!

      render :nothing => true, :status => 200 and return
    end

    render :nothing => true, :status => 404
  end

  # Updates the LeadMail as is_spam
  def spamreport
    @lead_mail = LeadMail.find_by_email(@email)
    if @lead_mail
      @lead_mail.is_spam = true
      @lead_mail.save!

      render :nothing => true, :status => 200 and return
    end

    render :nothing => true, :status => 404
  end

  # Updates the LeadMail as unsubscribed
  def unsubscribe
    @lead_mail = LeadMail.find_by_email(@email)
    if @lead_mail
      @lead_mail.unsubscribed = true
      @lead_mail.save!

      render :nothing => true, :status => 200 and return
    end

    render :nothing => true, :status => 404
  end
  
  # Updates the LeadMail with the incoming url click
  def click
    @lead_mail = LeadMail.find_by_email(@email)
    if params[:url] && @lead_mail
      @lead_mail.clicks = "#{@lead_mail.clicks}#{params[:url]}\n"
      @lead_mail.save!

      render :nothing => true, :status => 200 and return
    end

    render :nothing => true, :status => 404
  end
  
  # TODO: Create specialized hanlders for deferred, delivered, dropped and bounce. 
  #  Use it to save especific data Eg: Bounce has a MTA reason. by MA
  alias  :processed :set_state
  alias  :deferred :set_state
  alias  :delivered :set_state
  alias  :dropped :set_state
  alias  :bounce :set_state
end