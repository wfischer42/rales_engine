[![Waffle.io - Columns and their card count](https://badge.waffle.io/wfischer42/rales_engine.svg?columns=all)](https://waffle.io/wfischer42/rales_engine)

# Rales Engine
## Readme
### Description

This is a Rails API project from the Turing School of Software and Design meant to build the foundational skills for creating REST-ful API applications in Rails. The name 'Rales Engine' is an homage to an earlier project with a component called 'Sales Engine' which used the same data, but handled the functionality with plain Ruby instead of SQL.

### Local Setup

The project was created with `Rails 5.2` on macOS Mojave, and hasn't been tested on other platforms.

To set it up and run it locally, first and clone. Run `bundle` from the command line to set up Gems, then run 'rake db:{create,migrate}' to initialize the database.

The data is seeded using a custom Rake task `csvmodel:import["<CLASS NAMES>"]` that takes a list of model class names we're importing to as an argument. The models must be ordered so that each primary key is introduced before any foreign key can reference it.

Use the following command to set it up for this project.
```
rake csvmodel:import["Merchant Customer Invoice Item InvoiceItem Transaction"]
```

After setup is complete, run `Rails s` to use the API endpoints locally.

### Endpoints
All endpoints descend from the `api/v1/` path. Here's a full path example:
```
http://localhost:3000/api/v1/items/12/best_day
```

The API provides the following endpoints:
```
'Merchant' Endpoints

api/v1/merchants
api/v1/merchants/:id
api/v1/merchants/most_revenue
api/v1/merchants/most_items
api/v1/merchants/revenue
api/v1/merchants/:id/revenue
api/v1/merchants/:id/favorite_customer
api/v1/merchants/:id/customers_with_pending_invoices

'Item' Endpoints

api/v1/items
api/v1/items/:id
api/v1/items/most_revenue
api/v1/items/most_items
api/v1/items/:id/best_day

'Customer' Endpoints

api/v1/customers
api/v1/customers/:id
api/v1/customers/:id/favorite_merchant
```
### Blog
If you're interested in some of the lessons I learned from this project, here's a [blog post](https://medium.com/@william.fischer42/misadventures-in-rest-ful-apis-fd42a4e76ba2) I wrote about it.
