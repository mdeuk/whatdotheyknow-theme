require_relative '../spec_helper'
require 'integration/alaveteli_dsl'

RSpec.describe 'report a data breach page' do
  it 'displays a form to the visitor' do
    visit help_report_a_data_breach_path

    expect(page).to have_css('input[name="data_breach_report[url]"]')
    expect(page).to have_css('textarea[name="data_breach_report[message]"]')
    expect(page).to have_css('input[name="data_breach_report[contact_email]"]')
    expect(page).to have_css('input[name="data_breach_report[dpo_contact_email]"]')
    expect(page).to have_css('input[name="data_breach_report[url]"]')
  end

  it 'validates the form' do
    visit help_report_a_data_breach_path

    click_button 'Send'

    expect(ActionMailer::Base.deliveries).to be_empty
    expect(page).to have_content('Please enter the URL of the page where the data breach occurred')
    expect(page).to have_content('Please describe the data breach')
    expect(page).to have_content('Please confirm whether you are reporting on behalf of the public body responsible for the data breach')
    expect(page).to have_content('Please include your email address')
  end

  it 'user can submit the form and the result is emailed' do
    visit help_report_a_data_breach_path
    fill_in 'data_breach_report[url]', with: 'https://example.com'
    fill_in 'data_breach_report[message]', with: 'A data breach occurred'
    fill_in 'data_breach_report[contact_email]', with: 'test@example.com'
    fill_in 'data_breach_report[dpo_contact_email]', with: 'dpo@example.com'
    choose 'data_breach_report[is_public_body]', option: 'true'
    check 'data_breach_report[special_category_or_criminal_offence_data]'
    click_button 'Send'

    expect(page).to have_content('Thank you for reporting a data breach')

    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.from).to eq(['do-not-reply-to-this-address@localhost'])
    expect(last_email.to).to eq(['postmaster@localhost'])
    expect(last_email.subject).to match(/New data breach report \[BR\/.*\]/)
    expect(last_email.header["Reply-To"].value).to eq('test@example.com')
    expect(last_email.body).to include('URL: https://example.com')
    expect(last_email.body).to include('Special category or criminal offence data: Yes')
    expect(last_email.body).to include('DPO email: dpo@example.com')
    expect(last_email.body).to include('Reporting on behalf of public body: Yes')
    expect(last_email.body).to include("Message:\nA data breach occurred")
    expect(last_email.body).to include("contact email: test@example.com")
  end

  context 'when user is logged in' do
    let(:user) { FactoryBot.create(:user) }

    around do |example|
      using_session(login(user, r: help_report_a_data_breach_path), &example)
    end

    it 'does not require email address' do
      expect(page).to have_no_field('data_breach_report[contact_email]')
      click_button 'Send'
      expect(page).to have_no_content('Please include your email address')
    end

    it 'includes logged in user in emailed report' do
      fill_in 'data_breach_report[url]', with: 'https://example.com'
      fill_in 'data_breach_report[message]', with: 'A data breach occurred'
      choose 'data_breach_report[is_public_body]', option: 'true'
      check 'data_breach_report[special_category_or_criminal_offence_data]'
      click_button 'Send'

      expect(page).to have_content('Thank you for reporting a data breach')

      user_url = show_user_url(user.url_name, host: 'test.host')
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.header["Reply-To"].value).to eq(user.email)
      expect(last_email.body).to include("logged in as user #{user_url}")
    end
  end
end
