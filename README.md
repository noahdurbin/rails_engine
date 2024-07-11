# Rails Engine

Rails Engine is a Ruby on Rails API that provides endpoints for managing merchants and items in an e-commerce platform.

## Features

- RESTful API for Merchants and Items
- Advanced search functionality for both Merchants and Items
- Relationship endpoints (e.g., items for a merchant, merchant for an item)

## Setup

1. Clone the repository:
```
git clone https://github.com/noahdurbin/rails-engine.git
cd rails-engine
```

2. Install dependencies:
bundle install


3. Set up the database:
rails db:create db:migrate db:seed


4. Start the server:
```
rails server
```
## Running Tests

To run the test suite:
```
bundle exec rspec
```

## API Endpoints

- GET /api/v1/merchants
- GET /api/v1/merchants/:id
- GET /api/v1/merchants/:id/items
- GET /api/v1/merchants/find?name=#{name}
- GET /api/v1/merchants/find_all?name=#{name}

- GET /api/v1/items
- GET /api/v1/items/:id
- POST /api/v1/items
- PATCH /api/v1/items/:id
- DELETE /api/v1/items/:id
- GET /api/v1/items/:id/merchant
- GET /api/v1/items/find?name=#{name}
- GET /api/v1/items/find_all?name=#{name}
- GET /api/v1/items/find?min_price=#{price}
- GET /api/v1/items/find?max_price=#{price}

## Technologies

- Ruby 3.2.2
- Rails 7.1.3.4
- RSpec for testing
- Capybara
- Factory Bot for test data generation
- JSON:API serialization
