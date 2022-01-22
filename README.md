# README

### Initial commit

Starting with the latest Ruby and Rails version at the time. We are choosing esbuild but as long as you can create a Stimulus controller and use it then your JavaScript tools won't matter.

```bash
$ ruby -v
ruby 3.1.0p0 (2021-12-25 revision fb4df44d16) [x86_64-darwin18]

$ rails -v
Rails 7.0.1

$ rails _7.0.1_ new select_ajax --javascript=esbuild
```

If you are following along, you will want to commit here with "Initial commit".

### Scripts "build" added to package.json

If you try to start the application, it will error and terminate.

```bash
 bin/dev                                                                                                     
10:39:36 web.1  | started with pid 2294
10:39:36 js.1   | started with pid 2295
10:39:36 js.1   | yarn run v1.22.0
10:39:37 js.1   | error Command "build" not found. <== *ERROR*
10:39:37 js.1   | info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
10:39:37 js.1   | exited with code 1
10:39:37 system | sending SIGTERM to all processes
10:39:37 web.1  | terminated by SIGTERM
```

The output of the rails new generator, above, includes this line:

```bash
Add "scripts": { "build": "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds" } to your package
```

We will add this code to package.json. When we run the application, "build" will be called if JavaScript hasn't been built or there has been a change in the JavaScript. The assembled JavaScript build is, by default, put into `app/assets/builds` where it is picked up by Rails Sprockets - see References for more information. 

#### package.json with "build" added
```json
{
  "name": "app",
  "private": "true",
  "dependencies": {
    "@hotwired/stimulus": "^3.0.1",
    "@hotwired/turbo-rails": "^7.1.1",
    "esbuild": "^0.14.12"
  },
  "scripts": {
    "build": "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds"
  }
}
```

Commit "Scripts 'build' added to package.json

### Post scaffold

We need an object model that the select box will change.

```bash
$ rails generate scaffold Post title:string likes:integer
```
If you're feeling advanced, you can reduce the amount of files produced by adding these flags onto the end of the above line.
```
--no-helper --no-assets --no-controller-specs --no-view-specs --no-test-framework --no-jbuilder                                         
```
The committed code will be generated with these flags, however, there will be no functional difference just less code.

Migrate the database creation file `db/migrate/***_create_posts.rb`

```bash
$ rails db:migrate
```

#### Verify

```bash
rails db:migrate:status

database: db/development.sqlite3

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20220121161042  Create posts
```


### Root set to posts#index (optional)

Add a root to the project, as it's one less thing to get wrong when you start the application. Remove comments and add the root line.

```ruby
Rails.application.routes.draw do
  resources :posts
  root "posts#index"  # <==== Add this
end
```

#### Verify root

```
rails routes -c post
Prefix  Verb   URI Pattern      Controller#Action
...     ...    ...              ...
root    GET    /                posts#index  # <== THIS
...     ...    ...              ...
```

Commit "Root set to posts#index"

### Start the application

Use `bin/dev` the Rails 7 way of starting the application. It should start and the final line should *not* be `exited with code 0`. 

```bash
bin/dev
18:01:42 web.1  | started with pid 22410
18:01:42 js.1   | started with pid 22411
18:01:42 js.1   | yarn run v1.22.0
18:01:42 js.1   | $ esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds --watch
18:01:42 js.1   | [watch] build finished, watching for changes...
18:01:43 web.1  | => Booting Puma
18:01:43 web.1  | => Rails 7.0.1 application starting in development
18:01:43 web.1  | => Run `bin/rails server --help` for more startup options
18:01:48 web.1  | Puma starting in single mode...
18:01:48 web.1  | * Puma version: 5.5.2 (ruby 3.1.0-p0) ("Zawgyi")
18:01:48 web.1  | *  Min threads: 5
18:01:48 web.1  | *  Max threads: 5
18:01:48 web.1  | *  Environment: development
18:01:48 web.1  | *          PID: 22410
18:01:48 web.1  | * Listening on http://127.0.0.1:3000
18:01:48 web.1  | * Listening on http://[::1]:3000
18:01:48 web.1  | Use Ctrl-C to stop
```

Commit the change with "Post scaffold".

### Post seed (optional)

I like to know what data I am working with at all times. I will add the following to `db/seeds.rb` whenever I run it, this is what I will have. However, you can skip and add the data using the scaffolded Post form.

```ruby
Post.delete_all

Post.create(title: "My first post", likes: 1)
Post.create(title: "My second post", likes: 1)
```

```bash
rails db:seed
```
#### Verify

```bash
$ rails c
Loading development environment (Rails 7.0.1)
irb(main):001:0> Post.all  <===== YOU TYPE THIS
   (4.2ms)  SELECT sqlite_version(*)
  Post Load (0.7ms)  SELECT "posts".* FROM "posts"
=>
[#<Post:0x000000010d2f9fa0
  id: 1,
  title: "My first post",
  likes: 1,
  created_at: Fri, 21 Jan 2022 16:39:01.276982000 UTC +00:00,
  updated_at: Fri, 21 Jan 2022 16:39:01.276982000 UTC +00:00>,
 #<Post:0x000000010d360070
  id: 2,
  title: "My second post",
  likes: 1,
  created_at: Fri, 21 Jan 2022 16:39:01.283099000 UTC +00:00,
  updated_at: Fri, 21 Jan 2022 16:39:01.283099000 UTC +00:00>]
```

Commit "Post seed"

### Rails select_tag

We want a `select_tag` on the page which is populated with numbers. The [Rails api has a section on the select tag](https://api.rubyonrails.org/classes/ActionView/Helpers/FormTagHelper.html#method-i-select_tag) and there are more complicated examples where text and values can be different and where data can come from another model, however, for this we are keeping it simple and just having numbers which represent the text and values.



### References

[GoRails - JSBundling with ESBuild](https://gorails.com/episodes/esbuild-jsbundling-rails)
[Drifting Ruby - esbuild for Rails](https://www.driftingruby.com/episodes/esbuild-for-rails)