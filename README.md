# Описание проекта
   - **Название:** Punk Market
   - **Цель приложения:** Создание платформы для студентов, позволяющей покупать, продавать и находить уникальные товары.
   - **Основные функции:** 
     - Создание аккаунта и авторизация.
     - Просмотр каталога товаров.
     - Добавление товаров для продажи.
     - Система поиска. 
     - Взаимодействие пользователей (чаты, отзывы) (будет интегрировано в следующей версии приложения).
# Архитектура проекта
  - Используется клиент-серверная архитектура.
   - Основные компоненты:
     - **Frontend:** мобильное приложение (Android), реализованное на Dart с использованием мультиплатформенного фреймворка Flutter.
     - **Backend:** серверная часть реализована на Java с использованием SpringBoot, веб сервер реализован с помощью tomcat, API документировано через Swagger, ORM - Hebirnate, оболчка над Hebirnate - SpringJpa.
     - **База данных:** реляционная - Postgres.
     - **Валидация данных:** частично реализована на уровне frontend и backend.
   - CI/CD: автоматическая сборка, тестирование и развертывание с помощью GitHub. 
# Основные пользовательские пути
## 01. Путь: Регистрация пользователя  

### Текстовое описание:  
1. Пользователь открывает приложение и нажимает "Регистрация".  
2. Заполняет форму (имя, пароль, номер телефона, телеграм ID).  
3. Загружает фото профиля
4. Нажимает "Зарегистрироваться".  
5. Получает подтверждение успешной регистрации.  

### CJM: Регистрация пользователя  

| Этап                   | Действие пользователя          | Эмоция/Ожидание                 | Возможные улучшения                   |
| ---------------------- | ------------------------------ | ------------------------------- | ------------------------------------- |
| Открытие регистрации   | Выбирает "Регистрация".        | Ожидание простоты процесса.     | Короткая форма с минимальными полями. |
| Заполнение формы       | Вводит данные.                 | Надежда на правильность ввода.  | Валидация данных в реальном времени.  |
| Завершение регистрации | Нажимает "Зарегистрироваться". | Уверенность, радость от успеха. | Уведомление о завершении.             |
## 02. Путь: Авторизация пользователя  

### Текстовое описание:  
1. Пользователь открывает приложение и вводит номер телефона и пароль в форму авторизации.  
2. Отмечает кнопку валидации
3. Нажимает "Войти".  
4. В случае успешной авторизации попадает на главную страницу приложения.  

### CJM: Авторизация пользователя  

| Этап                 | Действие пользователя              | Эмоция/Ожидание                    | Возможные улучшения                  |
| -------------------- | ---------------------------------- | ---------------------------------- | ------------------------------------ |
| Открытие формы входа | Переходит на экран авторизации.    | Уверенность в безопасности данных. | Добавить кнопку "Сохранить пароль".  |
| Ввод данных          | Заполняет номер телефона и пароль. | Сомнение в корректности данных.    | Уведомление при неправильных данных. |
| Завершение входа     | Нажимает "Войти".                  | Удовлетворение, уверенность.       | Подтверждение успешного входа.       |

## 03. Путь: Добавление товара на продажу  

### Текстовое описание:  
1. Пользователь заходит в раздел "Добавить товар".  
2. Указывает название, описание, цену и категорию товара.
3. Загружает фото (от 1 до 10).   
4. Нажимает "Создать товар", и товар появляется в списке "Мои товары".  

### CJM: Добавление товара на продажу  

| Этап              | Действие пользователя                    | Эмоция/Ожидание                       | Возможные улучшения               |
| ----------------- | ---------------------------------------- | ------------------------------------- | --------------------------------- |
| Запуск добавления | Пользователь заходит в раздел.           | Интерес, ожидание удобства.           | Пошаговый процесс с подсказками.  |
| Ввод данных       | Заполняет название, категорию, описание. | Может запутаться в опциях.            | Упрощённый интерфейс с примерами. |
| Сохранение товара | Нажимает "Создать".                      | Удовлетворение, готовность продавать. | Уведомление о публикации.         |
## 04. Путь: Редактирование своего товара  

