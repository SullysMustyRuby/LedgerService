# HayaiLedger

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

ease of use
integrations
customization of reports 
customization of use
easy to understand

mix phx.gen.json Users.Organization organizations name:string description:string
mix phx.gen.json Users.User users name:string email:string organization_id:references:organizations

mix phx.gen.json Api.Permission permissions name:string description:string

mix phx.gen.schema Ledgers.Ledger ledgers name:string description:string organization_id:references:organizations request_id:references:requests