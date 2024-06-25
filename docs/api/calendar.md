---
title: Pagy::Calendar
category:
  - Feature
  - Class
image: "none"
---

# Pagy::Calendar

This is a `Hash` subclass that organizes and tracks the `Calendar::Units` of the calendar system. It is used internally by the [Calendar extra](/docs/extras/calendar.md) that provides the high level API and returns the `calendar` hash (an instance of this class).

!!!warning Active Support Required
It requires the `activesupport` gem, which you have to require in your Gemfile only if your app does not use Rails.
!!!
  
The `Pagy::Calendar` instance is a hash containing a certain number of time units objects, keyed by their unit symbol.

## Methods

=== `showtime`

This method returns the current time of the smallest time unit shown. You can store it and retrieve the same calendar at a 
later time using the `pagy_calendar_url_at`

```ruby
pagy_calendar_url_at(@calendar, retrived_calendar_showtime)
```

===
