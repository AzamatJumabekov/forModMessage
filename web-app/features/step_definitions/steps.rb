When(/^Я на главной странице админки$/) do
  visit('http://127.0.0.1:9393/admin/index')
end

Then(/^Я вижу "([^"]*)"$/) do |arg|
  sleep 2
  expect(page).to have_content(arg)
  sleep 2
end

When(/^Я нажимаю на "([^"]*)"$/) do |arg|
  click_link(arg)
end

When(/^выбираю язык "([^"]*)"$/) do |lang|
  choose(lang)
end

When(/^выбираю тип шаблона "([^"]*)"$/) do |type|
  choose(type)
end

When(/^Я заполняю поле "([^"]*)" текстом "([^"]*)"$/) do |field, value|
  fill_in field, with:value
end

When(/^Я нажимаю на кнопку "([^"]*)"$/) do |arg|
  click_on(arg)
end


When(/^Я перехожу по xpath по названию "([^"]*)" на "([^"]*)"$/) do |arg, link|
  sleep 2
  find('tr', text: arg).click_on(link)
  sleep 2
end

Then(/^Я не вижу "([^"]*)"$/) do |arg|
  page.should have_no_content(arg)
end

When(/^Я нажимаю на подтверждения удаления$/) do
  page.driver.browser.switch_to.alert.accept
  sleep(0.5)
end

When(/^Я делаю скрол вниз$/) do
  page.execute_script "window.scrollBy(0,10000)"
end