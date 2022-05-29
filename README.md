# DbReporter

DbReporter automatically generates documents from Database

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add db_reporter

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install db_reporter

## Usage

### Comment on Database
To make effective use of DbReporter, please use the comment function of Database

example user table
```
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, comment: 'User' do |t|
      t.string :name, comment: 'name'
      t.string :email, comment: 'email'

      t.timestamps
    end
  end
end
```

## Generate by Rake

```
rails db_reporter:generate:markdown[docs/database/structure.md]
```
