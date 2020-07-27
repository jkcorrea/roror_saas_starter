# frozen_string_literal: true

class UserMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def welcome_email(user, account)
    @user = user
    @account = account
    mail(
      to: email_with_name(user),
      subject: '[MantleDB] Welcome!'
    )
  end

  def billing_updated(user, account)
    @user = user
    @account = account
    mail(
      to: email_with_name(user),
      subject: '[MantleDB] Billing Updated'
    )
  end

  def invoice_paid(user, invoice)
    @user = user
    @invoice = invoice
    attachments["mantledb_invoice_#{@invoice.paid_at.strftime('%Y_%m_%d')}.pdf"] = {
      mime_type: 'application/pdf',
      content: invoice_path(@invoice, format: :pdf)
    }
    mail(
      to: email_with_name(user),
      subject: '[MantleDB] Payment Receipt'
    )
  end

  def invoice_failed(user, attempt_count, next_attempt_at)
    @user = user
    @attempt_count = attempt_count
    # ActiveJob serialization doesn't support DateTime,
    # so we send seconds since unix epoch and use that in the view.
    @next_attempt_at = next_attempt_at
    mail(
      to: email_with_name(user),
      subject: '[MantleDB] Payment Failed'
    )
  end

  def source_expiring(user, source)
    @user = user
    @source = source
    mail(
      to: email_with_name(user),
      subject: '[MantleDB] Your card is about to expire'
    )
  end

  def trial_will_end(user)
    @user = user
    mail(
      to: email_with_name(user),
      subject: '[MantleDB] Your trial is ending soon!'
    )
  end

  def invite_to_account(user, account)
    @user = user
    @account = account
    mail(
      to: email_with_name(user),
      subject: "[MantleDB] Invitation to #{@account.name}"
    )
  end

  private

    def email_with_name(user)
      %("#{user.name}" <#{user.email}>)
    end
end
