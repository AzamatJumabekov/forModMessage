# language: ru
Функционал: Тестирование администраторского интерфейса

  Сценарий: Удаление шаблона
    Допустим Я на главной странице админки
    Если Я перехожу по xpath по названию "SMS_OTP_RU" на "Удалить"
    То Я нажимаю на подтверждения удаления
    И Я не вижу "SMS_OTP_RU"