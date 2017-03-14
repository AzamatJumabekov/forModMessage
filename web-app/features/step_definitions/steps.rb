When(/^Я на главной странице админки$/) do
  visit('http://127.0.0.1:9393/admin/index')
end

Then(/^Я вижу "([^"]*)"$/) do |arg|
  sleep 1
  expect(page).to have_content(arg)
end

When(/^Я нажимаю на "([^"]*)"$/) do |arg|
  click_link(arg)
end

When(/^Я заполняю поле "([^"]*)" текстом "([^"]*)"$/) do |field, value|
  fill_in field, with:value
end

When(/^Я нажимаю на  кнопку "([^"]*)"$/) do |arg|
  click_button(arg)
end


When(/^Я перехожу по xpath по названию "([^"]*)" на "([^"]*)"$/) do |arg, link|
  sleep 1
  find('tr', text: arg).click_on(link)
  sleep 1
end

When(/^Я не вижу "([^"]*)"$/) do |arg|
  page.should have_no_content(arg)
end

When(/^Я нажимаю на подтверждения удаления$/) do
  page.driver.browser.switch_to.alert.accept
  sleep(0.5)
end