### Текстовое описание:  
1. Пользователь открывает раздел "Мои товары".  
2. Нажимает кнопку "Редактировать" на карточке нужного товара.  
3. Вносит изменения (например, цену, описание или фото).  
4. Сохраняет изменения, после чего они отображаются в списке.  

### CJM: Редактирование своего товара  

| Этап                 | Действие пользователя           | Эмоция/Ожидание                     | Возможные улучшения                  |
| -------------------- | ------------------------------- | ----------------------------------- | ------------------------------------ |
| Поиск товара         | Пользователь выбирает товар.    | Удобство, быстрая навигация.        | Добавить поиск внутри "Мои товары".  |
| Редактирование       | Меняет описание, фото или цену. | Надежда на лёгкость редактирования. | Возможность предпросмотра изменений. |
| Сохранение изменений | Нажимает "Сохранить".           | Удовлетворение, уверенность.        | Подтверждение успешного сохранения.  |

## 05. Путь: Управление товарами  

#### Текстовое описание:  
1. Пользователь переходит в раздел "Мои товары".  
2. Выбирает необходимый товар из списка.  
3. Использует доступные функции:  
   - Редактировать: изменяет информацию о товаре.  
   - Удалить: убирает товар из списка.  
   - Забронировать: временно скрывает товар от покупателей.  
4. Сохраняет изменения, которые применяются мгновенно.  

#### CJM: Управление товарами  

| Этап                   | Действие пользователя               | Эмоция/Ожидание                  | Возможные улучшения              |
|-------------------------|-------------------------------------|----------------------------------|----------------------------------|
| Открытие списка товаров | Открывает раздел "Мои товары".    | Удобство доступа.                | Увеличить видимость опций управления. |
| Выбор действия          | Выбирает "Редактировать", "Удалить" или "Забронировать". | Сомнение, всё ли выполнится правильно. | Добавить подтверждение действия. |
| Сохранение изменений    | Завершает редактирование.          | Уверенность в результате.        | Уведомление об успешном изменении. |

## 06. Путь: Поиск товаров  

#### Текстовое описание:  
1. Пользователь открывает главный экран приложения и вводит запрос в строку поиска.  
2. Использует фильтры (цена, состояние товара, местоположение).  
3. Нажимает кнопку "Найти" и видит результаты, отсортированные по релевантности.  
4. Переходит на страницу товара для более детального изучения.  

#### CJM: Поиск товаров  

| Этап                     | Действие пользователя                    | Эмоция/Ожидание                           | Возможные улучшения                  |
| ------------------------ | ---------------------------------------- | ----------------------------------------- | ------------------------------------ |
| Поиск товара             | Вводит запрос в строку поиска.           | Ожидание быстрого результата.             | Автозаполнение поисковых запросов.   |
| Настройка фильтров       | Устанавливает фильтры (цена, состояние). | Сомнение, правильно ли указаны параметры. | Пошаговая настройка фильтров.        |
| Получение результата     | Нажимает "Найти" и видит результаты.     | Интерес, желание найти лучший вариант.    | Предпросмотр товара в списке.        |
| Открытие карточки товара | Переходит на страницу товара.            | Уверенность в выборе.                     | Увеличить визуальную часть карточек. |
## 07. Путь: Добавление товара в вишлист  

### Текстовое описание:  
1. Пользователь открывает страницу с интересующим товаром.  
2. Нажимает кнопку "Добавить в отложенные".  
3. Товар отображается в разделе "Отложенные", доступном из главного меню.  
4. Пользователь может вернуться в раздел, чтобы просмотреть или удалить отложенные товары.  

### CJM: Добавление товара в вишлист  

| Этап                 | Действие пользователя                      | Эмоция/Ожидание                  | Возможные улучшения                 |
| -------------------- | ------------------------------------------ | -------------------------------- | ----------------------------------- |
| Выбор товара         | Пользователь выбирает понравившийся товар. | Удовлетворение, интерес.         | Добавить анимацию кнопки "вишлист". |
| Добавление в вишлист | Нажимает "Добавить в отложенные".          | Простота, ожидает подтверждения. | Добавить уведомление "Добавлено".   |
| Просмотр вишлиста    | Проверяет сохранённые товары.              | Радость от собранного списка.    | Возможность сортировки товаров.     |

