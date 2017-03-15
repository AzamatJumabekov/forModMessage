# language: ru
Функционал: Тестирование администраторского интерфейса

Сценарий: Список шаблонов
  Допустим Я на главной странице админки
  И Я вижу "Шаблоны"

Сценарий: Создание шаблона:
  Допустим Я на главной странице админки
  Если Я нажимаю на "Создать шаблон"
  То Я вижу "Форма создания шаблона"
  И Я заполняю поле "name" текстом "OTP1"
  И выбираю язык "RU"
  И выбираю тип шаблона "SMS"
  И Я заполняю поле "template_attributes" текстом "OpenWallet. Код подтверждения - {{code}}. Никому не сообщайте этот код."
  И Я нажимаю на кнопку "Сохранить"
  И Я вижу "SMS_OTP1_RU"

Сценарий: Просмотр шаблона
  Допустим Я на главной странице админки
  Если Я перехожу по xpath по названию "SMS_OTP1_RU" на "Просмотр"
  И Я вижу "SMS_OTP1_RU"

Сценарий: Редактирование шаблона
  Допустим Я на главной странице админки
  Если Я перехожу по xpath по названию "SMS_OTP1_RU" на "Изменить"
  То Я вижу "Редактирование шаблона"
  И Я заполняю поле "name" текстом "OTP2"
  И Я нажимаю на кнопку "Сохранить"
  И Я вижу "SMS_OTP2_RU"

  Если Я перехожу по xpath по названию "SMS_OTP2_RU" на "Изменить"
  То Я вижу "Редактирование шаблона"
  И Я заполняю поле "template_attributes" текстом "OpenWallet. Код подтверждения - {{code}}. Никому не сообщайте этот код. Необходимо подтвердить код сообщения как можно раньше"
  И Я нажимаю на кнопку "Сохранить"
  И Я вижу "SMS_OTP2_RU"

  Если Я перехожу по xpath по названию "SMS_OTP2_RU" на "Изменить"
  То Я вижу "Редактирование шаблона"
  И Я заполняю поле "name" текстом "OTP3"
  И Я заполняю поле "template_attributes" текстом "OpenWallet. Код подтверждения - {{code}}. Никому не сообщайте этот код."
  И Я нажимаю на кнопку "Сохранить"
  И Я вижу "SMS_OTP3_RU"

Сценарий: Удаление шаблона
  Допустим Я на главной странице админки
  Если Я перехожу по xpath по названию "SMS_OTP3_RU" на "Удалить"
  То Я нажимаю на подтверждения удаления
  И Я не вижу "SMS_OTP3_RU"