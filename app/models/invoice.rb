# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id         :uuid             not null, primary key
#  stripe_id  :string
#  amount     :integer
#  currency   :string
#  number     :string
#  paid_at    :datetime
#  lines      :text
#  account_id :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# TODO This is formatting data for presentation in the model and violating MVC
# Ditch the reciepts gem and just do a pdf view?
class Invoice < ApplicationRecord
  include CurrencyHelper
  belongs_to :account
  serialize :lines, JSON

  def receipt
    Receipts::Receipt.new(
      id: id,
      product: "MantleDB - Business Plan",
      company: {
        name: "MantleDB Inc.",
        address: "123 Example St\nSuite 42\nNew York City, NY 10012",
        email: "billing@mantledb.com",
        logo: Rails.root.join("app", "assets", "images", "logo.png")
      },
      line_items: [
        ["Date",          formatted_invoice_date],
        ["Account Owner", "#{account.owner_au.try(:name)} (#{account.owner_au.try(:email)})"],
        ["Product",       "Business Plan"],
        ["Amount",        formatted_amount(amount, currency)],
        ["Charged to",    formatted_card]
      ]
    )
  end

  # This assumes that the card charged is the one currently on file
  # That will always be the case unless the account manages to change their card
  # and get invoiced before the stripe webhook updates their account (super unlikely).
  def formatted_card
    "#{account.card_type} (**** **** **** #{account.card_last4})"
  end

  def cost
    formatted_amount(amount, currency)
  end

  def formatted_invoice_date
    paid_at.strftime("%l:%M %P, %B %d, %Y") << " UTC"
  end
end
