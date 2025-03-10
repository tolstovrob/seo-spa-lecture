#import "conf.typ": conf

#show: conf.with(
  meta: (
    title: "SEO-оптимизация SPA",
    author: "Толстов Роберт Сергеевич",
    group: 251,
    city: "Саратов",
    year: 2025,
  )
)

= Что такое SEO?
*Search engine optimization* -- это процесс оптимизации сайта (а в нашем случае веб-приложения) для улучшения его видимости в поисковых системах.

Ведь в сети очень много сайтов, а пользователю нужно очень быстро выдавать релевантную информацию. Именно для этого существуют поисковые роботы, которые индексируют сайты по некоторым специальным метрикам, которые мы рассмотрим ниже.

По сути весь процесс поисковой индексации можно раззделить на 3 этапа:

- *Краулинг*: сбор данных посредством перехода по страницам сайта и их анализа.
- *Индексация*: данные обрабатываются и добавляются в индекс поисковой системы --- не вдаваясь в подробности курса Инны Александровны скажем, что это просто большая оптимизированная для поиска база данных.
- *Ранжирование*: происходит оценка страницы на основании специальных метрик. Далее, при пользовательском запросе, система выберет наиболее релевантные сайты и выдаст их.

== А зачем вообще SEO?

Глупый вопрос, на самом деле. Это необходимо и для бизнеса, чтобы обойти своих конкурентов, и для улучшения пользовательского опыта, чтобы на первой странице оказывались ожижаемые и нужные результаты.

== По каким метрикам определяется релевантность ресурса?

=== Технические метрики

К этому типу относят:
- Скорость загрузки.
- Адаптивность: например, движок Google использует mobile-first подход, то есть мобильная версия приоритенее.
- Доступность для самой индексации: есть robots.txt, sitemap.xml, canonical ссылки и т.п.
- Структура и читаемость URL.

=== Контентные метрики

Здесь важно содержимое сайта. К этим метрикам относят:
- Ключевые слова и семантика: например, если пользователь ищет "купить iPhone 15", роботы проверяют, есть ли эти слова в ```html <title>```, ```html <h1>```, ```html <meta name="description">``` и основном тексте.
- Уникальность контента.
- Доступность для пользователей: должны использоваться `alt` атрибуты для картинок, `aria` атрибуты.

Для продвинутых существует *микроразметка*. Мы не будем её рассматривать, лишь првиедём пример для того же запроса с iPhone 15.

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org/",
  "@type": "Product",
  "name": "iPhone 15",
  "description": "Новый iPhone 15 с улучшенной камерой.",
  "brand": {
    "@type": "Brand",
    "name": "Apple"
  }
}
</script>
```

=== Поведенческие метрики

Эти метрики связаны с тем, как пользователи взаимодействуют с сайтом.

- Время на сайте: чем дольше пользователи остаются на сайте, тем выше его релевантность.
- Показатель отказов.
- Глубина просмотра: пользователи должны просматривать несколько страниц за один визит.
- CTR (Click-Through Rate): высокий CTR в поисковой выдаче указывает на то, что заголовок и описание страницы релевантны запросу.

=== Внешние метрики

Эти метрики связаны с авторитетностью сайта и его популярностью в интернете.

- Обратные ссылки: чем больше качественных обратных ссылок (с авторитетных сайтов), тем выше релевантность. Например, если на сайт ссылаются Forbes или Wikipedia, это повышает доверие.
- Доверие домена: чем выше доверие к домену, тем выше релевантность. Например, если вы захостите свой сайт на github pages, то он будет одним из первых в поисковой выдаче по вашему запросу.

= Что такое SPA?

*Single page application* --- это современный подход к написанию веб-приложений. В последнее время он используется всё чаще обычного ввиду относительной простоты и скорости разработки и поддержки.

Он заключается в следующем: приложение загружает одну пустую (без значимого контента) страницу HTML, а далее её содержимое динамически изменяется по мере взаимодействия с пользователем.

Для дальнейшего исследования мы возьмём React и будем размышлять на тему того как поднимать React приложения в поиске.

= Готовь сани летом...

Конечно, было бы идеально, если бы ваша архитектура приложения позволяла оптимизации, о которых мы поговорим ниже. В идеале, вы должны продумывать такие вещи перед отплывом. Давайте же от этого и начнём толкаться!

== Server-Side Rendering (SSR)

Итак, наша основная проблема это то, что контента на старте страницы нет! Многие поисковые роботы до сих пор очень плохо исполняют JS, из-за чего ваша страница будет записана в индекс в том состоянии, в котором вы её "скормили" роботу:

#pagebreak(weak: true)

```html
<!DOCTYPE html>
<html>
  <head>
    <!-- Какие-то стили -->
  </head>
  <body>
    <div id="root"></div>
    <script src="index.js"></script>
  </body>
</html>
```

И непонятно как определять, релевантен ли ваш ресурс пользователю.

=== Отступление о мета-тегах

Вы, конечно, можете задаться вопросом: фундаментальная проблема, конечно, неоспорима, но что насчёт того, чтобы хотя бы добавить мета-теги? Ведь ```html <head>``` у нас есть, давайте просто отредактируем `app.html`?

Это, конечно, имеет смысл. Более того, это сработает, но только в том случае, если у вас действительно ровно 1 страница. Ведь мета-теги должны быть актуальны для каждой веб-страницы.

Дальше мы поговорим о технологиях, позволяющих динамически добавлять мета-теги к каждой странице.

Итак, вернёмся к проблеме пустой страницы. Наша схема выглядит на данный момент так:

#figure(image("images/csr.svg", width: 50%))

Как нам сделать так, чтобы мы получали контент сразу, не дожидаясь полной загрузки страницы? Отличным решением будет использование шаблонизаторов, но мы работаем с SPA. И именно для них используется SSR.

Давайте мы сделаем сервер-посредник между backend и client. Когда нам нужно что-то получить с сервера, мы обратимся к посреднику в лице метафреймворка, который будет общаться с сервером так как нужно. Схематично, это можно представить так:

#figure(image("images/ssr.svg", width: 50%))

Таким образом, поисковые роботы получат уже пререндеренную страницу и смогут её корректно обработать.