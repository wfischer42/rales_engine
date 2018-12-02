[![Waffle.io - Columns and their card count](https://badge.waffle.io/wfischer42/rales_engine.svg?columns=all)](https://waffle.io/wfischer42/rales_engine)

Next Items
GET /api/v1/items/most_revenue?quantity=x returns the top x items ranked by total revenue generated
GET /api/v1/items/most_items?quantity=x returns the top x item instances ranked by total number sold
GET /api/v1/items/:id/best_day returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.

```
rake csvmodel:import["Merchant Customer Invoice Item InvoiceItem Transaction"]
```

```
Customer.where(id: Invoice.where("merchant_id = ?", mid)
                          .left_outer_joins(:transactions)
                          .group(:id)
                          .having("sum(COALESCE(transactions.result,0)) = 0")
                          .pluck("invoices.customer_id"))
```

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