## 08. Путь: Покупка товара

### Этапы взаимодействия:
1. Осознание потребности: Пользователь понимает, что ему нужен товар.  
2. Поиск и фильтрация: Использует поисковую строку и фильтры.  
3. Выбор товара: Оценивает варианты на основе описания и цены.  
4. Связь с продавцом: Пишет продавцу для уточнения деталей.  
5. Завершение сделки: Договаривается о доставке или встрече.  

| Этап              | Действие пользователя                 | Эмоция/Ожидание                        | Возможные улучшения                                 |
| ----------------- | ------------------------------------- | -------------------------------------- | --------------------------------------------------- |
| Осознание         | Решает, что нужен определённый товар. | Интерес, ожидание быстрых результатов. | Упростить доступ к популярным категориям.           |
| Поиск             | Настраивает фильтры и вводит запрос.  | Сомнение, удобно ли искать товар.      | Добавить больше фильтров (например, по шкалу цене). |
| Выбор             | Читает описание товара.               | Уверенность или неуверенность.         | Улучшить интерфейс карточек товара.                 |
| Связь с продавцом | Обсуждает условия.                    | Удовлетворение, если всё понятно.      | Внедрить безопасные встроенные чаты.                |
| Завершение        | Получает товар.                       | Радость от успешной покупки.           | Добавить отзывы о завершённых сделках.              |

## 09. Путь: Редактирование профиля пользователя  

### Текстовое описание:  
1. Пользователь заходит в раздел "Профиль".  
2. Нажимает кнопку "Редактировать".  
3. Изменяет данные: имя, номер телефона, адрес, ссылки на соцсети, фото профиля.  
4. Сохраняет изменения, которые тут же обновляются.  

### CJM: Редактирование профиля  

| Этап             | Действие пользователя             | Эмоция/Ожидание                 | Возможные улучшения                |
| ---------------- | --------------------------------- | ------------------------------- | ---------------------------------- |
| Открытие профиля | Пользователь заходит в "Профиль". | Удобство доступа.               | Быстрый доступ к редактированию.   |
| Редактирование   | Вносит изменения.                 | Надежда на корректность данных. | Валидация полей (пароль, телефон). |
| Сохранение       | Нажимает "Сохранить".             | Уверенность в результате.       | Уведомление об успешном изменении. |
# Бизнес логика
- Учет потребностей пользователей:
     - Поиск товара по наименованию.
     - Простая система публикации объявлений.
     - Интерактивные функции: чаты. (следующая версия приложения)
- Реализация более сложных сценариев, чем CRUD:
     - Логика обработки заказов. (следующая версия приложения)
     - Реализация рейтинговой системы для продавцов. (следующая версия приложения)
     - Настройка рекомендательной системы товаров. (следующая версия приложения)
- Валидация данных: проверка форматов введенных данных при заполнении форм создания товара и профиля пользователя.
- Система рейтингов: динамическое обновление рейтингов продавцов на основе отзывов покупателей. (следующая версия приложения)
- Рекомендательная система: товары предлагаются на основе предыдущих покупок и интересов пользователя. (следующая версия приложения)
# Руководство по запуску проекта
## Способ 1.
1. Скачать файл формата .exe/.app на мобильное устройство
2. Установить приложение с помощью встроенного в мобильное устройство установщика
3. Запустить приложение
## Способ 2.
1. Склонировать репозиторий проекта на свое утройство
	`git clone https://github.com/KABOPOK/PunkMarket.git`
2.  Перейти на ветку **dev**: 
	`git checkout dev`
3. Перейте в папку **server**:
	`cd server`
4. Сделать генерацию .jar файлов:
	`mvn package`
	\**при возникновении ошибок, связанных с версиями Java, необходимо выполнить один из следующих пунктов:*
		*-  установить на устройство версию Java.21*
		*- настроить версию java вручную:*
			*Внести изменения в файл ../server/pom.xml:* 			```
```
			<properties>
			    <java.version>${Ваша версия Java}</java.version>
			<//properties>  
```
5.  Поднять Docker контейнеры:
	`docker compose up`