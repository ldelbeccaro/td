# TD

## About
TD is a todo app that's a cross between a [GTD app](https://www.google.com/search?q=gtd+app) and a notes/organizational app like [Workflowy](https://workflowy.com). Nesting notes and subtasks are crucial in order to a) have all the context you need while performing a task and b) break up tasks into manageable pieces in order to get things done. Workflowy is great for this, but lacks other important functionality like due dates, recurring todos, and more. TD, in my very biased opinion, is the perfect blend. :)

## Setup

**Clone repo:**
* [ssh] `git clone git@github.com:ldelbeccaro/td`
* [https] `git clone https://github.com/ldelbeccaro/td`

**App setup:**
1. Install correct Ruby/Rails versions
```
Ruby: 2.3.4
Rails: 5.1.4
```
2. Install dependencies
```
gem install bundler
bundle install
yarn install
```
3. Dev db setup
`rake db:create && db:migrate && db:seed`
4. Test db setup
`rake db:create && db:migrate RAILS_ENV=test`

**Running tests:**
* [all tests] `rake spec`
* [specific file] `rspec <file_name>`
* [specific test] `rspec <file_name>:<starting_line_number>`

**Getting set up with Heroku:**
1. `heroku login`
2. `heroku git:remote -a ldb-td`

**Deploying to Heroku:**
1. `git push heroku master`
2. `heroku run -r ldb-td rake db:migrate`
3. `heroku restart -r ldb-td`

**TODO:**
1. services (job queues, cache servers, etc.)
