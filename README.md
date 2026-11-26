# Ticket Shop API

Backend service for a university web application lab, built to handle and validate the JSON data structure and schema created in previous labs.

Built using Ruby on Rails.

## How to run

Clone the repository, go into the directory, install dependencies:

```bash
git clone https://github.com/Stalker400n/Ticket_shop_API_uni.git
cd Ticket_shop_API_uni
bundle install
```

Launch the server:

```bash
rails server
```

## Tests

Current tests only cover the services in unit tests.

Running the tests:

```bash
rails test
```

Individual services tests:

```bash
rails test test/services/Chosen_module_test.rb
```

## Notes

 - Storage: This project does not use a database. Everything is saved directly to a JSON file, as required by the lab assignment.

 - CORS: CORS is not configured yet, as the frontend has not been built.
