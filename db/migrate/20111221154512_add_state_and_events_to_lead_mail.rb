class AddStateAndEventsToLeadMail < ActiveRecord::Migration
  def change
    add_column :lead_mails, :state, :string, :default => "waiting"
    add_column :lead_mails, :opened, :boolean, :default => false
    add_column :lead_mails, :is_spam, :boolean, :default => false
    add_column :lead_mails, :unsubscribed, :boolean, :default => false
    add_column :lead_mails, :clicks, :text
  end
end
